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
    var selectedSeller: Seller?
    var displayedArticles = [Article]()
    var selectedArticleCode: String?
    let articleAPI = ArticleAPI()

    // MARK: - IBOutlets
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet var articleListTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        guard let seller = selectedSeller else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        sellerNameLabel.text = NSLocalizedString("Articles of  ", comment: "")
            + seller.firstName + " " + seller.familyName
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateValues()
        loadArticlesToDisplay()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        articleAPI.stopListen()
    }

    deinit {
        articleAPI.stopListen()
    }

    // MARK: - functions
    func updateValues() {
        articleListTableView.reloadData()
    }

    private func loadArticlesToDisplay() {
        guard let seller = selectedSeller else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        articleAPI.loadArticlesFor(seller: seller) { (error, loadedArticles) in
            self.activityIndicator.isHidden = true
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
            } else {
                guard let articles = loadedArticles else {
                    return
                }
                self.displayedArticles = articles
                self.updateValues()
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedArticles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleListCell",
                                                       for: indexPath) as? ArticleListTableViewCell else {
                                                        return UITableViewCell()
        }

        let article = displayedArticles[indexPath.row]
        cell.configure(with: article)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticleCode = displayedArticles[indexPath.row].code
        self.performSegue(withIdentifier: "segueToArticleFromArticleList", sender: nil)
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let articleToDelete = displayedArticles[indexPath.row]
            displayAlertConfirmDelete(for: articleToDelete)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToArticleFromArticleList" {
            if let articleVC = segue.destination as? ArticleViewController {
                articleVC.selectedArticleCode = selectedArticleCode
                articleVC.isRegisterSale = false
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
            self.articleAPI.removeArticle(purse: InMemoryStorage.shared.inWorkingPurse,
                                          seller: self.selectedSeller, article: article) { (error) in
                                            if let error = error {
                                                self.displayAlert(
                                                    message: error.message,
                                                    title: NSLocalizedString(
                                                        "Error !", comment: ""))
                                                return
                                            } else {
                                                self.updateValues()
                                            }
            }
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
