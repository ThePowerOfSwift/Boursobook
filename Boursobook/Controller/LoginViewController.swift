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

    // MARK: IBActions
    @IBAction func didTapLogin(_ sender: Any) {
        performSegue(withIdentifier: "segueToApp", sender: nil)
    }
    @IBAction func didTapLoginAsGuest(_ sender: Any) {
        displayAlert(message: NSLocalizedString("Sorry, it's note possible yet !", comment: ""),
                     title: NSLocalizedString("Error !", comment: ""))
    }

    // MARK: OverRide
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Functions
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
// TODO: - Mettre à jour les string du storyboard

