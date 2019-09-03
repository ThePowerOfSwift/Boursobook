//
//  PurseTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 13/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class PurseTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testInitPurseSouldReturnPurse() {
        //Given
        let name = "APE 2019"
        let uniqueID = "APE 2019 UNIQUEID"
        let percentageOnSales = 10.2
        let administrators = ["me": true]
        let users = ["me": "me@me.fr"]
        let numberOfArticleRegistered = 13
        let numberOfSellers = 8
        let numberOfArticlesold = 8
        let numberOfTransaction = 4
        let totalSalesAmount = 12.6
        let totalBenefitOnSalesAmount = 2.4
        let totalDepositFeeAmount = 2.2
        let depositFee = Purse.DepositFee(underFifty: 2.0, underOneHundred: 4.0,
                                          underOneHundredFifty: 6.0, underTwoHundred: 8.0,
                                          underTwoHundredFifty: 10.0, overTwoHundredFifty: 12.0)

        //When
        let purse = Purse(name: name, uniqueID: uniqueID, numberOfArticleRegistered: numberOfArticleRegistered,
                          numberOfSellers: numberOfSellers, numberOfArticlesold: numberOfArticlesold,
                          numberOfTransaction: numberOfTransaction, percentageOnSales: percentageOnSales,
                          depositFee: depositFee, totalSalesAmount: totalSalesAmount,
                          totalBenefitOnSalesAmount: totalBenefitOnSalesAmount,
                          totalDepositFeeAmount: totalDepositFeeAmount,
                          administrators: administrators, users: users)

        //Then
        XCTAssertEqual(purse.name, name)
        XCTAssertEqual(purse.uniqueID, uniqueID)
        XCTAssertEqual(purse.percentageOnSales, percentageOnSales)
        XCTAssertEqual(purse.administrators, administrators)
        XCTAssertEqual(purse.users, users)
        XCTAssertEqual(purse.numberOfArticleRegistered, numberOfArticleRegistered)
        XCTAssertEqual(purse.numberOfSellers, numberOfSellers)
        XCTAssertEqual(purse.numberOfArticlesold, numberOfArticlesold)
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

    func testInitPurseWithNameSouldReturnEmptyPurse() {
        //Given
        let name = "APE 2019"
        let uniqueID = "APE 2019 UNIQUEID"
        let administrators = ["me": true]
        let users = ["me": "me@me.fr"]

        //When
        let purse = Purse(name: name, uniqueID: uniqueID, administrators: administrators, users: users)

        //Then
        XCTAssertEqual(purse.name, name)
        XCTAssertEqual(purse.uniqueID, uniqueID)
        XCTAssertEqual(purse.administrators, administrators)
        XCTAssertEqual(purse.users, users)

        XCTAssertEqual(purse.percentageOnSales, 10)
        XCTAssertEqual(purse.numberOfArticleRegistered, 0)
        XCTAssertEqual(purse.numberOfSellers, 0)
        XCTAssertEqual(purse.numberOfArticlesold, 0)
        XCTAssertEqual(purse.numberOfTransaction, 0)
        XCTAssertEqual(purse.totalSalesAmount, 0)
        XCTAssertEqual(purse.totalBenefitOnSalesAmount, 0)
        XCTAssertEqual(purse.totalDepositFeeAmount, 0)
        XCTAssertEqual(purse.depositFee.underFifty, 0)
        XCTAssertEqual(purse.depositFee.underOneHundred, 2)
        XCTAssertEqual(purse.depositFee.underOneHundredFifty, 4)
        XCTAssertEqual(purse.depositFee.underTwoHundred, 6)
        XCTAssertEqual(purse.depositFee.underTwoHundredFifty, 8)
        XCTAssertEqual(purse.depositFee.overTwoHundredFifty, 10)
    }

    func testInitPurseWithDictionarySouldReturnPurse() {
        //Given
        let name = "APE 2019"
        let uniqueID = "APE 2019 UNIQUEID"
        let percentageOnSales = 10.2
        let administrators = ["me": true]
        let users = ["me": "me@me.fr"]
        let numberOfArticleRegistered = 13
        let numberOfSellers = 8
        let numberOfArticlesold = 8
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

        let fakePurseDataDictionary = FakeDataDictionary().purse

        //When
        guard let purse = Purse(dictionary: fakePurseDataDictionary) else {
            XCTFail("error in init purse")
            return
        }

        //Then
        XCTAssertEqual(purse.name, name)
        XCTAssertEqual(purse.uniqueID, uniqueID)
        XCTAssertEqual(purse.percentageOnSales, percentageOnSales)
        XCTAssertEqual(purse.administrators, administrators)
        XCTAssertEqual(purse.users, users)
        XCTAssertEqual(purse.numberOfArticleRegistered, numberOfArticleRegistered)
        XCTAssertEqual(purse.numberOfSellers, numberOfSellers)
        XCTAssertEqual(purse.numberOfArticlesold, numberOfArticlesold)
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

    func testInitPurseWithEmptyDictionarySouldReturnNil() {
        //Given
        let emptyDataDictionary = FakeDataDictionary().empty

        //When
        guard let purse = Purse(dictionary: emptyDataDictionary) else {
            XCTAssertTrue(true)
            return
        }

        //Then
        XCTAssertNotNil(purse)
        XCTFail("purse is initialised")
    }

    func testInitPurseWithDictionaryWithWrongDepositFeeSouldReturnNil() {
        //Given
        let fakeWrongPurseDataDictionary = FakeDataDictionary().wrongPurse

        //When
        guard let purse = Purse(dictionary: fakeWrongPurseDataDictionary) else {
            XCTAssertTrue(true)
            return
        }

        //Then
        XCTAssertNotNil(purse)
        XCTFail("purse is initialised")
    }

    func testGetDictionarySouldReturnGoodValues() {
        //Given
        let fakePurseDataDictionary = FakeDataDictionary().purse
        var depositFeefake = fakePurseDataDictionary["depositFee"] as? [String: Double] ?? ["string": 10]

        //When
        guard let purse = Purse(dictionary: fakePurseDataDictionary) else {
            XCTFail("error in init purse")
            return
        }
        var dictionaryValues = purse.dictionary
        var depositFeeValues = dictionaryValues["depositFee"] as? [String: Double] ?? ["": 0]

        //Then
        XCTAssertEqual(dictionaryValues["name"] as? String, fakePurseDataDictionary["name"] as? String)
        XCTAssertEqual(dictionaryValues["uniqueID"] as? String, fakePurseDataDictionary["uniqueID"] as? String)

        XCTAssertEqual(dictionaryValues["numberOfArticleRegistered"] as? Int,
                       fakePurseDataDictionary["numberOfArticleRegistered"] as? Int)
        XCTAssertEqual(dictionaryValues["numberOfSellers"] as? Int,
                       fakePurseDataDictionary["numberOfSellers"] as? Int)
        XCTAssertEqual(dictionaryValues["numberOfArticlesold"] as? Int,
                       fakePurseDataDictionary["numberOfArticlesold"] as? Int)
        XCTAssertEqual(dictionaryValues["numberOfTransaction"] as? Int,
                       fakePurseDataDictionary["numberOfTransaction"] as? Int)

        XCTAssertEqual(dictionaryValues["percentageOnSales"] as? Double,
                       fakePurseDataDictionary["percentageOnSales"] as? Double)
        XCTAssertEqual(dictionaryValues["totalSalesAmount"] as? Double,
                       fakePurseDataDictionary["totalSalesAmount"] as? Double)
        XCTAssertEqual(dictionaryValues["totalBenefitOnSalesAmount"] as? Double,
                       fakePurseDataDictionary["totalBenefitOnSalesAmount"] as? Double)
        XCTAssertEqual(dictionaryValues["totalDepositFeeAmount"] as? Double,
                       fakePurseDataDictionary["totalDepositFeeAmount"] as? Double)

        XCTAssertEqual(depositFeeValues["underFifty"], depositFeefake["underFifty"])
        XCTAssertEqual(depositFeeValues["underOneHundred"], depositFeefake["underOneHundred"])
        XCTAssertEqual(depositFeeValues["underOneHundredFifty"], depositFeefake["underOneHundredFifty"])
        XCTAssertEqual(depositFeeValues["underTwoHundred"], depositFeefake["underTwoHundred"])
        XCTAssertEqual(depositFeeValues["underTwoHundredFifty"], depositFeefake["underTwoHundredFifty"])
        XCTAssertEqual(depositFeeValues["overTwoHundredFifty"], depositFeefake["overTwoHundredFifty"])

        XCTAssertEqual(dictionaryValues["administrators"] as? [String: Bool], ["me": true])
        XCTAssertEqual(dictionaryValues["users"] as? [String: String], ["me": "me@me.fr"])
    }

}
