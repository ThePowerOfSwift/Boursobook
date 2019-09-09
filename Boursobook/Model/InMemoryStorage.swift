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
    var userLogIn: User?
    var inWorkingPurseName: String?

    private init() {
    }

    // -----------------------------
     // -----------------------------
     // -----------------------------

    private(set) var purses: [Purse] = []
    private let purseAPI = PurseAPI()
    var onPurseUpdate: (() -> Void)?
    private(set) var currentPurse: Purse?

    private(set) var sellers: [Seller] = []
    private let sellerAPI = SellerAPI()
    var onSellerUpdate: (() -> Void)?

    private(set) var articles: [Article] = []
    private let articleAPI = ArticleAPI()
    var onArticleUpdate: (() -> Void)?

    // MARK: - Common Functions
    func loadUsefulDataFor(purse: Purse, completionHandler: @escaping (Error?) -> Void) {
        // Load all the nedded data in local Memory corresponding to the selected purse
        // Set the seleted purse as current purse

        var isFirstLoadingData = true
        currentPurse = purse

        if isFirstLoadingData {
            self.loadSellers { (error) in
                if let error = error {
                    completionHandler(error)
                }
                if isFirstLoadingData {
                    self.loadArticles(callBack: { (error) in
                        if let error = error {
                            completionHandler(error)
                        }
                        isFirstLoadingData = false
                        completionHandler(nil)
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

    }

    // MARK: - Functions for sellers
    func loadSellers(callBack: @escaping (Error?) -> Void) {
        // Load all the sellers that have current purse as purse
        sellerAPI.loadSellersFor(purse: currentPurse) { (error, sellersLoaded) in
            if let error = error {
                callBack(error)
            } else {
                guard let sellersLoaded = sellersLoaded else {
                    callBack(IMSError.other)
                    return
                }
                self.sellers = sellersLoaded
                self.onSellerUpdate?()
                callBack(nil)
            }
        }
    }

    // MARK: - Functions for articles
    func loadArticles(callBack: @escaping (Error?) -> Void) {
        // Load all the articles that have current purse as purse
        articleAPI.loadArticlesFor(purse: currentPurse) { (error, articlesLoaded) in
            if let error = error {
                callBack(error)
            } else {
                guard let articlesLoaded = articlesLoaded else {
                    callBack(IMSError.other)
                    return
                }
                self.articles = articlesLoaded
                self.onArticleUpdate?()
                callBack(nil)
            }
        }
    }

    //--------------------------------------
    //FIXME : a suprimer en dessous
    // ----------------------------------------

    private var purseService = PurseService()
    private var sellerService = SellerService()
    private var articleService = ArticleService()

    private(set) var transactions: [Transaction] = []
    private var transactionService = TransactionService()

    private(set) var currentTransaction = Transaction()

    static let pursesUpdatedNotification =
        Notification.Name("InMemoryStorage.pursesUpdated")
    static let sellerUpdatedNotification =
        Notification.Name("InMemoryStorage.sellerUpdated")
    static let articleUpdatedNotification =
        Notification.Name("InMemoryStorage.articleUpdated")
    static let transactionUpdatedNotification =
        Notification.Name("InMemoryStorage.transactionUpdated")

    // MARK: - Functions PURSES

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

    func filterNosoldArticles() -> [Article] {
        var filteredList = [Article]()
        for article in articles where article.sold == false {
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
        guard let userLogIn = InMemoryStorage.shared.userLogIn else {
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
        // set articles to sold, calculate amounts
        // save the transaction

        var transacationValuesBySeller = [String: TransactionValues]()

        guard let purse = currentPurse else { return }
        let sellerBenefitRate = (100 - purse.percentageOnSales) / 100
        let purseBenefitRate = purse.percentageOnSales / 100

        // Update articles
        for (code, _) in currentTransaction.articles {
            for article in articles where article.code == code {
                // Update article to sold  state in localMemory
                article.sold = true

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

        // update list of article to sold State in FireBase
        articleService.updatesoldList(list: currentTransaction.articles)

        // Update sellers in local Memory
        for (sellerCode, values) in transacationValuesBySeller {
            for seller in sellers where sellerCode == seller.code {
                seller.salesAmount += values.amount
                seller.articlesold += values.number
            }
        }
        // Update sellers in firebase
        sellerService.updateValuesAfterTransaction(for: transacationValuesBySeller)

        // Update current purse in local Memory
        purse.totalBenefitOnSalesAmount += currentTransaction.amount * purseBenefitRate
        purse.totalSalesAmount += currentTransaction.amount
        purse.numberOfArticlesold += currentTransaction.numberOfArticle
        purse.numberOfTransaction += 1

        // Update current purse in fireBase
        purseService.updateValuesAfterTransactionWith(
            for: purse,
            benefit: currentTransaction.amount * purseBenefitRate,
            salesAmount: currentTransaction.amount,
            articlesold: currentTransaction.numberOfArticle,
            numberTransaction: 1)

        // Update current transaction in local Memory
        transactions.append(currentTransaction)

        // Update current transaction in Firebase
        transactionService.create(transaction: currentTransaction)

        setCurrentTransaction()
    }
}

extension InMemoryStorage {
    /**
     'IMSError' is the error type returned by InMemoryStorage.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     */
    enum IMSError: String, Error {
        case other = "Sorry, there is an error !"
    }
}
