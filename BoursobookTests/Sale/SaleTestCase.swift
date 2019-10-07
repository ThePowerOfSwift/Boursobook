//
//  SaleTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 02/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
import Firebase

@testable import Boursobook

class SaleTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testInitEmptySaleSouldReturnEmptySale() {
        //Given
        let emptySale = Sale()

        //When

        //Then
        XCTAssertEqual(emptySale.date, "")
        XCTAssertEqual(emptySale.uniqueID, "")
        XCTAssertEqual(emptySale.amount, 0)
        XCTAssertEqual(emptySale.numberOfArticle, 0)
        XCTAssertEqual(emptySale.madeByUser, "")
        XCTAssertEqual(emptySale.inArticlesCode, [""])
        XCTAssertEqual(emptySale.purseName, "")
    }

    func testInitSaleSouldReturnSale() {
        //Given
        let date = "15/01/19"
        let uniqueID = "4E242432"
        let amount = 23.4
        let numberOfArticle = 7
        let madeByUser = "michel"
        let inArticlesCode = ["livre"]
        let purseName = "APE 2019"

        //When
        let sale = Sale(date: date, uniqueID: uniqueID,
                                      amount: amount, numberOfArticle: numberOfArticle,
                                      madeByUser: madeByUser, inArticlesCode: inArticlesCode, purseName: purseName)

        //Then
        XCTAssertEqual(sale.date, date)
        XCTAssertEqual(sale.uniqueID, uniqueID)
        XCTAssertEqual(sale.amount, amount)
        XCTAssertEqual(sale.numberOfArticle, numberOfArticle)
        XCTAssertEqual(sale.madeByUser, madeByUser)
        XCTAssertEqual(sale.inArticlesCode, inArticlesCode)
        XCTAssertEqual(sale.purseName, purseName)
    }

    func testInitSaleWithDictionarySouldReturnSale() {
        //Given
        let date = "15/01/19"
        let uniqueID = "ID Sale - fake sale For test"
        let amount = 23.4
        let numberOfArticle = 7
        let madeByUser = "michel"
        let inArticlesCode = ["livre"]
        let purseName = "APE 2019"
        let fakeSaleDataDictionary = FakeDataDictionary().sale

        //When
        guard let sale = Sale(dictionary: fakeSaleDataDictionary) else {
            XCTFail("error in init of sale")
            return
        }

        //Then
        XCTAssertEqual(sale.date, date)
        XCTAssertEqual(sale.uniqueID, uniqueID)
        XCTAssertEqual(sale.amount, amount)
        XCTAssertEqual(sale.numberOfArticle, numberOfArticle)
        XCTAssertEqual(sale.madeByUser, madeByUser)
        XCTAssertEqual(sale.inArticlesCode, inArticlesCode)
        XCTAssertEqual(sale.purseName, purseName)
    }

    func testInitSaleWithEmptyDictionarySouldReturnNil() {
        //Given
        let fakeemptyDataDictionary = FakeDataDictionary().empty

        //When
        guard let sale = Sale(dictionary: fakeemptyDataDictionary) else {
            XCTAssertTrue(true)
            return
        }

        //Then
        XCTAssertNil(sale)
        XCTFail("sale is initialised")

    }

    func testGetDictionarySouldReturnGoodValues() {
        //Given
        let fakeSaleDataDictionary = FakeDataDictionary().sale
        let articlesfake = fakeSaleDataDictionary["inArticlesCode"] as? [String] ?? [""]

        //When
        guard let sale = Sale(dictionary: fakeSaleDataDictionary) else {
            XCTFail("error in init Sale")
            return
        }
        let dictionaryValues = sale.dictionary
        let articlesValues = dictionaryValues["inArticlesCode"] as? [String] ?? [""]

        //Then
        XCTAssertEqual(dictionaryValues["date"] as? String, fakeSaleDataDictionary["date"] as? String)
        XCTAssertEqual(dictionaryValues["uniqueID"] as? String, fakeSaleDataDictionary["uniqueID"] as? String)
        XCTAssertEqual(dictionaryValues["madeByUser"] as? String,
                       fakeSaleDataDictionary["madeByUser"] as? String)
        XCTAssertEqual(dictionaryValues["purseName"] as? String, fakeSaleDataDictionary["purseName"] as? String)

        XCTAssertEqual(dictionaryValues["amount"] as? Double, fakeSaleDataDictionary["amount"] as? Double)

        XCTAssertEqual(dictionaryValues["numberOfArticle"] as? Int,
                       fakeSaleDataDictionary["numberOfArticle"] as? Int)

        XCTAssertEqual(articlesValues, articlesfake)

    }
}
