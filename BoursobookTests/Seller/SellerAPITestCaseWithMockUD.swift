//
//  SellerAPITestCaseWithMockUD.swift
//  BoursobookTests
//
//  Created by David Dubez on 06/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class SellerAPITestCaseWithMockUD: XCTestCase {
// MARK: Test in local with mock

    // MARK: - Test "removeSeller" function
    func testRemoveSellerWithNoPurseWithNoErrorSouldReturnError() {
        //Given
        let seller = FakeData.seller
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: nil, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.removeSeller(seller: seller, in: nil, completionHandler: { (error) in

            //Then
            if let error = error { XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
    }

    func testRemoveSellerWithPurseWithErrorSouldReturnError() {
        //Given
        let purse = FakeData.purse
        let seller = FakeData.seller
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: FakeData.error, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.removeSeller(seller: seller, in: purse, completionHandler: { (error) in

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

    func testRemoveSellerWithPurseWithNoErrorSouldReturnNil() {
        //Given
        let purse = FakeData.purse
        let seller = FakeData.seller
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: nil, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.removeSeller(seller: seller, in: purse, completionHandler: { (error) in

            //Then
            XCTAssertNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "updateDataForArticleReturned" function
    func testUpdateDataWithNoPurseNoUserWithNoErrorSouldReturnError() {
        //Given
        let article = FakeData.firstArticleNotSold
        let seller = FakeData.seller
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: nil, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.updateDataForArticleReturned(
            article: article, seller: seller, purse: nil,
            user: nil, completionHandler: { (error) in
            //Then
            if let error = error { XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
    }

    func testRemoveSellerWithPurseAndUserWithErrorSouldReturnError() {
        //Given
        let purse = FakeData.purse
        let article = FakeData.firstArticleNotSold
        let seller = FakeData.seller
        let user = FakeData.user

        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: FakeData.error, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
    fakeSellerAPI.updateDataForArticleReturned(
        article: article, seller: seller, purse: purse,
        user: user, completionHandler: { (error) in

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

    func testRemoveSellerWithPurseAndSellerWithNoErrorSouldReturnNil() {
        //Given
        let purse = FakeData.purse
        let article = FakeData.firstArticleNotSold
        let seller = FakeData.seller
        let user = FakeData.user

        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: nil, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.updateDataForArticleReturned(
            article: article, seller: seller, purse: purse,
            user: user, completionHandler: { (error) in

            //Then
            XCTAssertNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "removeHard" function
    func testRemoveHardWithErrorSouldReturnError() {
        //Given
        let seller = FakeData.seller
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: FakeData.error, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.removeHard(seller: seller, completionHandler: { (error) in

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

    func testRemoveHardWithNoErrorSouldReturnNil() {
           //Given
           let seller = FakeData.seller
           let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                     error: nil, data: nil)
           let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

           //When
           let expectation = XCTestExpectation(description: "Wait for queue change.")
           fakeSellerAPI.removeHard(seller: seller, completionHandler: { (error) in

               //Then
                XCTAssertNil(error)
                expectation.fulfill()
           })
           wait(for: [expectation], timeout: 0.5)
       }
}
