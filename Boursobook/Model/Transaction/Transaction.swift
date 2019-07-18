//
//  Transaction.swift
//  Boursobook
//
//  Created by David Dubez on 04/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class Transaction {
    var date: String
    var timestamp: String
    var amount: Double
    var numberOfArticle: Int
    var madeByUser: String
    var articles: [String: Bool]
    var purseName: String

    // MARK: - Initialisation
    init() {
        self.date = ""
        self.timestamp = ""
        self.amount = 0
        self.numberOfArticle = 0
        self.madeByUser = ""
        self.articles = [:]
        self.purseName = ""
    }
    
    init(date: String, timestamp: String, amount: Double, numberOfArticle: Int, madeByUser: String, articles: [String: Bool], purseName: String) {
        self.date = date
        self.timestamp = timestamp
        self.amount = amount
        self.numberOfArticle = numberOfArticle
        self.madeByUser = madeByUser
        self.articles = articles
        self.purseName = purseName
    }

    init?(snapshot: DataSnapshot) {
        guard   let snapshotValue = snapshot.value as? [String: AnyObject],
                let dateValue = snapshotValue["date"] as? String,
                let timestampValue = snapshotValue["timestamp"] as? String,
                let amountValue = snapshotValue["amount"] as? Double,
                let numberValue = snapshotValue["numberOfArticle"] as? Int,
                let madeByValue = snapshotValue["madeByUser"] as? String,
                let articlesValues = snapshotValue["articles"] as? [String: Bool],
                let purseNameValue = snapshotValue["purseName"] as? String else {
            return nil
        }

        date = dateValue
        timestamp = timestampValue
        amount = amountValue
        numberOfArticle = numberValue
        madeByUser = madeByValue
        articles = articlesValues
        purseName = purseNameValue
    }
}
