//
//  TransactionTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 08/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
import Firebase

@testable import Boursobook

class TransactionTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testInitEmptyTransactionSouldReturnEmptyTransaction() {
        //Given
        let emptyTransaction = Transaction()

        //When

        //Then
        XCTAssertEqual(emptyTransaction.date, "")
        XCTAssertEqual(emptyTransaction.uniqueID, "")
        XCTAssertEqual(emptyTransaction.amount, 0)
        XCTAssertEqual(emptyTransaction.numberOfArticle, 0)
        XCTAssertEqual(emptyTransaction.madeByUser, "")
        XCTAssertEqual(emptyTransaction.articles, [:])
        XCTAssertEqual(emptyTransaction.purseName, "")
    }

    func testInitTransactionSouldReturnTransaction() {
        //Given
        let date = "15/01/19"
        let uniqueID = "4E242432"
        let amount = 23.4
        let numberOfArticle = 7
        let madeByUser = "michel"
        let articles = ["livre": true]
        let purseName = "APE 2019"

        //When
        let transaction = Transaction(date: date, uniqueID: uniqueID,
                                      amount: amount, numberOfArticle: numberOfArticle,
                                      madeByUser: madeByUser, articles: articles, purseName: purseName)

        //Then
        XCTAssertEqual(transaction.date, date)
        XCTAssertEqual(transaction.uniqueID, uniqueID)
        XCTAssertEqual(transaction.amount, amount)
        XCTAssertEqual(transaction.numberOfArticle, numberOfArticle)
        XCTAssertEqual(transaction.madeByUser, madeByUser)
        XCTAssertEqual(transaction.articles, articles)
        XCTAssertEqual(transaction.purseName, purseName)
    }

    func testInitTransactionWithDictionarySouldReturnTransaction() {
        //Given
        let date = "15/01/19"
        let uniqueID = "ID Transaction - fake transaction For test"
        let amount = 23.4
        let numberOfArticle = 7
        let madeByUser = "michel"
        let articles = ["livre": true]
        let purseName = "APE 2019"
        let fakeTransactionDataDictionary = FakeDataDictionary().transaction

        //When
        guard let transaction = Transaction(dictionary: fakeTransactionDataDictionary) else {
            XCTFail("error in init of transaction")
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

    func testInitTransactionWithEmptyDictionarySouldReturnNil() {
        //Given
        let fakeemptyDataDictionary = FakeDataDictionary().empty

        //When
        guard let transaction = Transaction(dictionary: fakeemptyDataDictionary) else {
            XCTAssertTrue(true)
            return
        }

        //Then
        XCTAssertNil(transaction)
        XCTFail("transaction is initialised")

    }

    func testGetDictionarySouldReturnGoodValues() {
        //Given
        let fakeTransactionDataDictionary = FakeDataDictionary().transaction
        let articlesfake = fakeTransactionDataDictionary["articles"] as? [String: Bool] ?? ["string": false]

        //When
        guard let transaction = Transaction(dictionary: fakeTransactionDataDictionary) else {
            XCTFail("error in init Transaction")
            return
        }
        var dictionaryValues = transaction.dictionary
        let articlesValues = dictionaryValues["articles"] as? [String: Bool] ?? ["": true]

        //Then
        XCTAssertEqual(dictionaryValues["date"] as? String, fakeTransactionDataDictionary["date"] as? String)
        XCTAssertEqual(dictionaryValues["uniqueID"] as? String, fakeTransactionDataDictionary["uniqueID"] as? String)
        XCTAssertEqual(dictionaryValues["madeByUser"] as? String,
                       fakeTransactionDataDictionary["madeByUser"] as? String)
        XCTAssertEqual(dictionaryValues["purseName"] as? String, fakeTransactionDataDictionary["purseName"] as? String)

        XCTAssertEqual(dictionaryValues["amount"] as? Double, fakeTransactionDataDictionary["amount"] as? Double)

        XCTAssertEqual(dictionaryValues["numberOfArticle"] as? Int,
                       fakeTransactionDataDictionary["numberOfArticle"] as? Int)

        XCTAssertEqual(articlesValues, articlesfake)

    }
}
