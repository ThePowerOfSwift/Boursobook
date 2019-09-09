//
//  SellerAPITestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 05/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class SellerAPITestCase: XCTestCase {

    let purse = FakeData.purse

    override func setUp() {
    }

    override func tearDown() {
    }

    // MARK: Test in local with mock
    func testLoadNoPurseWithDataWithNoErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.seller]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: .seller, error: nil, data: goodData)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.loadSellersFor(purse: nil) { (error, loadedSellers) in

            //Then
            XCTAssertNil(loadedSellers)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadNoDataWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: .seller, error: nil, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.loadSellersFor(purse: purse) { (error, loadedSellers) in

            //Then
            XCTAssertNil(loadedSellers)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadDataWithErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.seller]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: .seller, error: FakeData.error,
                                                                  data: goodData)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.loadSellersFor(purse: purse) { (error, loadedSellers) in

            //Then
            XCTAssertNil(loadedSellers)
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

    func testLoadDataWithNoErrorSouldReturnData() {
        //Given
        let goodData = [FakeData.seller]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: .seller, error: nil,
                                                                  data: goodData)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.loadSellersFor(purse: purse) { (error, loadedSellers) in

            //Then
            XCTAssertNil(error)
            guard let listOfSellers = loadedSellers else {
                XCTFail("error is nil")
                return
            }
            XCTAssertEqual(listOfSellers[0].uniqueID, goodData[0].uniqueID)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
}
