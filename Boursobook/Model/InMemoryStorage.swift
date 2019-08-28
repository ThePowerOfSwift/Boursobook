//
//  InMemoryStorage.swift
//  Boursobook
//
//  Created by David Dubez on 09/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class InMemoryStorage {
// manage the storage in the app memory

    // MARK: - Properties

    static var shared = InMemoryStorage()

    private(set) var purses: [Purse] = []
    private var purseService = PurseService()

    private(set) var sellers: [Seller] = []
    private var sellerService = SellerService()

    private(set) var articles: [Article] = []
    private var articleService = ArticleService()

    private(set) var transactions: [Transaction] = []
    private var transactionService = TransactionService()

    private(set) var currentPurse: Purse?
    private(set) var currentUser: User?
    private(set) var currentTransaction = Transaction()

    var onSellerUpdate: (() -> ())?

    private init() {
    }

    static let pursesUpdatedNotification =
        Notification.Name("InMemoryStorage.pursesUpdated")
    static let sellerUpdatedNotification =
        Notification.Name("InMemoryStorage.sellerUpdated")
    static let articleUpdatedNotification =
        Notification.Name("InMemoryStorage.articleUpdated")
    static let transactionUpdatedNotification =
        Notification.Name("InMemoryStorage.transactionUpdated")

    // MARK: - Functions PURSES

    func setPursesData(completionHandler: @escaping (Bool) -> Void) {
        // set purses data from fireBase
        var isSettingPurse = true

        self.setPurses { (done) in
            if done && isSettingPurse {
                self.setSellers(completionHandler: { (done) in
                    if done && isSettingPurse {
                        self.setArticle(completionHandler: { (done) in
                            if done && isSettingPurse {
                                self.setTransaction(completionHandler: { (done) in
                                    if done && isSettingPurse {
                                        isSettingPurse = false
                                        completionHandler(true)
                                    }
                                })
                            }
                        })
                    }
                })
            }
        }
    }
    //FIXME: promises
//    self.setPurses()
//        .then {
//            self.setSellers()
//        }
//        .then {
//            self.setArticle
//        }

    // --> RxSwift => Reactive Programming

    func setPurses(completionHandler: @escaping (Bool) -> Void) {
        // Query purses
        purseService.readAndListenData { (done, readedPurses) in
            if done {
                self.purses = readedPurses
                self.setCurrentPurse()
                NotificationCenter.default.post(name: InMemoryStorage.pursesUpdatedNotification, object: nil)
                completionHandler(true)
            }
        }
    }
    func setCurrentPurse() {
        // choose the purse corresponding to the user
        guard let userLogIn = UserService.shared.userLogIn else {
            return
        }
        for purse in purses where purse.users[userLogIn.uid] != nil {
            self.currentPurse = purse
        }
    }

    func setupCurrentPurseRates(percentage: Double, depositFee: Purse.DepositFee) {
        if let currentPurse = self.currentPurse {
            currentPurse.percentageOnSales = percentage
            currentPurse.depositFee = depositFee
            purseService.setupRates(purse: currentPurse,
                                    percentage: currentPurse.percentageOnSales,
                                    depositFee: currentPurse.depositFee)
        }
    }
}

// MARK: - Functions SELLERS
extension InMemoryStorage {
    func setSellers(completionHandler: @escaping (Bool) -> Void) {
        // Query sellers for the current purse
        guard let currentPurse = currentPurse else {return}
        sellerService.readAndListenData(for: currentPurse) { (done, readedSellers) in
            if done {
                self.sellers = readedSellers
                //FIXME:
                //self.onSellerUpdate?()
                NotificationCenter.default.post(name: InMemoryStorage.sellerUpdatedNotification, object: nil)
                completionHandler(true)
            }
        }
    }
    func addSeller(_ seller: Seller) {
        // add seller to list of seller, update Firebase
        // and update datas on the current purse
        guard let currentPurse = currentPurse else {return}

        // Add seller
        sellerService.create(seller: seller)
        sellers.append(seller)

        // Update purse
        purseService.updateNumberOfSeller(with: 1, for: currentPurse)
        currentPurse.numberOfSellers += 1

    }

    func removeSeller(at index: Int) {
        // delete seller to list of seller, update Firebase,
        // update data on the current purse
        // and delete articles of seller
        guard let currentPurse = currentPurse else {return}
        let seller = sellers[index]

        // Delete articles
        let articlesToDelete = filterArticles(by: seller.code)
        for article in articlesToDelete {
            removeArticle(article)
        }

        // Delete seller
        sellerService.remove(seller: seller)
        sellers.remove(at: index)

         // Update purse
        purseService.updateNumberOfSeller(with: -1, for: currentPurse)
        currentPurse.numberOfSellers -= 1

    }

