//
//  TransactionService.swift
//  Boursobook
//
//  Created by David Dubez on 10/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class TransactionService {
    // Manage the "transactions" database on FireBase

    // MARK: Properties
    let reference = Database.database().reference(withPath: "transactions")

    static let transactionUpdatedNotification =
        Notification.Name("TransactionService.transactionUpdated")

    // MARK: Function
    func create(transaction: Transaction) {
        let transactionRef = reference.child(transaction.madeByUser + transaction.timestamp)
        let values: [String: Any] = ["date": transaction.date, "timestamp": transaction.timestamp,
                                     "amount": transaction.amount, "numberOfArticle": transaction.numberOfArticle,
                                     "madeByUser": transaction.madeByUser, "articles": transaction.articles,
                                     "purseName": transaction.purseName]
        transactionRef.setValue(values)
    }

    func readAndListenData(for purse: Purse, completionHandler: @escaping (Bool, [Transaction]) -> Void) {
        // Query transactions from FireBase for one Purse
        reference.queryOrdered(byChild: "purseName").queryEqual(toValue: purse.name).observe(.value) { snapshot in
            var newTransaction: [Transaction] = []

            for child in snapshot.children {
                if let childValue = child as? DataSnapshot {
                    if let transaction = Transaction(snapshot: childValue) {
                        newTransaction.append(transaction)
                    }
                }
            }
            completionHandler(true, newTransaction)
        }
    }
}
