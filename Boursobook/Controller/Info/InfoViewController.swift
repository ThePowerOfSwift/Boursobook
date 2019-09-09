//
//  InfoViewController.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    // MARK: Properties
    let purseAPI = PurseAPI()
    var purseToDisplay: Purse?

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
        purseAPI.stopListen()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPurseToDisplay()
    }

    deinit {
        purseAPI.stopListen()
    }

    // MARK: - functions

    func loadPurseToDisplay() {
        guard let purseName = InMemoryStorage.shared.inWorkingPurseName else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        purseAPI.loadPurse(name: purseName) { (error, loadedPurse) in
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
            } else {
                guard let purse = loadedPurse else {
                    return
                }
                self.purseToDisplay = purse
                self.updateValues()
            }
        }

    }

    private func updateValues() {
        userLogInLabel.text = InMemoryStorage.shared.userLogIn?.email
        userLogInIDLabel.text = InMemoryStorage.shared.userLogIn?.uniqueID

        if let purse = purseToDisplay {
            currentPurseLabel.text = purse.name
            numberOfSellerLabel.text = String(purse.numberOfSellers)
            numberOfArticleRecordedLabel.text = String(purse.numberOfArticleRegistered)
            numberOfArticlesoldLabel.text = String(purse.numberOfArticlesold)
            numberOfSalesLabel.text = String(purse.numberOfTransaction)
            totalAmountOfSalesLabel.text = String(purse.totalSalesAmount)
            totalAmountOfSubscriptionLabel.text = String(purse.totalDepositFeeAmount)
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
        purseToDisplay = nil
        self.dismiss(animated: true, completion: nil)
    }
}
