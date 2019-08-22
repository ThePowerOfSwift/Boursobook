//
//  TransactionServiceTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 12/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
import Firebase
@testable import BoursobookProduction

// MARK: Test in local
class TransactionServiceTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testReadTransactionDataSouldReturnTransactions() {
        //Given
        let fakeTransactionService = TransactionService(
            transactionRemoteDataBaseRequest: RemoteDatabaseRequestMock(snapshot: FakeTransactionDataSnapshot()))

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

// MARK: Test with firebase

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

        let transactionService = TransactionService()

        let firstExpectation = XCTestExpectation(description: "Wait for reading.")

        // Confirm if a transaction with uniqueID "fake transaction For test" doesn't exist
        transactionService.readAndListenData(for: purse) { (done, transactionsReaded) in
            if done {
                for transaction in transactionsReaded where transaction.uniqueID == uniqueID {
                    XCTFail("error transaxaction allready exist")
                }
            }
            XCTAssertTrue(done)
            transactionService.stopListen()
            print("initial state verified")
            firstExpectation.fulfill()
        }
        wait(for: [firstExpectation], timeout: 5.0)

        //When

        let secondExpectation = XCTestExpectation(description: "Wait for create and reading.")
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
            print("creation and read verified")
            transactionService.stopListen()
            secondExpectation.fulfill()
        }
        wait(for: [secondExpectation], timeout: 5.0)

        transactionService.remove(transaction: transaction)

        let finalExpectation = XCTestExpectation(description: "Wait for deleting and reading.")
        transactionService.readAndListenData(for: purse) { (done, transactionsReaded) in

            //Then
            if done {
                for transaction in transactionsReaded where transaction.uniqueID == uniqueID {
                    XCTFail("error transaxaction allready exist")
                }
            }
            XCTAssertTrue(done)
            print("final state verified")
            transactionService.stopListen()
            finalExpectation.fulfill()
        }
        wait(for: [finalExpectation], timeout: 5.0)
    }
}
