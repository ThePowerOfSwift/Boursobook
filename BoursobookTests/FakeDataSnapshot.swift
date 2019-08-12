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
                "uniqueID": "4E242432",
                "amount": 23.4,
                "numberOfArticle": 7,
                "madeByUser": "michel",
                "articles": ["livre": true],
                "purseName": "APE 2019"]
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
                "users": ["me": true],
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
