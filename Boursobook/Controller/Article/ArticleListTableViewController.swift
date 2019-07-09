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
    var articlesToDisplay = [Article]()
    var selectedArticle: Article?

    // MARK: - IBOutlets
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet var articleListTableView: UITableView!

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let seller = selectedSeller else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        sellerNameLabel.text = NSLocalizedString("Articles of  ", comment: "") + seller.firstName + " " + seller.familyName

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let seller = selectedSeller {
            articlesToDisplay = ArticleService.shared.filtered(by: seller)
        }
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
        selectedArticle = articlesToDisplay[indexPath.row]
        self.performSegue(withIdentifier: "segueToArticle", sender: nil)
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ArticleService.shared.remove(at: indexPath.row)
            articleListTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToArticle" {
            if let articleVC = segue.destination as? ArticleViewController {
                articleVC.selectedArticle = selectedArticle
            }
        }
    }
}

// TODO :       - faire une tri des article suivant leur type
//              - afficher que les articles qui ne sont pas vendus
//              - gerer le format du prix
//              - Revoir la mise en forme de la cellule
