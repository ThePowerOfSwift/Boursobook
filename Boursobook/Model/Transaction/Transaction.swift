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

    init?(snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        guard let dateValue = snapshotValue["date"] as? Date else {
            return nil
        }
        guard let timestampValue = snapshotValue["timestamp"] as? String else {
            return nil
        }
        guard let amountValue = snapshotValue["amount"] as? Double else {
            return nil
        }
        guard let numberValue = snapshotValue["numberOfArticle"] as? Int else {
            return nil
        }
        guard let madeByValue = snapshotValue["madeByUser"] as? String else {
            return nil
        }
        guard let articlesValues = snapshotValue["articles"] as? [String: Bool] else {
            return nil
        }

        date = dateValue
        timestamp = timestampValue
        amount = amountValue
        numberOfArticle = numberValue
        madeByUser = madeByValue
        articles = articlesValues
    }
}
