//
//  SaleViewController.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SaleViewController: UIViewController {

    // MARK: - Properties
    var inSaleArticles = [Article]()
    var articlesInError = [Article]()
    var currentSale = Sale()
    let saleAPI = SaleAPI()
    let articleAPI = ArticleAPI()

    // MARK: - IBOutlets
    @IBOutlet weak var numberOfRegisteredArticleLabel: UILabel!
    @IBOutlet weak var numberCheckedSwitch: UISwitch!
    @IBOutlet weak var totalAmountSaleLabel: UILabel!
    @IBOutlet weak var selectedArticleTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var savingActivityIndicator: UIActivityIndicatorView!

    // MARK: - IBActions
    @IBAction func didTapAddArticleButton(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToScanQRCode", sender: nil)
    }
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        saveTheSale()
    }
    @IBAction func didTapResetButton(_ sender: UIButton) {
       resetSale(artilclesInError: nil)
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        numberCheckedSwitch.isOn = false
        loadInSaleArticles()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saleAPI.stopListen()
        articleAPI.stopListen()
    }

    deinit {
        saleAPI.stopListen()
        articleAPI.stopListen()
    }

    // MARK: - Functions
    private func loadInSaleArticles() {

        if !InMemoryStorage.shared.codeOfArticlesInCurrentSales.isEmpty {
            toogleLoadingActivity(loading: true)
            articleAPI.loadNoSoldArticlesFor(purse: InMemoryStorage.shared.inWorkingPurse) { (error, loadedArticles) in
                self.toogleLoadingActivity(loading: false)
                if let error = error {
                    self.displayAlert(
                        message: error.message,
                        title: NSLocalizedString(
                            "Error !", comment: ""))
                } else {
                    guard let articles = loadedArticles else {
                        return
                    }
                    self.inSaleArticles.removeAll()
                    self.currentSale = Sale()

                    for codeArticle in InMemoryStorage.shared.codeOfArticlesInCurrentSales {
                        for article in articles where article.code == codeArticle {
                            self.inSaleArticles.append(article)
                            self.currentSale.numberOfArticle += 1
                            self.currentSale.amount += article.price
                            self.currentSale.inArticlesCode.append(codeArticle)
                        }
                    }
                    self.updateValues()
                }
            }
        }
    }

    private func updateValues() {
        numberOfRegisteredArticleLabel.text = String(currentSale.numberOfArticle)
        totalAmountSaleLabel.text = formatDiplayedNumber(currentSale.amount)
        selectedArticleTableView.reloadData()
    }

    private func saveTheSale() {
        toogleSavingActivity(saving: true)

        if InMemoryStorage.shared.codeOfArticlesInCurrentSales.isEmpty {
            toogleSavingActivity(saving: false)
            self.displayAlert(message: NSLocalizedString("Nothing To Save !", comment: ""),
                              title: NSLocalizedString("Warning", comment: ""))
        } else {
            if numberCheckedSwitch.isOn {

                //Create a new Sale without data about amount and articles
                saleAPI.createNewSale(purse: InMemoryStorage.shared.inWorkingPurse,
                                   user: InMemoryStorage.shared.userLogIn) { (error, createdSale) in
                    if let error = error {
                        self.toogleSavingActivity(saving: false)
                        self.displayAlert(message: error.message, title: NSLocalizedString("Error !", comment: ""))
                    } else {

                        guard let createdSale = createdSale else { return }

                        //for earch article in current sale, update data in remote database and update new sale after
                        let updatingArticlesGroup = DispatchGroup()
                        self.inSaleArticles.forEach { (article) in
                            updatingArticlesGroup.enter()
                            self.saleAPI
                                .updateDataforArticleSold(article: article,
                                                          sale: createdSale,
                                                          purse: InMemoryStorage.shared.inWorkingPurse) { (error) in
                                    if error != nil {
                                        self.articlesInError.append(article)
                                    }
                                    updatingArticlesGroup.leave()
                            }
                        }
                        updatingArticlesGroup.notify(queue: .main) {
                            self.toogleSavingActivity(saving: false)
                            if self.articlesInError.isEmpty {
                                self.displayAlert(message: NSLocalizedString("The sale was saved", comment: ""),
                                                  title: NSLocalizedString("Done !", comment: ""))
                                self.resetSale(artilclesInError: nil)

                            } else {
                                self.displayAlert(
                                    message: NSLocalizedString("The sale was saved, but some article failed !",
                                                               comment: ""),
                                    title: NSLocalizedString("Done !", comment: ""))
                                self.resetSale(artilclesInError: self.articlesInError)
                            }
                        }
                    }
                }
            } else {
                toogleSavingActivity(saving: false)
                self.displayAlert(message: NSLocalizedString("Please check the number !", comment: ""),
                                  title: NSLocalizedString("Warning", comment: ""))
            }
        }
    }

    private func resetSale(artilclesInError: [Article]?) {
        numberCheckedSwitch.isOn = false
        if artilclesInError == nil {
            InMemoryStorage.shared.codeOfArticlesInCurrentSales.removeAll()
            currentSale = Sale()
            inSaleArticles = [Article]()
            updateValues()
        } else {
            InMemoryStorage.shared.codeOfArticlesInCurrentSales.removeAll()
            currentSale = Sale()
            inSaleArticles = [Article]()
            updateValues()
            inSaleArticles = articlesInError
            self.articlesInError = [Article]()
        }
    }

    private func setStyleOfVC() {
        selectedArticleTableView.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
        resetButton.layer.cornerRadius = 10
    }

    private func toogleLoadingActivity(loading: Bool) {
           loadingActivityIndicator.isHidden = !loading
           selectedArticleTableView.isHidden = loading
    }

    private func toogleSavingActivity(saving: Bool) {
           savingActivityIndicator.isHidden = !saving
           saveButton.isHidden = saving
    }

    private func formatDiplayedNumber(_ number: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
            return formattedNumber
        } else {
            return nil
        }
    }

    // MARK: - Navigation
   @IBAction func unwindToBuyVC(segue: UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToScanQRCode" {
            if let scanQRCodeVC = segue.destination as? ScanQrCodeViewController {
                scanQRCodeVC.currentSale = currentSale
            }
        }
    }
}

// MARK: - TableView for list of article
extension SaleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSaleArticles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionActicleListCell",
                                                       for: indexPath) as? TransactionActicleListTableViewCell else {
                                                        return UITableViewCell()
        }

        let article = inSaleArticles[indexPath.row]

        cell.configure(with: article)

        return cell
    }
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let articleToDelete = inSaleArticles[indexPath.row]
            for (index, code) in InMemoryStorage.shared
                .codeOfArticlesInCurrentSales.enumerated()
                        where code == articleToDelete.code {
                InMemoryStorage.shared.codeOfArticlesInCurrentSales.remove(at: index)
                loadInSaleArticles()
            }
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
