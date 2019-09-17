//
//  SetupViewController.swift
//  Boursobook
//
//  Created by David Dubez on 01/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    // MARK: - Properties
    var isConfiguring = false
    let purseAPI = PurseAPI()
    var displayedPurse: Purse?
    var activeTextField: UITextField?

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

    @IBOutlet weak var changeAmountsButton: UIButton!
    @IBOutlet weak var addNewUserButton: UIButton!
    @IBOutlet weak var configLabelSheetButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!

    // MARK: - IBActions
    @IBAction func didTapAddNewUser(_ sender: Any) {
        if userIsAdministrator() {
            addNewUser()
        } else {
            displayAlert(message: NSLocalizedString("Sorry, You are not administrator of this purse", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
        }
    }

    @IBAction func didTapChangeAmountButton(_ sender: Any) {
        if userIsAdministrator() {
            setDisplay(isConfiguring: true)
        } else {
            displayAlert(message: NSLocalizedString("Sorry, You are not administrator of this purse", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
        }
    }
    @IBAction func didTapConfirmButton(_ sender: Any) {
        saveValues()
    }
    @IBAction func didTapCancelButton(_ sender: Any) {
        updateValues()
        setDisplay(isConfiguring: false)
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()
        setDisplay(isConfiguring: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotification()
        loadPurseToDisplay()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
    }

    deinit {
        purseAPI.stopListen()
    }

    // MARK: - Functions

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
        if let purse = displayedPurse {
            percentageOnSalesDisplayLabel.text = formatDiplayedNumber(purse.percentageOnSales)
            percentageOnSalesSetupLabel.text = formatDiplayedNumber(purse.percentageOnSales)
            underFiftyDisplayLabel.text = formatDiplayedNumber(purse.depositFee.underFifty)
            underFiftySetupLabel.text = formatDiplayedNumber(purse.depositFee.underFifty)
            underOneHundredDisplayLabel.text = formatDiplayedNumber(purse.depositFee.underOneHundred)
            underOneHundredSetupLabel.text = formatDiplayedNumber(purse.depositFee.underOneHundred)
            underOneHundredFiftyDisplayLabel.text = formatDiplayedNumber(purse.depositFee.underOneHundredFifty)
            underOneHundredFiftySetupLabel.text = formatDiplayedNumber(purse.depositFee.underOneHundredFifty)
            underTwoHundredDisplayLabel.text = formatDiplayedNumber(purse.depositFee.underTwoHundred)
            underTwoHundredSetupLabel.text = formatDiplayedNumber(purse.depositFee.underTwoHundred)
            underTwoHundredFiftyDisplayLabel.text = formatDiplayedNumber(purse.depositFee.underTwoHundredFifty)
            underTwoHundredFiftySetupLabel.text = formatDiplayedNumber(purse.depositFee.underTwoHundredFifty)
            overTwoHundredFiftyDisplayLabel.text = formatDiplayedNumber(purse.depositFee.overTwoHundredFifty)
            overTwoHundredFiftySetupLabel.text = formatDiplayedNumber(purse.depositFee.overTwoHundredFifty)
        }
    }

    private func userIsAdministrator() -> Bool {
        guard let purse = displayedPurse, let user = InMemoryStorage.shared.userLogIn else {
            return false
        }
        for (key, value) in purse.administrators {
            if key == user.email && value == true {
               return true
            }
        }
        return false
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

        guard   let percentageOnSalesValue = valueForTextField(percentageOnSalesSetupLabel),
                let underFiftySetupValue = valueForTextField(underFiftySetupLabel),
                let underOneHundredSetupValue = valueForTextField(underOneHundredSetupLabel),
                let underOneHundredFiftySetupValue = valueForTextField(underOneHundredFiftySetupLabel),
                let underTwoHundredSetupValue = valueForTextField(underTwoHundredSetupLabel),
                let underTwoHundredFiftySetupValue = valueForTextField(underTwoHundredFiftySetupLabel),
                let overTwoHundredFiftySetupValue = valueForTextField(overTwoHundredFiftySetupLabel) else {
            displayAlert(message: NSLocalizedString("Incorrect amount !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
            return
        }

        guard let purse = displayedPurse else {
            return
        }

        let depositFee = Purse.DepositFee(underFifty: underFiftySetupValue,
                                          underOneHundred: underOneHundredSetupValue,
                                          underOneHundredFifty: underOneHundredFiftySetupValue,
                                          underTwoHundred: underTwoHundredSetupValue,
                                          underTwoHundredFifty: underTwoHundredFiftySetupValue,
                                          overTwoHundredFifty: overTwoHundredFiftySetupValue)

        purseAPI.setRates(purse: purse, percentage: percentageOnSalesValue,
                          depositFee: depositFee) { (error) in
                            if let error = error {
                                self.displayAlert(
                                    message: error.message,
                                    title: NSLocalizedString(
                                        "Error !", comment: ""))
                            } else {
                                self.updateValues()
                                self.setDisplay(isConfiguring: false)
                            }
        }
    }

    private func addNewUser() {
        self.performSegue(withIdentifier: "segueToUserList", sender: nil)
    }

    private func setStyleOfVC() {
        changeAmountsButton.layer.cornerRadius = 10
        addNewUserButton.layer.cornerRadius = 10
        configLabelSheetButton.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
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

    private func valueForTextField(_ textField: UITextField) -> Double? {
        guard let textFieldValue = textField.text else {
            return nil
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let formattedNumber = formatter.number(from: textFieldValue) {
            return Double(truncating: formattedNumber)
        } else {
            return nil
        }
    }
}

// MARK: - KEYBOARD
extension SetupViewController: UITextFieldDelegate {

    @IBAction func dismissKeyboard(_ sender: Any) {
        resignAllTextField()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    private func resignAllTextField() {
        percentageOnSalesSetupLabel.resignFirstResponder()
        underFiftySetupLabel.resignFirstResponder()
        underOneHundredSetupLabel.resignFirstResponder()
        underOneHundredFiftySetupLabel.resignFirstResponder()
        underTwoHundredSetupLabel.resignFirstResponder()
        underTwoHundredFiftySetupLabel.resignFirstResponder()
        overTwoHundredFiftySetupLabel.resignFirstResponder()
    }

    @objc func keyboardWasShown(notification: NSNotification) {
        var userInfo = notification.userInfo!
        guard let keyboardFrameBegin = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardSize = keyboardFrameBegin.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        mainScrollView.contentInset = contentInsets
        mainScrollView.scrollIndicatorInsets = contentInsets

        var aRect = self.view.frame
        aRect.size.height -= keyboardSize.height

        guard let activeTextField = activeTextField else {
            return
        }
        if !aRect.contains(activeTextField.frame.origin) {
            mainScrollView.scrollRectToVisible(activeTextField.frame, animated: true)
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        mainScrollView.contentInset = contentInsets
        mainScrollView.scrollIndicatorInsets = contentInsets
    }

    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
    }
}
