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

    var dictionary: [String: Any] {
        let values: [String: Any] = ["date": date, "uniqueID": uniqueID,
                                     "amount": amount, "numberOfArticle": numberOfArticle,
                                     "madeByUser": madeByUser, "articles": articles,
                                     "purseName": purseName]
        return values
    }

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

    required init?(dictionary: [String : Any]) {
        guard
            let dateValue = dictionary["date"] as? String,
            let uniqueIDValue = dictionary["uniqueID"] as? String,
            let amountValue = dictionary["amount"] as? Double,
            let numberValue = dictionary["numberOfArticle"] as? Int,
            let madeByValue = dictionary["madeByUser"] as? String,
            let articlesValues = dictionary["articles"] as? [String: Bool],
            let purseNameValue = dictionary["purseName"] as? String else {
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
}
