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

    private init() {
    }

    // MARK: - Functions
    func readAndListenData(completionHandler: @escaping (Bool) -> Void) {
        // read and listen all data from fireBase

        purseService.readAndListenData { (done, readedPurses) in
            if done {
                self.purses = readedPurses
                self.sellerService.readAndListenData(completionHandler: { (done, readedSellers) in
                    if done {
                        self.sellers = readedSellers
                        self.articleService.readAndListenData(completionHandler: { (done, readedArticles) in
                            if done {
                                self.articles = readedArticles
                                self.transactionService.readAndListenData(completionHandler: { (done, readedTransactions) in
                                    if done {
                                        self.transactions = readedTransactions
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

    func setCurrentPurse() {
        // choose the purse corresponding to the user
        guard let userLogIn = UserService.shared.userLogIn else {
            return
        }
        for purse in purses where purse.users[userLogIn.uid] != nil {
            self.currentPurse = purse
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

    func addArticle(_ article: Article) {
        articleService.create(article: article)
        articles.append(article)
//
//        for seller in SellerService.shared.sellers where seller.code == article.sellerCode {
//            seller.articleRegistered += 1
//        }
        //FIXME: maj le nombre d'article du seller
        //FIXME: maj le nombre d'artilce de la purse
    }

    func removeArticle(at index: Int) {
        let article = articles[index]
        articleService.remove(article: article)
        articles.remove(at: index)
        //FIXME: maj le nombre d'article du seller
        //FIXME: maj le nombre d'artilce de la purse
    }

    func filterArticles(by seller: Seller) -> [Article] {
        var filteredList = [Article]()
        for article in articles where article.sellerCode == seller.code {
            filteredList.append(article)
        }
        return filteredList
    }

}

// TODO:    - gestion de l'appli offligne
