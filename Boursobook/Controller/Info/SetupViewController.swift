//
//  SetupViewController.swift
//  Boursobook
//
//  Created by David Dubez on 01/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var percentageOnSalesDisplayLabel: UILabel!
    @IBOutlet weak var percentageOnSalesSetupLabel: UITextField!
    @IBOutlet weak var underFiftyDisplayLabel: UILabel!
    @IBOutlet weak var underFiftySetupLabel: UITextField!
    @IBOutlet weak var underOneHundredDisplayLabel: UILabel!
    @IBOutlet weak var underOneHundredSetupLabel: UITextField!
    @IBOutlet weak var underOneHundredFiftyDisplayLabel: UILabel!
    @IBOutlet weak var underOneHundredFiftySetupLabel: UITextField!
    @IBOutlet weak var underTwoHundredDisplayLabel: UILabel!
    @IBOutlet weak var underTwoHundredSetupLabel: UITextField!
    @IBOutlet weak var underTwoHundredFiftyDisplayLabel: UILabel!
    @IBOutlet weak var underTwoHundredFiftySetupLabel: UITextField!
    @IBOutlet weak var overTwoHundredFiftyDisplayLabel: UILabel!
    @IBOutlet weak var overTwoHundredFiftySetupLabel: UITextField!
    @IBOutlet weak var changeAmountButtonStackView: UIStackView!
    @IBOutlet weak var addNewUserButtonStackView: UIStackView!
    @IBOutlet weak var actionButtonStackView: UIStackView!
    @IBOutlet weak var configSheetStackView: UIStackView!

    // MARK: - IBActions
    @IBAction func didTapAddNewUser(_ sender: Any) {
       addNewUser()
    }
    @IBAction func didTapChangeAmountButton(_ sender: Any) {
        setDisplay(isConfiguring: true)
    }
    @IBAction func didTapConfirmButton(_ sender: Any) {
        saveValues()
        updateValues()
        setDisplay(isConfiguring: false)
    }
    @IBAction func didTapCancelButton(_ sender: Any) {
        updateValues()
        setDisplay(isConfiguring: false)
    }

    // MARK: - Properties
    var isConfiguring = false

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setDisplay(isConfiguring: false)
        updateValues()
        NotificationCenter.default.addObserver(self, selector: #selector(updateValues),
                                               name: InMemoryStorage.pursesUpdatedNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: InMemoryStorage.pursesUpdatedNotification,
                                                  object: nil)
    }

    // MARK: - Functions
    @objc private func updateValues() {
        if let currentPurse = InMemoryStorage.shared.currentPurse {
            percentageOnSalesDisplayLabel.text = String(currentPurse.percentageOnSales) + " %"
            percentageOnSalesSetupLabel.text = String(currentPurse.percentageOnSales)
            underFiftyDisplayLabel.text = String(currentPurse.depositFee.underFifty)
            underFiftySetupLabel.text = String(currentPurse.depositFee.underFifty)
            underOneHundredDisplayLabel.text = String(currentPurse.depositFee.underOneHundred)
            underOneHundredSetupLabel.text = String(currentPurse.depositFee.underOneHundred)
            underOneHundredFiftyDisplayLabel.text = String(currentPurse.depositFee.underOneHundredFifty)
            underOneHundredFiftySetupLabel.text = String(currentPurse.depositFee.underOneHundredFifty)
            underTwoHundredDisplayLabel.text = String(currentPurse.depositFee.underTwoHundred)
            underTwoHundredSetupLabel.text = String(currentPurse.depositFee.underTwoHundred)
            underTwoHundredFiftyDisplayLabel.text = String(currentPurse.depositFee.underTwoHundredFifty)
            underTwoHundredFiftySetupLabel.text = String(currentPurse.depositFee.underTwoHundredFifty)
            overTwoHundredFiftyDisplayLabel.text = String(currentPurse.depositFee.overTwoHundredFifty)
            overTwoHundredFiftySetupLabel.text = String(currentPurse.depositFee.overTwoHundredFifty)
        }
    }

    private func setDisplay(isConfiguring: Bool) {
        percentageOnSalesDisplayLabel.isHidden = isConfiguring
        underFiftyDisplayLabel.isHidden = isConfiguring
        underOneHundredDisplayLabel.isHidden = isConfiguring
        underOneHundredFiftyDisplayLabel.isHidden = isConfiguring
        underTwoHundredDisplayLabel.isHidden = isConfiguring
        underTwoHundredFiftyDisplayLabel.isHidden = isConfiguring
        overTwoHundredFiftyDisplayLabel.isHidden = isConfiguring

        percentageOnSalesSetupLabel.isHidden = !isConfiguring
        underFiftySetupLabel.isHidden = !isConfiguring
        underOneHundredSetupLabel.isHidden = !isConfiguring
        underOneHundredFiftySetupLabel.isHidden = !isConfiguring
        underTwoHundredSetupLabel.isHidden = !isConfiguring
        underTwoHundredFiftySetupLabel.isHidden = !isConfiguring
        overTwoHundredFiftySetupLabel.isHidden = !isConfiguring

        changeAmountButtonStackView.isHidden = isConfiguring
        addNewUserButtonStackView.isHidden = isConfiguring
        actionButtonStackView.isHidden = !isConfiguring
        configSheetStackView.isHidden = isConfiguring

    }

    private func saveValues() {
        guard   let percentageOnSalesSetupText = percentageOnSalesSetupLabel.text,
                let underFiftySetupText = underFiftySetupLabel.text,
                let underOneHundredSetupText = underOneHundredSetupLabel.text,
                let underOneHundredFiftySetupText = underOneHundredFiftySetupLabel.text,
                let underTwoHundredSetupText = underTwoHundredSetupLabel.text,
                let underTwoHundredFiftySetupText = underTwoHundredFiftySetupLabel.text,
                let overTwoHundredFiftySetupText = overTwoHundredFiftySetupLabel.text
                else {
                    return
        }

        guard   let percentageOnSalesValue = Double(percentageOnSalesSetupText),
                let underFiftySetupValue = Double(underFiftySetupText),
                let underOneHundredSetupValue = Double(underOneHundredSetupText),
                let underOneHundredFiftySetupValue = Double(underOneHundredFiftySetupText),
                let underTwoHundredSetupValue = Double(underTwoHundredSetupText),
                let underTwoHundredFiftySetupValue = Double(underTwoHundredFiftySetupText),
                let overTwoHundredFiftySetupValue = Double(overTwoHundredFiftySetupText) else {
            displayAlert(message: NSLocalizedString("Incorrect amount !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
            return
        }

        let depositFee = Purse.DepositFee(underFifty: underFiftySetupValue,
                                          underOneHundred: underOneHundredSetupValue,
                                          underOneHundredFifty: underOneHundredFiftySetupValue,
                                          underTwoHundred: underTwoHundredSetupValue,
                                          underTwoHundredFifty: underTwoHundredFiftySetupValue,
                                          overTwoHundredFifty: overTwoHundredFiftySetupValue)
        InMemoryStorage.shared.setupCurrentPurseRates(percentage: percentageOnSalesValue, depositFee: depositFee)

    }

    private func addNewUser() {
        displayAlert(message: NSLocalizedString("Sorry, it's note possible yet !", comment: ""),
                     title: NSLocalizedString("Error !", comment: ""))
    }
}
