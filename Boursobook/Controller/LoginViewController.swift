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

    // MARK: IBOutlets
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logStackView: UIStackView!

    // MARK: IBActions
    @IBAction func didTapLogin(_ sender: Any) {
        if let loginEmailValue = loginEmailTextField.text, let loginPasswordValue = loginPasswordTextField.text {
            toogleActivity(logging: true)
            UserService.shared.signInUser(email: loginEmailValue, password: loginPasswordValue) { (error) in
                if let error = error {
                    self.toogleActivity(logging: false)
                    self.displayAlert(message: NSLocalizedString(error.message, comment: ""),
                                 title: NSLocalizedString("Error !", comment: ""))
                } else {
                    PurseService.shared.downloadData(completionHandler: { (done) in
                        if done {
                            ArticleService.shared.titleOrderedQuery(completionHandler: { (_) in })
                            self.toogleActivity(logging: false)
                            self.performSegue(withIdentifier: "segueToApp", sender: nil)
                        }
                    })
                }
            }
        } else {
            displayAlert(message: NSLocalizedString("Please, fill all the field !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
        }
    }

    @IBAction func didTapLoginAsGuest(_ sender: Any) {
        displayAlert(message: NSLocalizedString("Sorry, it's note possible yet !", comment: ""),
                     title: NSLocalizedString("Error !", comment: ""))

    }

    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
    }

    // MARK: OverRide
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Function
    func toogleActivity(logging: Bool) {
        activityIndicator.isHidden = !logging
        logStackView.isHidden = logging
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
// TODO:    - faire disparaitre le login si on est déja logé
//          - Gestion des mots de passe et des fonction save et login
//          - Login as a guest ??
//          - gestion de l'appli offligne
// TODO:    - Mettre à jour les string du storyboard
