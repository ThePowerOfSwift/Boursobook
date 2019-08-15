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
@testable import BoursobookProduction

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
        let users = ["me": "me@me.fr"]
        let numberOfArticleRegistered = 13
        let numberOfSellers = 8
        let numberOfArticleSolded = 8
        let numberOfTransaction = 4
        let totalSalesAmount = 12.6
        let totalBenefitOnSalesAmount = 2.4
        let totalDepositFeeAmount = 2.2
        let depositFee = Purse.DepositFee(underFifty: 2.0,
                                          underOneHundred: 4.0,
                                          underOneHundredFifty: 6.0,
                                          underTwoHundred: 8.0,
                                          underTwoHundredFifty: 10.0,
                                          overTwoHundredFifty: 12.0)

        let fakePurseDataSnapshot = FakePurseDataSnapshot()

        //When
        guard let purse = Purse(snapshot: fakePurseDataSnapshot) else {
            XCTFail("error in init purse")
            return
        }

        //Then
        XCTAssertEqual(purse.name, name)
        XCTAssertEqual(purse.percentageOnSales, percentageOnSales)
        XCTAssertEqual(purse.administrators, administrators)
        XCTAssertEqual(purse.users, users)
        XCTAssertEqual(purse.numberOfArticleRegistered, numberOfArticleRegistered)
        XCTAssertEqual(purse.numberOfSellers, numberOfSellers)
        XCTAssertEqual(purse.numberOfArticleSolded, numberOfArticleSolded)
        XCTAssertEqual(purse.numberOfTransaction, numberOfTransaction)
        XCTAssertEqual(purse.totalSalesAmount, totalSalesAmount)
        XCTAssertEqual(purse.totalBenefitOnSalesAmount, totalBenefitOnSalesAmount)
        XCTAssertEqual(purse.totalDepositFeeAmount, totalDepositFeeAmount)
        XCTAssertEqual(purse.depositFee.underFifty, depositFee.underFifty)
        XCTAssertEqual(purse.depositFee.underOneHundred, depositFee.underOneHundred)
        XCTAssertEqual(purse.depositFee.underOneHundredFifty, depositFee.underOneHundredFifty)
        XCTAssertEqual(purse.depositFee.underTwoHundred, depositFee.underTwoHundred)
        XCTAssertEqual(purse.depositFee.underTwoHundredFifty, depositFee.underTwoHundredFifty)
        XCTAssertEqual(purse.depositFee.overTwoHundredFifty, depositFee.overTwoHundredFifty)

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
