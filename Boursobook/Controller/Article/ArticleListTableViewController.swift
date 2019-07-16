//
//  ArticleListTableViewController.swift
//  Boursobook
//
//  Created by David Dubez on 25/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class ArticleListTableViewController: UITableViewController {

    // MARK: - Properties
    var codeOfSelectedSeller: String?
    var articlesToDisplay = [Article]()
    var codeOfSelectedArticle: String?

    // MARK: - IBOutlets
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet var articleListTableView: UITableView!

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let codeOfSeller = codeOfSelectedSeller else {
            self.navigationController?.popViewController(animated: true)
            return
        }

        for seller in InMemoryStorage.shared.sellers where seller.code == codeOfSeller {
            sellerNameLabel.text = NSLocalizedString("Articles of  ", comment: "")
                + seller.firstName + " " + seller.familyName
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateValues),
                                               name: InMemoryStorage.articleUpdatedNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: InMemoryStorage.articleUpdatedNotification,
                                                  object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateValues()
    }

    // MARK: - functions
    @objc func updateValues() {
        articlesToDisplay = InMemoryStorage.shared.filterArticles(by: codeOfSelectedSeller)
        articleListTableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesToDisplay.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleListCell",
                                                       for: indexPath) as? ArticleListTableViewCell else {
                                                        return UITableViewCell()
        }

        let article = articlesToDisplay[indexPath.row]
        cell.configure(with: article)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        codeOfSelectedArticle = articlesToDisplay[indexPath.row].code
        self.performSegue(withIdentifier: "segueToArticle", sender: nil)
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let articleToDelete = articlesToDisplay[indexPath.row]
            displayAlertConfirmDelete(for: articleToDelete)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToArticle" {
            if let articleVC = segue.destination as? ArticleViewController {
                articleVC.codeOfSelectedArticle = codeOfSelectedArticle
            }
        }
    }

    // MARK: - AlertControler
    private func displayAlertConfirmDelete(for article: Article) {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""),
                                      message: NSLocalizedString("Are you sure you want to delete this article ?",
                                                                 comment: ""),
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default)
        let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (_) in
            InMemoryStorage.shared.removeArticle(article)
            self.updateValues()
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

// TODO :       - faire une tri des article suivant leur type
//              - afficher que les articles qui ne sont pas vendus
//              - gerer le format du prix
//              - Revoir la mise en forme de la cellule
