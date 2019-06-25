//
//  SellersListViewController.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SellersListViewController: UITableViewController {

    // MARK: - IBOUTLET
    @IBOutlet var sellersTableView: UITableView!

    // MARK: - Properties

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // #warning Incomplete implementation, return the number of rows
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

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            SellerService.shared.removeSeller(at: indexPath.row)
            sellersTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
