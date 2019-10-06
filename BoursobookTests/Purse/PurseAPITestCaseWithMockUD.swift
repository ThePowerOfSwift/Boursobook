//
//  PurseAPITestCaseWithMockUD.swift
//  BoursobookTests
//
//  Created by David Dubez on 06/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class PurseAPITestCaseWithMockUD: XCTestCase {

// MARK: - Test "Remove" function
   func testRemoveWithErrorSouldReturnError() {
       //Given
       let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection,
                                                                 error: FakeData.error, data: nil)
       let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

       //When
       let expectation = XCTestExpectation(description: "Wait for queue change.")
       fakePurseAPI.removePurse(purse: FakeData.purse, completionHandler: { (error) in
           //Then
           if let error = error {
               XCTAssertEqual(error.message, """
                                               Error !
                                               BoursobookTests.FakeData.FakeError
                                               """)
           }
           expectation.fulfill()
       })
       wait(for: [expectation], timeout: 0.5)
   }

   func testRemoveWithNoErrorSouldReturnSucceed() {
       //Given
       let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection, error: nil, data: nil)
       let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

       //When
       let expectation = XCTestExpectation(description: "Wait for queue change.")
       fakePurseAPI.removePurse(purse: FakeData.purse, completionHandler: { (error) in

           //Then
           XCTAssertNil(error)
           expectation.fulfill()
       })
       wait(for: [expectation], timeout: 0.5)
   }

// MARK: - Test "setRates" function
    func testSetRateWithErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(
            collection: Purse.collection,
            error: FakeData.error, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.setRates(purse: FakeData.purse, percentage: 10, depositFee: FakeData.depositFee) { (error) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testSetRateWithNoErrorSouldReturnNil() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(
            collection: Purse.collection,
            error: nil, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.setRates(purse: FakeData.purse, percentage: 10, depositFee: FakeData.depositFee) { (error) in

            //Then
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

// MARK: - Test "addUserFor" function
    func testaddUserWithErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(
            collection: Purse.collection,
            error: FakeData.error, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.addUserFor(purse: FakeData.purse, user: FakeData.user) { (error) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testaddUserWithNoErrorSouldReturnNil() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(
            collection: Purse.collection,
            error: nil, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.addUserFor(purse: FakeData.purse, user: FakeData.user) { (error) in

            //Then
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
}
