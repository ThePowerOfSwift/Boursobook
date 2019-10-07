//
//  BrowseArticleListTableViewController.swift
//  Boursobook
//
//  Created by David Dubez on 17/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class BrowseArticleListTableViewController: UITableViewController {

    // MARK: - Properties
    var displayedArticles = [Article]()
    var selectedArticleCode: String?
    let articleAPI = ArticleAPI()
    var currentSale: Sale?

    // MARK: - IBOutlets
    @IBOutlet var articleListTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
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
        guard let currentSale = currentSale else {
            return
        }
        for articleCode in currentSale.inArticlesCode {
            for (index, article) in displayedArticles.enumerated() where article.code == articleCode {
                displayedArticles.remove(at: index)
            }
        }
        articleListTableView.reloadData()
    }

    private func loadArticlesToDisplay() {

        articleAPI.loadNoSoldArticlesFor(purse: InMemoryStorage.shared.inWorkingPurse) { (error, loadedArticles) in
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "browseArticleCell",
                                                       for: indexPath) as? BrowseArticleTableViewCell else {
                                                        return UITableViewCell()
        }

        let article = displayedArticles[indexPath.row]
        cell.configure(with: article)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticleCode = displayedArticles[indexPath.row].code
        self.performSegue(withIdentifier: "segueToArticleFromBrowseArticle", sender: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToArticleFromBrowseArticle" {
            if let articleVC = segue.destination as? ArticleViewController {
                articleVC.selectedArticleCode = selectedArticleCode
                articleVC.isRegisterSale = true
            }
        }
    }
}
