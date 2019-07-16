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
    private(set) var currentSeller: Seller?

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
            purseService.setupRates(purseName: currentPurse.name,
                                    percentage: currentPurse.percentageOnSales,
                                    depositFee: currentPurse.depositFee)
        }
    }

    // MARK: - Functions SELLERS
    func setSellers(completionHandler: @escaping (Bool) -> Void) {
        // Query sellers for the current purse
        guard let currentPurse = currentPurse else {return}
        sellerService.readAndListenData(for: currentPurse) { (done, readedSellers) in
            if done {
                self.sellers = readedSellers
                NotificationCenter.default.post(name: InMemoryStorage.sellerUpdatedNotification, object: nil)
                completionHandler(true)
            }
        }
    }
    func addSeller(_ seller: Seller) {
        // add seller to list of seller, update Firebase
        // and increment the number of seller of the current purse
        guard let currentPurse = currentPurse else {return}

        // Add seller
        sellerService.create(seller: seller)
        sellers.append(seller)

        // Update purse
        purseService.updateNumberOfSeller(with: 1, for: currentPurse.name)
        currentPurse.numberOfSellers += 1

    }

    func removeSeller(at index: Int) {
        // delete seller to list of seller, update Firebase,
        // decrement the number of seller of the current purse
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
        purseService.updateNumberOfSeller(with: -1, for: currentPurse.name)
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

    // MARK: - Functions ARTICLES
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
        // and increment the number of article in the current purse and in the seller

        // Add article
        articleService.create(article: article)
        articles.append(article)

        // Update Seller
        sellerService.updateNumberOfArtilceRegistered(with: 1, for: codeOfSeller)
        sellerService.increaseOrderNumber(for: codeOfSeller)
        for seller in sellers where seller.code == codeOfSeller {
            seller.articleRegistered += 1
            seller.orderNumber += 1
        }

        // Update purse
        guard let currentPurse = currentPurse else {return}
        purseService.updateNumberOfArticleRegistered(with: 1, for: currentPurse.name)
        currentPurse.numberOfArticleRegistered += 1
    }

    func removeArticle(_ articleToDelete: Article) {
        // delete article to list of article, update Firebase,
        // decrement the number of article of the current purse and in the seller

        // Delete Article
        for (index, article) in articles.enumerated() where article.code == articleToDelete.code {
            articles.remove(at: index )
        }
        articleService.remove(article: articleToDelete)

        // Update Seller
        sellerService.updateNumberOfArtilceRegistered(with: -1, for: articleToDelete.sellerCode)

        // Update purse
        guard let currentPurse = currentPurse else {return}
        purseService.updateNumberOfArticleRegistered(with: -1, for: currentPurse.name)
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
    func selectArticle(by code: String) -> Article? {
        var selectedArticle: Article?
        for article in articles where article.code == code {
            selectedArticle = article
        }
        return selectedArticle
    }

    // MARK: - Functions TRANSACTION
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
}

// TODO:    - gestion de l'appli offligne
//          - Posibilité de choisir la purse si un user est inscrit sur plusieurs
