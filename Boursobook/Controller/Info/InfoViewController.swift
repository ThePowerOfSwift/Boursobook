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
    var displayedPurse: Purse?

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
    @IBOutlet weak var totalAmountOfBenefit: UILabel!
    @IBOutlet weak var numberOfArticlesToReturnLabel: UILabel!

    // MARK: - IBActions
    @IBAction func didTapChangePurseButton(_ sender: UIButton) {
        confirmChangePurse()
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPurseToDisplay()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        purseAPI.stopListen()
    }

    deinit {
        purseAPI.stopListen()
    }

    // MARK: - functions

    private func loadPurseToDisplay() {
        guard let purse = InMemoryStorage.shared.inWorkingPurse else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        purseAPI.loadPurse(name: purse.name) { (error, loadedPurse) in
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
            } else {
                guard let purse = loadedPurse else {
                    return
                }
                self.displayedPurse = purse
                InMemoryStorage.shared.inWorkingPurse = purse
                self.updateValues()
            }
        }

    }

    private func updateValues() {
        userLogInLabel.text = InMemoryStorage.shared.userLogIn?.email
        userLogInIDLabel.text = InMemoryStorage.shared.userLogIn?.uniqueID

        if let purse = displayedPurse {
            currentPurseLabel.text = purse.name
            numberOfSellerLabel.text = String(purse.numberOfSellers)
            numberOfArticleRecordedLabel.text = String(purse.numberOfArticleRegistered)
            numberOfArticlesToReturnLabel.text =
                String(purse.numberOfArticleRegistered - purse.numberOfArticlesold - purse.numberOfArticleReturned)
            numberOfArticlesoldLabel.text = String(purse.numberOfArticlesold)
            numberOfSalesLabel.text = String(purse.numberOfSales)
            totalAmountOfSalesLabel.text = formatDiplayedNumber(purse.totalSalesAmount)
            totalAmountOfSubscriptionLabel.text = formatDiplayedNumber(purse.totalDepositFeeAmount)
            totalAmountOfBenefit.text = formatDiplayedNumber(purse.totalBenefitOnSalesAmount)
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
        displayedPurse = nil
        InMemoryStorage.shared.inWorkingPurse = nil
        self.dismiss(animated: true, completion: nil)
    }

    private func formatDiplayedNumber(_ number: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
            return formattedNumber
        } else {
            return nil
        }
    }

    // MARK: - Navigation
    @IBAction func unwindToInfoVC(segue: UIStoryboardSegue) { }
}
