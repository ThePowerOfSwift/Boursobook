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
    @IBOutlet weak var changePurseButton: UIButton!

    // MARK: - IBActions
    @IBAction func didTapChangePurseButton(_ sender: UIButton) {
        confirmChangePurse()
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        InMemoryStorage.shared.stopPurseListen()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateValues()
        InMemoryStorage.shared.onPurseUpdate = { () in
            self.updateValues()
        }
    }

    // MARK: - functions
    private func updateValues() {
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

    private func setStyleOfVC() {
        changePurseButton.layer.cornerRadius = 10
    }

    private func confirmChangePurse() {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""),
                                      message: NSLocalizedString("Are you sure you want to change the current purse ?",
                                                                 comment: ""),
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default)
        let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (_) in
            self.changePurse()
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func changePurse() {
        InMemoryStorage.shared.resetDataForCurrentPurse()
        self.dismiss(animated: true, completion: nil)
    }
}
