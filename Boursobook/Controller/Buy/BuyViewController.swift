//
//  BuyViewController.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController, SelectingArticleDelegate {

    // MARK: - Properties
    var articleList = [Article]()
    var currentTransaction = Transaction()

    // MARK: - IBOutlets
    @IBOutlet weak var numberOfRegisteredArticleLabel: UILabel!
    @IBOutlet weak var numberCheckedSwitch: UISwitch!
    @IBOutlet weak var totalAmountSaleLabel: UILabel!
    @IBOutlet weak var selectedArticleTableView: UITableView!

    // MARK: - IBActions
    @IBAction func didTapAddArticleButton(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToScanQRCode", sender: nil)
    }
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        saveTheSale()
    }
    @IBAction func didTapResetButton(_ sender: UIButton) {
       resetTransaction()
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        InMemoryStorage.shared.setCurrentTransaction()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setArticleList()
        selectedArticleTableView.reloadData()
        updateValues()
    }

    // MARK: - Functions
    private func setArticleList() {
        articleList.removeAll()
        for (articleCode, _) in InMemoryStorage.shared.currentTransaction.articles {
            for article in InMemoryStorage.shared.articles where article.code == articleCode {
                articleList.append(article)
            }
        }
    }

    private func updateValues() {
        numberOfRegisteredArticleLabel.text = String(InMemoryStorage.shared.currentTransaction.numberOfArticle)
        totalAmountSaleLabel.text = String(InMemoryStorage.shared.currentTransaction.amount)
    }

    // To conform to SelectingArticleDelegate Protocol
    func didSelectArticle(articleUniqueID: String) {
        //FIXME: A implementer
    }

    private func saveTheSale() {
        if InMemoryStorage.shared.currentTransaction.numberOfArticle == 0 {
            self.displayAlert(message: NSLocalizedString("Nothing To Save !",
                                                         comment: ""),
                              title: NSLocalizedString("Warning", comment: ""))
        } else {
            if numberCheckedSwitch.isOn {
                InMemoryStorage.shared.validCurrentTransaction()
                resetTransaction()
                numberCheckedSwitch.isOn = false
            } else {
                self.displayAlert(message: NSLocalizedString("Please check the number !",
                                                             comment: ""),
                                  title: NSLocalizedString("Warning", comment: ""))
            }
        }
    }

    private func resetTransaction() {
        InMemoryStorage.shared.setCurrentTransaction()
        setArticleList()
        selectedArticleTableView.reloadData()
        updateValues()
    }
    // MARK: - Navigation
   @IBAction func unwindToBuyVC(segue: UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToScanQRCode" {
            if let scanQRCodeVC = segue.destination as? ScanViewController {
                scanQRCodeVC.currentTransaction = currentTransaction
            }
        }
    }
}

// MARK: - TableView for list of article
extension BuyViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionActicleListCell",
                                                       for: indexPath) as? TransactionActicleListTableViewCell else {
                                                        return UITableViewCell()
        }

        let article = articleList[indexPath.row]

        cell.configure(with: article)

        return cell
    }
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let articleToDelete = articleList[indexPath.row]
            InMemoryStorage.shared.removeArticleToCurrentTransaction(codeOfArticle: articleToDelete.code)
            setArticleList()
            selectedArticleTableView.deleteRows(at: [indexPath], with: .automatic)
            updateValues()
        }
    }

    // MARK: - AlertControler
    private func displayAlertConfirmCompted() {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""),
                                      message: NSLocalizedString("Please check the number ?",
                                                                 comment: ""),
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .default)

        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
