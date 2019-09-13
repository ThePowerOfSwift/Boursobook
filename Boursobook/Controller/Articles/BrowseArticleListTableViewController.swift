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
    var articlesToDisplay = [Article]()
    var codeOfSelectedArticle: String?

    // MARK: - IBOutlets
    @IBOutlet var articleListTableView: UITableView!

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()

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
        articlesToDisplay = InMemoryStorage.shared.filterNosoldArticles()
        for (articleCode, _) in InMemoryStorage.shared.currentTransaction.articles {
            for (index, article) in articlesToDisplay.enumerated() where article.code == articleCode {
                articlesToDisplay.remove(at: index)
            }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "browseArticleCell",
                                                       for: indexPath) as? BrowseArticleTableViewCell else {
                                                        return UITableViewCell()
        }

        let article = articlesToDisplay[indexPath.row]
        cell.configure(with: article)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        codeOfSelectedArticle = articlesToDisplay[indexPath.row].code
        self.performSegue(withIdentifier: "segueToArticleFromBrowseArticle", sender: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToArticleFromBrowseArticle" {
            if let articleVC = segue.destination as? ArticleViewController {
                articleVC.codeOfSelectedArticle = codeOfSelectedArticle
                articleVC.isRegisterSale = true
            }
        }
    }
}
