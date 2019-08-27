//
//  FakeDataSnapshot.swift
//  BoursobookTests
//
//  Created by David Dubez on 12/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class FakeTransactionDataSnapshot: DataSnapshot {
    //Override the property value of a DataSnapshot for a Transaction

    override var value: Any? {
        return ["date": "15/01/19",
                "uniqueID": "ID Transaction - fake transaction For test",
                "amount": 23.4,
                "numberOfArticle": 7,
                "madeByUser": "michel",
                "articles": ["livre": true],
                "purseName": "APE 2019"]
    }
}

class FakeArticleDataSnapshot: DataSnapshot {
    //Override the property value of a DataSnapshot for a Article

    override var value: Any? {
        return ["title": "titre article",
                "sort": "Book",
                "author": "DURANS",
                "description": "un livre sympa",
                "purseName": "APE 2019",
                "isbn": "1234567890123",
                "code": "AAAA 0001",
                "price": 2.4,
                "sellerCode": "AAAA",
                "solded": false,
                "uniqueID": "ID Article - fake article For test"]
    }
}

class FakePurseDataSnapshot: DataSnapshot {
    //Override the property value of a DataSnapshot for a Purse

    override var value: Any? {
        return ["name": "APE 2019",
                "percentageOnSales": 10.2,
                "depositFee": ["underFifty": 2.0,
                               "underOneHundred": 4.0,
                               "underOneHundredFifty": 6.0,
                               "underTwoHundred": 8.0,
                               "underTwoHundredFifty": 10.0,
                               "overTwoHundredFifty": 12.0],
                "administrators": ["me": true],
                "users": ["me": "me@me.fr"],
                "numberOfArticleRegistered": 13,
                "numberOfSellers": 8,
                "numberOfArticleSolded": 8,
                "numberOfTransaction": 4,
                "totalSalesAmount": 12.6,
                "totalBenefitOnSalesAmount": 2.4,
                "totalDepositFeeAmount": 2.2
        ]
    }
}
