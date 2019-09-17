//
//  UserListTableViewController.swift
//  Boursobook
//
//  Created by David Dubez on 09/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {

    // MARK: - Properties
    let purseAPI = PurseAPI()
    let userAPI = UserAPI()
    var displayedUsers = [User]()

    // MARK: IBOutlet
    @IBOutlet var userTableView: UITableView!
    @IBOutlet weak var activityIndictor: UIActivityIndicatorView!

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndictor.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUsersToDisplay()
    }

    // MARK: - Functions

    private func loadUsersToDisplay() {
        userAPI.readUsers { (error, loadedUsers) in
            self.activityIndictor.isHidden = true
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
                self.dismiss(animated: true, completion: nil)
            } else {
                guard let listOfUsers = loadedUsers else {
                    return
                }
                self.displayedUsers = listOfUsers
                self.userTableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userListCell",
                                                       for: indexPath) as? UserListTableViewCell else {
                                                        return UITableViewCell()
        }
        let user = displayedUsers[indexPath.row]
        cell.configure(with: user)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let purse = InMemoryStorage.shared.inWorkingPurse else {
            return
        }
        let alert = UIAlertController(title: NSLocalizedString("Are you sure you want to add ", comment: ""),
                                      message: " \(displayedUsers[indexPath.row].email) -> \(purse.name)" ,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default)
        let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (_) in
            self.saveUserInPurse(user: self.displayedUsers[indexPath.row])
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func saveUserInPurse(user: User) {
        guard let purse = InMemoryStorage.shared.inWorkingPurse else {
            return
        }
        purseAPI.addUserFor(purse: purse, user: user) { (error) in
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
            } else {
               self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
