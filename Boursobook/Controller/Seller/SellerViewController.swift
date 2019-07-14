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
    var codeOfSelectedSeller: String?

    // MARK: - IBOutlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var numberOfArticleSoldedLabel: UILabel!
    @IBOutlet weak var numberOfArticleRegisteredLabel: UILabel!
    @IBOutlet weak var amountDepositFeeLabel: UILabel!
    @IBOutlet weak var amountOfSalesLabel: UILabel!
    @IBOutlet weak var numerOfArticleToReturnLabel: UILabel!
    @IBOutlet weak var numberReturnedCheckedSwitch: UISwitch!

    // MARK: - IBActions
    @IBOutlet weak var didTapPrintButton: UIButton!
    @IBOutlet weak var didTapRefundButton: UIButton!

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateValues),
                                               name: InMemoryStorage.sellerUpdatedNotification,
                                               object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateValues()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: InMemoryStorage.sellerUpdatedNotification,
                                                  object: nil)
    }

    // MARK: - functions
    @objc private func updateValues() {

        guard let code = codeOfSelectedSeller else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        if let displayedSeller = InMemoryStorage.shared.selectSellerWithCode(code) {

            firstNameLabel.text = displayedSeller.firstName
            familyNameLabel.text = displayedSeller.familyName
            emailLabel.text = displayedSeller.email
            phoneLabel.text = displayedSeller.phoneNumber
            codeLabel.text = displayedSeller.code
            createdByLabel.text = displayedSeller.createdBy
            numberOfArticleRegisteredLabel.text = String(displayedSeller.articleRegistered)
            amountDepositFeeLabel.text = String(displayedSeller.depositFeeAmount)
            numberOfArticleSoldedLabel.text = String(displayedSeller.articleSolded)
            amountOfSalesLabel.text = String(displayedSeller.salesAmount)
            numerOfArticleToReturnLabel.text = String(displayedSeller.articleRegistered - displayedSeller.articleSolded)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAddArticle" {
            if let addArticleVC = segue.destination as? AddArticleViewController {
                addArticleVC.codeOfSelectedSeller = codeOfSelectedSeller
            }
        }
        if segue.identifier == "segueToArticleList" {
            if let articleListVC = segue.destination as? ArticleListTableViewController {
                articleListVC.codeOfSelectedSeller = codeOfSelectedSeller
            }
        }
    }
}

// TODO:    - Mettre la posibilité de modifier les informations des vendeurs
//          - Imprimer la liste des articles vendus et restants
//              avec les prix de ventes / montants revenants au vendeur
//          - Calculer forfait d'insription en fonction du nombre d'article
//              ( et creer une vente fictive pour enregister transaction
//          - calcul du nombre d'article
//          - vue de la liste des articles ( dans cette vue)
//          - Mettre les chiffres au format
//          - Traiter la partie pour la restitution des livres
