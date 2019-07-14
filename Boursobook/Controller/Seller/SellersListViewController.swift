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
        UserService.shared.listenAuthentication { (login) in
            if !login {
              self.performSegue(withIdentifier: "unwindToLogin", sender: self)
            }
        }
        updateValues()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserService.shared.stopListenAuthentification()
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
            InMemoryStorage.shared.removeSeller(at: indexPath.row)
            sellersTableView.deleteRows(at: [indexPath], with: .automatic)
            sellersTableView.reloadData()
            //FIXME: mettre un message pour confirmer l'effacement et tous les enregistrements relatifs
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
}
// TODO:    - Voir pourquoi le unwind segue ne fonctionne pas lorsque j'efface l'utilisateur loggé
