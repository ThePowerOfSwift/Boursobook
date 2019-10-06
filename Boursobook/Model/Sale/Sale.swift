//
//  Sale.swift
//  Boursobook
//
//  Created by David Dubez on 23/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class Sale: RemoteDataBaseModel {
    // MARK: - Properties
    static let collection = "sales"

    var date: String
    var uniqueID: String
    var amount: Double
    var numberOfArticle: Int
    var madeByUser: String
    var articlesUniqueID: [String]
    var purseName: String

    var dictionary: [String: Any] {
        let values: [String: Any] = ["date": date, "uniqueID": uniqueID,
                                     "amount": amount, "numberOfArticle": numberOfArticle,
                                     "madeByUser": madeByUser, "articlesUniqueID": articlesUniqueID,
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
        self.articlesUniqueID = [""]
        self.purseName = ""
    }

    init(date: String, uniqueID: String, amount: Double,
         numberOfArticle: Int, madeByUser: String,
         articlesUniqueID: [String], purseName: String) {
        self.date = date
        self.uniqueID = uniqueID
        self.amount = amount
        self.numberOfArticle = numberOfArticle
        self.madeByUser = madeByUser
        self.articlesUniqueID = articlesUniqueID
        self.purseName = purseName
    }

    required init?(dictionary: [String: Any]) {
        guard
            let dateValue = dictionary["date"] as? String,
            let uniqueIDValue = dictionary["uniqueID"] as? String,
            let amountValue = dictionary["amount"] as? Double,
            let numberValue = dictionary["numberOfArticle"] as? Int,
            let madeByValue = dictionary["madeByUser"] as? String,
            let articlesUniqueIDValues = dictionary["articlesUniqueID"] as? [String],
            let purseNameValue = dictionary["purseName"] as? String else {
                return nil
        }

        date = dateValue
        uniqueID = uniqueIDValue
        amount = amountValue
        numberOfArticle = numberValue
        madeByUser = madeByValue
        articlesUniqueID = articlesUniqueIDValues
        purseName = purseNameValue
    }
}
