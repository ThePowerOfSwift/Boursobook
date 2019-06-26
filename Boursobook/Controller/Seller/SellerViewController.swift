//
//  SellerViewController.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SellerViewController: UIViewController {

    // MARK: - Properties
    var selectedSeller: Seller?

    // MARK: - IBOutlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var numberOfArticleSoldedLabel: UILabel!
    @IBOutlet weak var numberOfArticleToSoldLabel: UILabel!

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadValues()
    }

    // MARK: - functions
    private func loadValues() {
        guard let sellerToLoad = selectedSeller else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        firstNameLabel.text = sellerToLoad.firstName
        familyNameLabel.text = sellerToLoad.familyName
        emailLabel.text = sellerToLoad.email
        phoneLabel.text = sellerToLoad.phoneNumber
        codeLabel.text = sellerToLoad.code
        numberOfArticleSoldedLabel.text = String(sellerToLoad.itemsToSold)
        numberOfArticleToSoldLabel.text = String(sellerToLoad.soldedItem)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAddArticle" {
            if let addArticleVC = segue.destination as? AddArticleViewController {
                addArticleVC.selectedSeller = selectedSeller
            }
        }
        if segue.identifier == "segueToArticleList" {
            if let articleListVC = segue.destination as? ArticleListTableViewController {
                articleListVC.selectedSeller = selectedSeller
            }
        }
    }
}

// TODO:
//          - Imprimer la liste des articles vendus et restants
//              avec les prix de ventes / montants revenants au vendeur
//          - Calculer forfait d'insription en fonction du nombre d'article
//              ( et creer une vente fictive pour enregister transaction
//          - calcul du nombre d'article
//          - vue de la liste des articles
