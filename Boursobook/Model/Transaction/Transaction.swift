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
    var date: Date
    var timestamp: String
    var amount: Double
    var numberOfArticle: Int
    var madeByUser: String
    var articles: [String: Bool]
    var purseName: String

    init?(snapshot: DataSnapshot) {
        guard   let snapshotValue = snapshot.value as? [String: AnyObject],
                let dateValue = snapshotValue["date"] as? Date,
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
