//
//  TransactionServiceTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 12/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
import Firebase
@testable import Boursobook

class TransactionServiceTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testReadTransactionDataSouldReturnTransactions() {
        //Given
        let fakeTransactionService = TransactionService(with: MockDatabaseReference())
        guard let purse = Purse(snapshot: FakePurseDataSnapshot()) else {
            XCTFail("error in init purse")
            return}

        //When
        let expectaion = XCTestExpectation(description: "Wait for queue change.")
        fakeTransactionService.readAndListenData(for: purse) { (done, readedTransaction) in

            //Then
            XCTAssertTrue(done)
            XCTAssertEqual(readedTransaction[0].uniqueID, "4E242432")
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 0.5)
    }

    func testRealReadTransactionDataSouldReturnTransactions() {
        //Given
        let date = "15/01/19"
        let uniqueID = "fake transaction For test"
        let amount = 23.4
        let numberOfArticle = 7
        let madeByUser = "michel"
        let articles = ["livre": true]
        let purseName = "APE 2019"

        guard let purse = Purse(snapshot: FakePurseDataSnapshot()) else {
            XCTFail("error in init purse")
            return}

        let transaction = Transaction(date: date, uniqueID: uniqueID,
                                      amount: amount, numberOfArticle: numberOfArticle,
                                      madeByUser: madeByUser, articles: articles, purseName: purseName)

        let transactionService = TransactionService(with: Database.database().reference(withPath: "transactions"))

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        transactionService.create(transaction: transaction)
        transactionService.readAndListenData(for: purse) { (done, transactionsReaded) in
            //Then
            if done {
                for transaction in transactionsReaded where transaction.uniqueID == uniqueID {
                    XCTAssertTrue(done)
                    XCTAssertEqual(transaction.date, date)
                    XCTAssertEqual(transaction.madeByUser, madeByUser)
                }
            }
            XCTAssertTrue(done)
            XCTAssertFalse(done)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(date, "rien")
    }
}
//        faire un test directement sur firebase en creant une transaction
//        verifier si on travaille sur la test Firebase
//        et sinon changer les @testable import sur BoursobookTest
