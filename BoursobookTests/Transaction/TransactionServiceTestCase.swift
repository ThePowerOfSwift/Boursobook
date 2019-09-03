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
    
    let testPurse = FakeData.purse
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
}

/*
class TransactionServiceTestCase: XCTestCase {

    let testPurse = FakeData.purse

    override func setUp() {
    }

    override func tearDown() {
    }

// MARK: Test in local with mock
    func testReadTransactionDataSouldReturnTransactions() {
        //Given
        let fakeTransactionService = TransactionService(
            transactionRemoteDataBaseRequest: RemoteDatabaseRequestMock(snapshot: FakeTransactionDataSnapshot()))

        //When
        let expectaion = XCTestExpectation(description: "Wait for queue change.")
        fakeTransactionService.readAndListenData(for: testPurse) { (done, readedTransaction) in

            //Then
            XCTAssertTrue(done)
            XCTAssertEqual(readedTransaction[0].uniqueID, "ID Transaction - fake transaction For test")
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 0.5)
    }

// MARK: Test with firebase

    func testRealReadTransactionDataSouldReturnTransactions() {

        //Given
        let testTransaction = FakeData.transaction
        let transactionService = TransactionService()

        let firstExpectation = XCTestExpectation(description: "Wait for reading.")

        // Confirm if a transaction with the same uniqueID that testTransaction doesn't exist
        transactionService.readAndListenData(for: testPurse) { (done, transactionsReaded) in
            if done {
                for transaction in transactionsReaded
                    where transaction.uniqueID == testTransaction.uniqueID {
                    XCTFail("error transaxaction allready exist")
                }
            }
            XCTAssertTrue(done)
            transactionService.stopListen()
            firstExpectation.fulfill()
        }
        wait(for: [firstExpectation], timeout: 5.0)

        //When

        let secondExpectation = XCTestExpectation(description: "Wait for create and reading.")
        // Create a transaction in FireBase and test if it exist after
        transactionService.create(transaction: testTransaction)
        transactionService.readAndListenData(for: testPurse) { (done, transactionsReaded) in

            //Then
            if done {
                for transaction in transactionsReaded
                    where transaction.uniqueID == testTransaction.uniqueID {
                    XCTAssertEqual(transaction.date, "15/01/19")
                    XCTAssertEqual(transaction.madeByUser, "michel")
                }
            }
            XCTAssertTrue(done)
            transactionService.stopListen()
            secondExpectation.fulfill()
        }
        wait(for: [secondExpectation], timeout: 5.0)

        // delete the transaction from firebase and confirm it
        transactionService.remove(transaction: testTransaction)

        let finalExpectation = XCTestExpectation(description: "Wait for deleting and reading.")
        transactionService.readAndListenData(for: testPurse) { (done, transactionsReaded) in

            //Then
            if done {
                for transaction in transactionsReaded
                    where transaction.uniqueID == testTransaction.uniqueID {
                    XCTFail("error transaxaction allready exist")
                }
            }
            XCTAssertTrue(done)
            transactionService.stopListen()
            finalExpectation.fulfill()
        }
        wait(for: [finalExpectation], timeout: 5.0)
    }
}
*/
