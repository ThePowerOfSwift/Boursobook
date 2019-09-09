//
//  SelectPurseViewController.swift
//  Boursobook
//
//  Created by David Dubez on 31/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SelectPurseViewController: UIViewController {

    // MARK: Properties
    var userPurses = [Purse]()
    let purseAPI = PurseAPI()
    let userAPI = UserAPI()

    // MARK: IBOutlet
    @IBOutlet weak var purseListTableView: UITableView!
    @IBOutlet weak var createActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var createNewPurseButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var selectPurseStackView: UIStackView!
    @IBOutlet weak var selectPurseActivityIndicator: UIActivityIndicatorView!

    // MARK: IBAction
    @IBAction func didTapCreatePurse(_ sender: UIButton) {
        self.toogleCreateActivity(loading: true)
        choosePurseName()
    }
    @IBAction func didTapLogOutButton(_ sender: UIButton) {
        confirmLogOut()
    }

    // MARK: OverRide
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPurseFor(user: InMemoryStorage.shared.userLogIn)
        purseListTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        purseAPI.stopListen()
    }

    deinit {
        purseAPI.stopListen()
    }

    // MARK: Functions

    private func toogleCreateActivity(loading: Bool) {
        createActivityIndicator.isHidden = !loading
        createNewPurseButton.isHidden = loading
    }

    private func toogleSearchingPurse(loading: Bool) {
        selectPurseActivityIndicator.isHidden = !loading
        selectPurseStackView.isHidden = loading
    }

    private func setStyleOfVC() {
        purseListTableView.layer.cornerRadius = 10
        logOutButton.layer.cornerRadius = 10
    }

    private func loadPurseFor(user: User?) {
        guard let userLogIn = user else {
            self.displayAlert(message: NSLocalizedString("Sorry , but you must Login !", comment: ""),
                              title: NSLocalizedString("Done !", comment: ""))
            self.dismiss(animated: true, completion: nil)
            return
        }
        toogleSearchingPurse(loading: true)
        purseAPI.loadPursesFor(user: userLogIn) { (error, userPurses) in
            self.toogleSearchingPurse(loading: false)
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
            } else {
                guard let userPurses = userPurses else {
                    return
                }
                self.userPurses = userPurses
                self.purseListTableView.reloadData()
            }
        }
    }

    private func choosePurseName() {
        let alert = UIAlertController(title: NSLocalizedString("New purse création", comment: ""),
                                      message: nil,
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""),
                                       style: .default) { _ in
                                        guard let nameTextFieldValue = alert.textFields?[0].text else {
                                            return
                                        }
                                        self.validChosenPurseName(name: nameTextFieldValue)
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default) { _ in
                                            self.toogleCreateActivity(loading: false)
        }

        alert.addTextField { textName in
            textName.placeholder = NSLocalizedString("Enter the name", comment: "")
            textName.keyboardType = .default
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)

    }

    private func validChosenPurseName(name: String) {
        purseAPI.getExistingPurseName { (error, purseNameList) in
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
            } else if let purseNames = purseNameList {
                if purseNames.contains(name) {
                    self.toogleCreateActivity(loading: false)
                    self.displayAlert(message:
                        NSLocalizedString(
                            "Sorry, but the name allready exist !",
                            comment: ""),
                                      title: NSLocalizedString("Error !", comment: ""))
                } else {
                    self.createNewPurse(name: name)
                }
            }
        }
    }

    private func createNewPurse(name: String) {
        purseAPI.createPurse(name: name, user: InMemoryStorage.shared.userLogIn) { (error, _) in
            self.toogleCreateActivity(loading: false)
            if let error = error {
                self.displayAlert(message: NSLocalizedString(error.message, comment: ""),
                                  title: NSLocalizedString("Error !", comment: ""))
            } else {
                self.displayAlert(message: NSLocalizedString("New purse was created", comment: ""),
                                  title: NSLocalizedString("Done !", comment: ""))
            }
        }
    }

    private func confirmLogOut() {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""),
                                      message: NSLocalizedString("Are you sure you want to log out ?",
                                                                 comment: ""),
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default)
        let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (_) in
            self.logOut()
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func logOut() {
        userAPI.signOut { (error) in
            if let error = error {
                self.displayAlert(message: NSLocalizedString(error.message, comment: ""),
                                  title: NSLocalizedString("Error !", comment: ""))
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}

// MARK: - TableView for list of purse
extension SelectPurseViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPurses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "purseListCell",
                                                       for: indexPath) as? PurseListTableViewCell else {
                                                        return UITableViewCell()
        }
        let purse = userPurses[indexPath.row]
        cell.configure(with: purse)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        InMemoryStorage.shared.inWorkingPurseName = userPurses[indexPath.row].name
        self.performSegue(withIdentifier: "segueToInfo", sender: nil)
    }
}
