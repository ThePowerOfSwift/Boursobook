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

    // MARK: - Properties
    var selectedSeller: Seller?

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        SellerService.shared.familyNameOrderedQuery { (_) in
            self.sellersTableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sellersTableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SellerService.shared.sellers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SellerListTableViewCell",
                                                       for: indexPath) as? SellerListTableViewCell else {
                                                        return UITableViewCell()
        }

        let seller = SellerService.shared.sellers[indexPath.row]
        cell.configure(with: seller)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSeller = SellerService.shared.sellers[indexPath.row]
        self.performSegue(withIdentifier: "segueToSeller", sender: nil)
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            SellerService.shared.removeSeller(at: indexPath.row)
            sellersTableView.deleteRows(at: [indexPath], with: .automatic)
            sellersTableView.reloadData()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSeller" {
            if let sellerVC = segue.destination as? SellerViewController {
                sellerVC.selectedSeller = selectedSeller
            }
        }
    }
}
// TODO: - Ajouter un activity indicator pour dire que les données se chargeent
