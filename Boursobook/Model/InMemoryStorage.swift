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
// manage the active user, purse and the articles selected in the current sale in the app memory

    // MARK: - Properties
    static var shared = InMemoryStorage()
    var userLogIn: User?
    var inWorkingPurse: Purse?
    var uniqueIdOfArticlesInCurrentSales = [String]()

    private init() {
    }

}


// MARK: - Functions TRANSACTION
extension InMemoryStorage {


//    func setCurrentTransaction() {
//        // set a new transaction corresponding to the user and the purse
//        guard let userLogIn = InMemoryStorage.shared.userLogIn else {
//            return
//        }
//        guard let currentPurse = currentPurse else {
//            return
//        }
//        let date = Date()
//        let frenchFormatter = DateFormatter()
//        frenchFormatter.dateStyle = .short
//        frenchFormatter.timeStyle = .none
//        frenchFormatter.locale = Locale(identifier: "FR-fr")
//
//        let currentDate = frenchFormatter.string(from: date)
//        let uniqueID = UUID().description
//
//        self.currentTransaction = Transaction(date: currentDate, uniqueID: uniqueID,
//                                              amount: 0, numberOfArticle: 0, madeByUser: userLogIn.email,
//                                              articles: [:], purseName: currentPurse.name)
//    }

//    func addArticleToCurrentTransaction(codeOfArticle: String) {
//        for articleToAdd in articles where articleToAdd.code == codeOfArticle {
//            currentTransaction.amount += articleToAdd.price
//        }
//        currentTransaction.articles.updateValue(true, forKey: codeOfArticle)
//        currentTransaction.numberOfArticle += 1
    }

//    func removeArticleToCurrentTransaction(codeOfArticle: String) {
//        for articleToRemove in articles where articleToRemove.code == codeOfArticle {
//            currentTransaction.amount -= articleToRemove.price
//        }
//        currentTransaction.articles.removeValue(forKey: codeOfArticle)
//        currentTransaction.numberOfArticle -= 1
//    }
//
//    func validCurrentTransaction() {
//        // set articles to sold, calculate amounts
        // save the transaction

//        var transacationValuesBySeller = [String: TransactionValues]()
//
//        guard let purse = currentPurse else { return }
//        let sellerBenefitRate = (100 - purse.percentageOnSales) / 100
//        let purseBenefitRate = purse.percentageOnSales / 100
//
//        // Update articles
//        for (code, _) in currentTransaction.articles {
//            for article in articles where article.code == code {
//                // Update article to sold  state in localMemory
//                article.sold = true
//
//                let values = TransactionValues(amount: (article.price * sellerBenefitRate), number: 1)
//
//                // Compute the amount and the number of sale for each seller in localMemory
//                if let oldValues = transacationValuesBySeller[article.sellerCode] {
//                    let newValues = TransactionValues(amount: values.amount + oldValues.amount,
//                                                      number: values.number + oldValues.number)
//                    transacationValuesBySeller.updateValue(newValues, forKey: article.sellerCode)
//                } else {
//                    transacationValuesBySeller.updateValue(values, forKey: article.sellerCode)
//                }
//            }
//        }
//
//        // update list of article to sold State in FireBase
//        articleService.updatesoldList(list: currentTransaction.articles)
//
//        // Update sellers in local Memory
//        for (sellerCode, values) in transacationValuesBySeller {
//            for seller in sellers where sellerCode == seller.code {
//                seller.salesAmount += values.amount
//                seller.articlesold += values.number
//            }
//        }
//        // Update sellers in firebase
//        sellerService.updateValuesAfterTransaction(for: transacationValuesBySeller)
//
//        // Update current purse in local Memory
//        purse.totalBenefitOnSalesAmount += currentTransaction.amount * purseBenefitRate
//        purse.totalSalesAmount += currentTransaction.amount
//        purse.numberOfArticlesold += currentTransaction.numberOfArticle
//        purse.numberOfTransaction += 1
//
//        // Update current purse in fireBase
//        purseService.updateValuesAfterTransactionWith(
//            for: purse,
//            benefit: currentTransaction.amount * purseBenefitRate,
//            salesAmount: currentTransaction.amount,
//            articlesold: currentTransaction.numberOfArticle,
//            numberTransaction: 1)
//
//        // Update current transaction in local Memory
//        transactions.append(currentTransaction)
//
//        // Update current transaction in Firebase
//        transactionService.create(transaction: currentTransaction)
//
//        setCurrentTransaction()
//    }
//}

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
