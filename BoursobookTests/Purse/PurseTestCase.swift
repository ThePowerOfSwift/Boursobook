//
//  PurseTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 13/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest

import XCTest
import Firebase
@testable import Boursobook

class PurseTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testInitPurseWithDataSnapshotSouldReturnPurse() {
        //Given
        let name = "APE 2019"
        let percentageOnSales = 10.2
        let administrators = ["me": true]
        let users = ["me": true]
        let numberOfArticleRegistered = 13
        let numberOfSellers = 8
        let numberOfArticleSolded = 8
        let numberOfTransaction = 4
        let totalSalesAmount = 12.6
        let totalBenefitOnSalesAmount = 2.4

//        "totalDepositFeeAmount": 2.2
//        let depositFee = Purse.DepositFee(underFifty: 2.0, underOneHundred: <#T##Double#>,
//        underOneHundredFifty: <#T##Double#>, underTwoHundred: <#T##Double#>, underTwoHundredFifty: <#T##Double#>, overTwoHundredFifty: <#T##Double#>)
//        "depositFee": ["underFifty": 2.0,
//        "underOneHundred": 4.0,
//        "underOneHundredFifty": 6.0,
//        "underTwoHundred": 8.0,
//        "underTwoHundredFifty": 10.0,
//        "overTwoHundredFifty": 12.0],

        
        
        let date = "15/01/19"
        let uniqueID = "4E242432"
        let amount = 23.4
        let numberOfArticle = 7
        let madeByUser = "michel"
        let articles = ["livre": true]
        let purseName = "APE 2019"
        let fakeTransactionDataSnapshot = FakeTransactionDataSnapshot()

        //When
        guard let transaction = Transaction(snapshot: fakeTransactionDataSnapshot) else {
            XCTFail("error in init purse")
            return
        }

        //Then
        XCTAssertEqual(transaction.date, date)
        XCTAssertEqual(transaction.uniqueID, uniqueID)
        XCTAssertEqual(transaction.amount, amount)
        XCTAssertEqual(transaction.numberOfArticle, numberOfArticle)
        XCTAssertEqual(transaction.madeByUser, madeByUser)
        XCTAssertEqual(transaction.articles, articles)
        XCTAssertEqual(transaction.purseName, purseName)
    }

    func testInitPurseWithEmptyDataSnapshotSouldReturnNil() {
        //Given
        let emptyPurseDataSnapshot = DataSnapshot()

        //When
        guard let purse = Purse(snapshot: emptyPurseDataSnapshot) else {
            XCTAssertTrue(true)
            return
        }

        //Then
        XCTAssertNotNil(purse)
        XCTFail("purse is initialised")
    }
}
