//
//  SellersListViewController.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit
import Firebase

class SellersListViewController: UITableViewController {

    // MARK: - Properties
    var selectedSeller: Seller?
    let sellerAPI = SellerAPI()
    var displayedSellers = [Seller]()

    // MARK: - IBOUTLET
    @IBOutlet var sellersTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateValues()
        loadSellersToDisplay()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sellerAPI.stopListen()
    }

    deinit {
        sellerAPI.stopListen()
    }

    // MARK: - functions
    private func updateValues() {
        sellersTableView.reloadData()
    }

    private func loadSellersToDisplay() {
        guard let purse = InMemoryStorage.shared.inWorkingPurse else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        sellerAPI.loadSellersFor(purseName: purse.name) { (error, loadedSellers) in
            self.activityIndicator.isHidden = true
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
            } else {
                guard let sellers = loadedSellers else {
                    return
                }
                self.displayedSellers = sellers
                self.updateValues()
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedSellers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SellerListTableViewCell",
                                                       for: indexPath) as? SellerListTableViewCell else {
                                                        return UITableViewCell()
        }

        let seller = displayedSellers[indexPath.row]
        cell.configure(with: seller)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSeller = displayedSellers[indexPath.row]
        self.performSegue(withIdentifier: "segueToSeller", sender: nil)
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmAndDeleteSeller(at: indexPath)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSeller" {
            if let sellerVC = segue.destination as? SellerViewController, let selectedSeller = selectedSeller {
                sellerVC.uniqueIdOfSelectedSeller = selectedSeller.uniqueID
            }
        }
    }

    // MARK: - AlertControler
    private func confirmAndDeleteSeller(at indexPath: IndexPath) {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""),
                                      message: NSLocalizedString("Are you sure delete alla seller ?",
                                                                 comment: ""),
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default)
        let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (_) in

            let sellerToDelete = self.displayedSellers[indexPath.row]
            self.sellerAPI.removeSeller(seller: sellerToDelete, completionHandler: { (error) in
                if let error = error {
                    self.displayAlert(
                        message: error.message,
                        title: NSLocalizedString(
                            "Error !", comment: ""))
                    return
                } else {
                    self.updateValues()
                }
            })
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
