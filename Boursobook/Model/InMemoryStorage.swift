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
        sellerService.create(seller: seller)
        sellers.append(seller)
        //FIXME: maj le nombre des sellers dans purse
    }

    func removeSeller(at index: Int) {
        let seller = sellers[index]
        sellerService.remove(seller: seller)
        sellers.remove(at: index)
        //FIXME: maj le nombre de seller dans la purse
        //FIXME: detruire les articles correspondants
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
        articleService.create(article: article)
        articles.append(article)
        sellerService.increaseNumberOfArtilceRegistered(for: codeOfSeller)
        sellerService.increaseOrderNumber(for: codeOfSeller)
        for seller in sellers where seller.code == codeOfSeller {
            seller.articleRegistered += 1
            seller.orderNumber += 1
        }

        //FIXME: maj le nombre d'artilce de la purse
    }

    func removeArticle(at index: Int) {
        let article = articles[index]
        articleService.remove(article: article)
        articles.remove(at: index)
        //FIXME: maj le nombre d'article du seller
        //FIXME: maj le nombre d'artilce de la purse
    }

    func filterArticles(by codeOfSeller: String) -> [Article] {
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

//FIXME: refactorisez tout ca : le inmemory ne gere que le stockage local .... chaque service gere ses appel
//      (voir pour faire une classe qui s'occupe de regrouper les fonctions de sauvegarde par exemple ( en locel + sur firebase)