    func isExistingSellerWith(code: String) -> Bool {
        for seller in sellers where seller.code == code {
            return true
        }
        return false
    }

    func selectSellerWithCode(_ code: String) -> Seller? {
        var selectedSeller: Seller?
        for seller in sellers where seller.code == code {
            selectedSeller = seller
        }
        return selectedSeller
    }

    func setDepositFeeAmout(for seller: Seller) {
        guard let currentPurse = currentPurse else {return}

        if seller.articleRegistered < 51 {
            seller.depositFeeAmount = currentPurse.depositFee.underFifty
        } else if seller.articleRegistered < 101 {
            seller.depositFeeAmount = currentPurse.depositFee.underOneHundred
        } else if seller.articleRegistered < 151 {
            seller.depositFeeAmount = currentPurse.depositFee.underOneHundredFifty
        } else if seller.articleRegistered < 201 {
            seller.depositFeeAmount = currentPurse.depositFee.underTwoHundred
        } else if seller.articleRegistered < 251 {
            seller.depositFeeAmount = currentPurse.depositFee.underTwoHundredFifty
        } else {
            seller.depositFeeAmount = currentPurse.depositFee.overTwoHundredFifty
        }
        sellerService.updateDepositFee(for: seller, with: seller.depositFeeAmount)
    }
}

// MARK: - Functions ARTICLES
extension InMemoryStorage {
    func setArticle(completionHandler: @escaping (Bool) -> Void) {
        // Query articles for the current purse
        guard let currentPurse = currentPurse else {return}
        articleService.readAndListenData(for: currentPurse) { (done, readedArticle) in
            if done {
                self.articles = readedArticle
                NotificationCenter.default.post(name: InMemoryStorage.articleUpdatedNotification, object: nil)
                completionHandler(true)
            }
        }
    }

    func addArticle(_ article: Article, for codeOfSeller: String) {
        // add article to list of article, update Firebase
        // and update datas on the current purse and on the seller

        // Add article
        articleService.create(article: article)
        articles.append(article)

        // Update Seller
        sellerService.updateArticlesCounters(for: codeOfSeller, numberArticleRegistered: 1, numberOrder: 1)
        for seller in sellers where seller.code == codeOfSeller {
            seller.articleRegistered += 1
            seller.orderNumber += 1
            setDepositFeeAmout(for: seller)
        }

        // Update purse
        guard let currentPurse = currentPurse else {return}
        purseService.updateNumberOfArticleRegistered(with: 1, for: currentPurse)
        currentPurse.numberOfArticleRegistered += 1
    }

    func removeArticle(_ articleToDelete: Article) {
        // delete article to list of article, update Firebase,
        // update datas oo the current purse and on the seller

        // Delete Article
        for (index, article) in articles.enumerated() where article.code == articleToDelete.code {
            articles.remove(at: index )
        }
        articleService.remove(article: articleToDelete)

        // Update Seller
        sellerService.updateArticlesCounters(for: articleToDelete.sellerCode,
                                             numberArticleRegistered: -1,
                                             numberOrder: 0)

        for seller in sellers where seller.code == articleToDelete.sellerCode {
            seller.articleRegistered -= 1
            setDepositFeeAmout(for: seller)
        }

        // Update purse
        guard let currentPurse = currentPurse else {return}
        purseService.updateNumberOfArticleRegistered(with: -1, for: currentPurse)
        currentPurse.numberOfArticleRegistered -= 1

    }

    func filterArticles(by codeOfSeller: String?) -> [Article] {
        guard let codeOfSeller = codeOfSeller else { return [] }
        var filteredList = [Article]()
        for article in articles where article.sellerCode == codeOfSeller {
            filteredList.append(article)
        }
        return filteredList
    }

    func filterNoSoldedArticles() -> [Article] {
        var filteredList = [Article]()
        for article in articles where article.solded == false {
            filteredList.append(article)
        }
        return filteredList
    }

    func selectArticle(by code: String) -> Article? {
        var selectedArticle: Article?
        for article in articles where article.code == code {
            selectedArticle = article
        }
        return selectedArticle
    }

    func isExistingArticleWith(code: String) -> Bool {
        for article in articles where article.code == code {
            return true
        }
        return false
    }
}

