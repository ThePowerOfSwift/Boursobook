//
//  Transaction.swift
//  Boursobook
//
//  Created by David Dubez on 04/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class Transaction: RemoteDataBaseModel {

    var date: String
    var uniqueID: String
    var amount: Double
    var numberOfArticle: Int
    var madeByUser: String
    var articles: [String: Bool]
    var purseName: String

    // MARK: - Initialisation
    init() {
        self.date = ""
        self.uniqueID = ""
        self.amount = 0
        self.numberOfArticle = 0
        self.madeByUser = ""
        self.articles = [:]
        self.purseName = ""
    }

    init(date: String, uniqueID: String, amount: Double,
         numberOfArticle: Int, madeByUser: String,
         articles: [String: Bool], purseName: String) {
        self.date = date
        self.uniqueID = uniqueID
        self.amount = amount
        self.numberOfArticle = numberOfArticle
        self.madeByUser = madeByUser
        self.articles = articles
        self.purseName = purseName
    }

    required init?(snapshot: DataSnapshot) {
        guard   let snapshotValue = snapshot.value as? [String: AnyObject],
                let dateValue = snapshotValue["date"] as? String,
                let uniqueIDValue = snapshotValue["uniqueID"] as? String,
                let amountValue = snapshotValue["amount"] as? Double,
                let numberValue = snapshotValue["numberOfArticle"] as? Int,
                let madeByValue = snapshotValue["madeByUser"] as? String,
                let articlesValues = snapshotValue["articles"] as? [String: Bool],
                let purseNameValue = snapshotValue["purseName"] as? String else {
            return nil
        }

        date = dateValue
        uniqueID = uniqueIDValue
        amount = amountValue
        numberOfArticle = numberValue
        madeByUser = madeByValue
        articles = articlesValues
        purseName = purseNameValue
    }

    func setValuesForRemoteDataBase() -> [String: Any] {
        let values: [String: Any] = ["date": date, "uniqueID": uniqueID,
                                     "amount": amount, "numberOfArticle": numberOfArticle,
                                     "madeByUser": madeByUser, "articles": articles,
                                     "purseName": purseName]
        return values
    }
}
