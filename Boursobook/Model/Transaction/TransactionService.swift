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

    // MARK: Properties
    let transactionReference = Database.database().reference(withPath: "transactions")

    // MARK: Function
    func create(transaction: Transaction) {
        let transactionRef = transactionReference.child(transaction.madeByUser + transaction.timestamp)
        let values: [String: Any] = ["date": transaction.date, "timestamp": transaction.timestamp,
                                     "amount": transaction.amount, "numberOfArticle": transaction.numberOfArticle,
                                     "madeByUser": transaction.madeByUser, "articles": transaction.articles]
        transactionRef.setValue(values)
    }

    func readAndListenData(completionHandler: @escaping (Bool, [Transaction]) -> Void) {
        //download value from FireBase
        transactionReference.observe(.value) { snapshot in
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
