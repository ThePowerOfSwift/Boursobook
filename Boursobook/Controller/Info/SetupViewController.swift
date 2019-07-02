//
//  SetupViewController.swift
//  Boursobook
//
//  Created by David Dubez on 01/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    // MARK: - IBActions
    @IBAction func didTapAddNewUser(_ sender: Any) {
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
                                                                                              title: NSLocalizedString("Error !", comment: ""))
                                                                        } else {
                                                                            self.displayAlert(message: NSLocalizedString("An email has been send to the new user !", comment: ""),
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// TODO: - Verouiller l'acces aux régalges si c'est pas delphine ????
