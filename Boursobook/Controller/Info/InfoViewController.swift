//
//  InfoViewController.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var userLogInLabel: UILabel!
    @IBOutlet weak var userLogInIDLabel: UILabel!
    @IBOutlet weak var currentPurseLabel: UILabel!
    @IBOutlet weak var numberOfSellerLabel: UILabel!
    @IBOutlet weak var numberOfArticleRecordedLabel: UILabel!
    @IBOutlet weak var numberOfArticlesoldLabel: UILabel!
    @IBOutlet weak var numberOfSalesLabel: UILabel!
    @IBOutlet weak var totalAmountOfSalesLabel: UILabel!
    @IBOutlet weak var totalAmountOfSubscriptionLabel: UILabel!

    // MARK: - IBActions

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateValues),
                                               name: InMemoryStorage.pursesUpdatedNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: InMemoryStorage.pursesUpdatedNotification,
                                                  object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateValues()
    }

    // MARK: - functions
    @objc private func updateValues() {
        userLogInLabel.text = UserService.shared.userLogIn?.email
        userLogInIDLabel.text = UserService.shared.userLogIn?.uid

        if let currentPurse = InMemoryStorage.shared.currentPurse {
            currentPurseLabel.text = currentPurse.name
            numberOfSellerLabel.text = String(currentPurse.numberOfSellers)
            numberOfArticleRecordedLabel.text = String(currentPurse.numberOfArticleRegistered)
            numberOfArticlesoldLabel.text = String(currentPurse.numberOfArticlesold)
            numberOfSalesLabel.text = String(currentPurse.numberOfTransaction)
            totalAmountOfSalesLabel.text = String(currentPurse.totalSalesAmount)
            totalAmountOfSubscriptionLabel.text = String(currentPurse.totalDepositFeeAmount)
        }
    }
}

// TODO:    - Ajouter un bouton pour acces liste transaction
//          - Ajouter bouton liste articles totaux
//          - Ajouter un contact pour mailing list
//          - Afficher qu'un email a bien été envoye à l'emeil du la création
