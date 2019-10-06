//
//  FakeDataDictionary.swift
//  BoursobookTests
//
//  Created by David Dubez on 03/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class FakeDataDictionary {
    var empty: [String: Any] {
        return [:]
    }

    var sale: [String: Any] {
        return ["date": "15/01/19",
                "uniqueID": "ID Sale - fake sale For test",
                "amount": 23.4,
                "numberOfArticle": 7,
                "madeByUser": "michel",
                "articlesUniqueID": ["livre"],
                "purseName": "APE 2019"]
    }

    var article: [String: Any] {
        return ["title": "titre article",
                "sort": "Book",
                "author": "DURANS",
                "description": "un livre sympa",
                "purseName": "APE 2019",
                "isbn": "1234567890123",
                "code": "AAAA 0001",
                "price": 2.4,
                "sellerUniqueId": "AAAA 44FGDRGERT",
                "sold": false,
                "returned": true,
                "uniqueID": "ID Article - fake article For test"]
    }

    var purse: [String: Any] {
        return ["name": "APE 2019",
                "uniqueID": "APE 2019 UNIQUEID",
                "percentageOnSales": 10.2,
                "depositFee": ["underFifty": 2.0,
                               "underOneHundred": 4.0,
                               "underOneHundredFifty": 6.0,
                               "underTwoHundred": 8.0,
                               "underTwoHundredFifty": 10.0,
                               "overTwoHundredFifty": 12.0],
                "administrators": ["me": true],
                "users": ["me@me.fr"],
                "numberOfArticleRegistered": 13,
                "numberOfArticleReturned": 7,
                "numberOfSellers": 8,
                "numberOfArticlesold": 8,
                "numberOfSales": 4,
                "totalSalesAmount": 12.6,
                "totalBenefitOnSalesAmount": 2.4,
                "totalDepositFeeAmount": 2.2
        ]
    }

    var wrongPurse: [String: Any] {
        return ["name": "APE 2019",
                "uniqueID": "APE 2019 UNIQUEID",
                "percentageOnSales": 10.2,
                "depositFee": ["underFifty": 2.0,
                               "underOneHundred": 4.0,
                               "underOneHundredFifty": 6.0,
                               "underTwoHundred": 8.0,
                               "underTwoHundredFifty": 10.0,
                               "errorField": 12.0],
                "administrators": ["me": true],
                "users": ["me@me.fr"],
                "numberOfArticleRegistered": 13,
                "numberOfArticleReturned": 7,
                "numberOfSellers": 8,
                "numberOfArticlesold": 8,
                "numberOfSales": 4,
                "totalSalesAmount": 12.6,
                "totalBenefitOnSalesAmount": 2.4,
                "totalDepositFeeAmount": 2.2
        ]
    }

    var seller: [String: Any] {
        return ["familyName": "Dupond",
                "firstName": "Gerad",
                "email": "g.dupond@free.fr",
                "phoneNumber": "0123456789",
                "code": "DUPG",
                "createdBy": "michel@me.com",
                "purseName": "APE 2019",
                "uniqueID": "diuzhdbfp djdjdj",
                "articlesold": 23,
                "articleRegistered": 42,
                "orderNumber": 47,
                "depositFeeAmount": 2.9,
                "salesAmount": 39.3,
                "refundDone": true,
                "refundDate": "14/05/18",
                "refundBy": "jeannine@aol.fr"]
    }

    var user: [String: Any] {
        return ["uniqueID": "ID user - fake sale For test",
                "email": "email@email.com"]
    }

}
