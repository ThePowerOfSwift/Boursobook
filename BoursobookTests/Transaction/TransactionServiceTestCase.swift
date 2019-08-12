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
        guard let purse = Purse(snapshot: FakePurseDataSnapshot()) else {return}

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
}
