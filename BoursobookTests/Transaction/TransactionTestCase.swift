//
//  TransactionTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 08/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
import Firebase

@testable import BoursobookProduction

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

    func testInitTransactionWithDataSnapshotSouldReturnTransaction() {
        //Given
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

    func testInitTransactionWithEmptyDataSnapshotSouldReturnNil() {
        //Given
        let emptyTransactionDataSnapshot = DataSnapshot()

        //When
        guard let transaction = Transaction(snapshot: emptyTransactionDataSnapshot) else {
            XCTAssertTrue(true)
            return
        }

        //Then
        XCTAssertNil(transaction)
        XCTFail("transaction is initialised")

    }
}
