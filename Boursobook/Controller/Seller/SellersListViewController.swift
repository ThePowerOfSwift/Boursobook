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

    // MARK: - IBOUTLET
    @IBOutlet var sellersTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties
    var selectedSeller: Seller?

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        //FIXME:
        //InMemoryStorage.shared.onSellerUpdate = { () in
         //   self.updateValues()
        //}
        NotificationCenter.default.addObserver(self, selector: #selector(updateValues),
                                               name: InMemoryStorage.sellerUpdatedNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: InMemoryStorage.sellerUpdatedNotification,
                                                  object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateValues()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - functions
    @objc func updateValues() {
        sellersTableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InMemoryStorage.shared.sellers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SellerListTableViewCell",
                                                       for: indexPath) as? SellerListTableViewCell else {
                                                        return UITableViewCell()
        }

        let seller = InMemoryStorage.shared.sellers[indexPath.row]
        cell.configure(with: seller)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSeller = InMemoryStorage.shared.sellers[indexPath.row]
        self.performSegue(withIdentifier: "segueToSeller", sender: nil)
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            displayAlertConfirmDelete(for: indexPath)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSeller" {
            if let sellerVC = segue.destination as? SellerViewController, let selectedSeller = selectedSeller {
                sellerVC.codeOfSelectedSeller = selectedSeller.code
            }
        }
    }

    // MARK: - AlertControler
    private func displayAlertConfirmDelete(for indexPath: IndexPath) {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""),
                                      message: NSLocalizedString("Are you sure delete alla seller ?",
                                                                 comment: ""),
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default)
        let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (_) in
            InMemoryStorage.shared.removeSeller(at: indexPath.row)
            self.sellersTableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateValues()
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
