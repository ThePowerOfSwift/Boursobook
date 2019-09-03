//
//  SelectPurseViewController.swift
//  Boursobook
//
//  Created by David Dubez on 31/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SelectPurseViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var purseListTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var createNewPurseButton: UIButton!

    // MARK: IBAction
    @IBAction func didTapCreatePurse(_ sender: UIButton) {
        self.toogleActivity(logging: true)
        choosePurseName()
    }

    // MARK: OverRide
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()

        InMemoryStorage.shared.onPurseUpdate = { () in
            self.purseListTableView.reloadData()
        }
    }

    // MARK: Functions
    private func setStyleTableView() {
        purseListTableView.layer.cornerRadius = 10
    }

    func toogleActivity(logging: Bool) {
        activityIndicator.isHidden = !logging
        createNewPurseButton.isHidden = logging
    }

    func setStyleOfVC() {
        purseListTableView.layer.cornerRadius = 10
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
                                            self.toogleActivity(logging: false)
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
        InMemoryStorage.shared.isPurseNameExist(name: name) { (error, exist) in
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
            } else if exist {
                self.toogleActivity(logging: false)
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

    private func createNewPurse(name: String) {
        InMemoryStorage.shared.createPurse(name: name) { (error) in
            self.toogleActivity(logging: false)
            if let error = error {
                self.displayAlert(message: NSLocalizedString(error.message, comment: ""),
                                  title: NSLocalizedString("Error !", comment: ""))
            } else {
                self.displayAlert(message: NSLocalizedString("New purse was created", comment: ""),
                                  title: NSLocalizedString("Done !", comment: ""))
            }
        }
    }

    // MARK: - Navigation

}

// MARK: - TableView for list of purse
extension SelectPurseViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InMemoryStorage.shared.purses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "purseListCell",
                                                       for: indexPath) as? PurseListTableViewCell else {
                                                        return UITableViewCell()
        }
        let purse = InMemoryStorage.shared.purses[indexPath.row]
        cell.configure(with: purse)

        return cell
    }
}
