//
//  LoginViewController.swift
//  Boursobook
//
//  Created by David Dubez on 27/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    // MARK: Properties
    let userAPI = UserAPI()

    // MARK: IBOutlets
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logStackView: UIStackView!
    @IBOutlet weak var loginButton: UIButton!

    // MARK: IBActions
    @IBAction func didTapLogin(_ sender: Any) {
        if let loginEmailValue = loginEmailTextField.text, let loginPasswordValue = loginPasswordTextField.text {
            login(identifiant: loginEmailValue, password: loginPasswordValue)

        } else {
            displayAlert(message: NSLocalizedString("Please, fill all the field !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
        }
    }

    @IBAction func didTapRegister(_ sender: Any) {
        registerNewUser()
    }

    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
    }

    // MARK: OverRide
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()
    }

    // MARK: Function

    func login(identifiant: String, password: String) {
        toogleActivity(logging: true)
        userAPI.signInUser(email: identifiant, password: password) { (error, userLogIn) in
            self.toogleActivity(logging: false)
            if let error = error {
                self.displayAlert(message: NSLocalizedString(error.message, comment: ""),
                                  title: NSLocalizedString("Error !", comment: ""))
            } else {
                InMemoryStorage.shared.userLogIn = userLogIn
                self.performSegue(withIdentifier: "segueToSelectPurse", sender: nil)
            }
        }
    }

    func toogleActivity(logging: Bool) {
        activityIndicator.isHidden = !logging
        logStackView.isHidden = logging
    }

    func setStyleOfVC() {
         loginButton.layer.cornerRadius = 10
    }

    private func registerNewUser() {
        toogleActivity(logging: true)
        let alert = UIAlertController(title: NSLocalizedString("Register", comment: ""),
                                      message: NSLocalizedString("New user", comment: ""),
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""),
                                       style: .default) { _ in
                                        guard let emailTextFieldValue = alert.textFields?[0].text else {
                                            self.toogleActivity(logging: false)
                                            return
                                        }
                                        guard let passwordTextFieldValue = alert.textFields?[1].text else {
                                            self.toogleActivity(logging: false)
                                            return
                                        }
                                        self.userAPI.createUser(email: emailTextFieldValue, password: passwordTextFieldValue, completionHandler: { (error, userCreated) in
                                            self.toogleActivity(logging: false)
                                            if let error = error {
                                                self.displayAlert(
                                                    message: error.message,
                                                    title: NSLocalizedString(
                                                        "Error !", comment: ""))
                                            } else {
                                                self.displayAlert(message:
                                                    NSLocalizedString(
                                                        "An email has been send to the new user !",
                                                        comment: ""),
                                                                  title: NSLocalizedString("It's ok !", comment: ""))
                                                if let userCreated = userCreated {
                                                    self.loginEmailTextField.text = userCreated.email
                                                }
                                            }
                                        })
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default) { _ in
                                            self.toogleActivity(logging: false)
        }

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

// MARK: - KEYBOARD
extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginEmailTextField {
            loginPasswordTextField.becomeFirstResponder()
        }
        if textField == loginPasswordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
