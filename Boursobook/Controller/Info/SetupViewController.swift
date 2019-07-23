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
        let alert = UIAlertController(title: NSLocalizedString("Register", comment: ""),
                                      message: NSLocalizedString("New user", comment: ""),
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""),
                                       style: .default) { _ in
                                        guard let emailTextFieldValue = alert.textFields?[0].text else {
                                            return
                                        }
                                        guard let passwordTextFieldValue = alert.textFields?[1].text else {
                                            return
                                        }

                                    UserService.shared.createUser(email: emailTextFieldValue,
                                                                      password: passwordTextFieldValue,
                                                                      callBack: { (error) in
                                                                        if let error = error {
                                                                        self.displayAlert(message: error.message,
                                                                        title: NSLocalizedString("Error !",
                                                                        comment: ""))
                                                                        } else {
                                                                            self.displayAlert(message:
                                    NSLocalizedString("An email has been send to the new user !", comment: ""),
                                    title: NSLocalizedString("It's ok !", comment: ""))
                                                                        }
                                        })
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default)

        alert.addTextField { textEmail in
            textEmail.placeholder = NSLocalizedString("Enter your email", comment: "")
            textEmail.keyboardType = .emailAddress
        }

        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = NSLocalizedString("Enter your password", comment: "")
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)

    }
}
// TODO:    - Ajouter le reglage pour la page d'impression
//           - Verouiller l'acces aux régalges si c'est pas delphine ????
//           - Mettre des valuers avec virgules pour voir si le format passe`
//          - metter une verification au max à 100% sur le pourcentage