// MARK: - Functions TRANSACTION
extension InMemoryStorage {
    func setTransaction(completionHandler: @escaping (Bool) -> Void) {
        // Query transactions for the current purse
        guard let currentPurse = currentPurse else {return}
        transactionService.readAndListenData(for: currentPurse) { (done, readedTransaction) in
            if done {
                self.transactions = readedTransaction
                NotificationCenter.default.post(name: InMemoryStorage.transactionUpdatedNotification, object: nil)
                completionHandler(true)
            }
        }
    }

    func setCurrentTransaction() {
        // set a new transaction corresponding to the user and the purse
        guard let userLogIn = UserService.shared.userLogIn else {
            return
        }
        guard let currentPurse = currentPurse else {
            return
        }
        let date = Date()
        let frenchFormatter = DateFormatter()
        frenchFormatter.dateStyle = .short
        frenchFormatter.timeStyle = .none
        frenchFormatter.locale = Locale(identifier: "FR-fr")

        let currentDate = frenchFormatter.string(from: date)
        let uniqueID = UUID().description

        self.currentTransaction = Transaction(date: currentDate, uniqueID: uniqueID,
                                              amount: 0, numberOfArticle: 0, madeByUser: userLogIn.email,
                                              articles: [:], purseName: currentPurse.name)
    }

    func addArticleToCurrentTransaction(codeOfArticle: String) {
        for articleToAdd in articles where articleToAdd.code == codeOfArticle {
            currentTransaction.amount += articleToAdd.price
        }
        currentTransaction.articles.updateValue(true, forKey: codeOfArticle)
        currentTransaction.numberOfArticle += 1
    }

    func removeArticleToCurrentTransaction(codeOfArticle: String) {
        for articleToRemove in articles where articleToRemove.code == codeOfArticle {
            currentTransaction.amount -= articleToRemove.price
        }
        currentTransaction.articles.removeValue(forKey: codeOfArticle)
        currentTransaction.numberOfArticle -= 1
    }

    func isCodeArticleInCurrentTransaction(code: String) -> Bool {
        for (key, _) in currentTransaction.articles where  key == code {
            return true
        }
        return false
    }

    func validCurrentTransaction() {
        // set articles to solded, calculate amounts
        // save the transaction

        var transacationValuesBySeller = [String: TransactionValues]()

        guard let purse = currentPurse else { return }
        let sellerBenefitRate = (100 - purse.percentageOnSales) / 100
        let purseBenefitRate = purse.percentageOnSales / 100

        // Update articles
        for (code, _) in currentTransaction.articles {
            for article in articles where article.code == code {
                // Update article to solded  state in localMemory
                article.solded = true

                let values = TransactionValues(amount: (article.price * sellerBenefitRate), number: 1)

                // Compute the amount and the number of sale for each seller in localMemory
                if let oldValues = transacationValuesBySeller[article.sellerCode] {
                    let newValues = TransactionValues(amount: values.amount + oldValues.amount,
                                                      number: values.number + oldValues.number)
                    transacationValuesBySeller.updateValue(newValues, forKey: article.sellerCode)
                } else {
                    transacationValuesBySeller.updateValue(values, forKey: article.sellerCode)
                }
            }
        }

        // update list of article to solded State in FireBase
        articleService.updateSoldedList(list: currentTransaction.articles)

        // Update sellers in local Memory
        for (sellerCode, values) in transacationValuesBySeller {
            for seller in sellers where sellerCode == seller.code {
                seller.salesAmount += values.amount
                seller.articleSolded += values.number
            }
        }
        // Update sellers in firebase
        sellerService.updateValuesAfterTransaction(for: transacationValuesBySeller)

        // Update current purse in local Memory
        purse.totalBenefitOnSalesAmount += currentTransaction.amount * purseBenefitRate
        purse.totalSalesAmount += currentTransaction.amount
        purse.numberOfArticleSolded += currentTransaction.numberOfArticle
        purse.numberOfTransaction += 1

        // Update current purse in fireBase
        purseService.updateValuesAfterTransactionWith(
            for: purse,
            benefit: currentTransaction.amount * purseBenefitRate,
            salesAmount: currentTransaction.amount,
            articleSolded: currentTransaction.numberOfArticle,
            numberTransaction: 1)

        // Update current transaction in local Memory
        transactions.append(currentTransaction)

        // Update current transaction in Firebase
        transactionService.create(transaction: currentTransaction)

        setCurrentTransaction()
    }
}
