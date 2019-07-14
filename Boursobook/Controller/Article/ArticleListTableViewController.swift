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
        if let codeOfSeller = codeOfSelectedSeller {
            articlesToDisplay = InMemoryStorage.shared.filterArticles(by: codeOfSeller)
        }
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
           
            InMemoryStorage.shared.removeArticle(at: indexPath.row)
            articleListTableView.deleteRows(at: [indexPath], with: .automatic)
            articlesToDisplay.remove(at: indexPath.row)
            articleListTableView.reloadData()
            //FIXME: mettre un message pour confirmer l'effacement
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
}

// TODO :       - faire une tri des article suivant leur type
//              - afficher que les articles qui ne sont pas vendus
//              - gerer le format du prix
//              - Revoir la mise en forme de la cellule
