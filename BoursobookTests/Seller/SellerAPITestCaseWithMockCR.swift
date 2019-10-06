//
//  SellerAPITestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 05/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class SellerAPITestCaseWithMockCR: XCTestCase {
// MARK: Test in local with mock

    let purse = FakeData.purse

    // MARK: - Test "getSellerFor" function
    func testGetSellerWithDataWithErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.seller]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: FakeData.error, data: goodData)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.getSeller(uniqueID: "uniqueID") { (error, loadedSellers) in

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

    func testGetSellerWithNoDataWithNoErrorSouldReturnError() {
           //Given
           let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                     error: nil, data: nil)
           let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

           //When
           let expectation = XCTestExpectation(description: "Wait for queue change.")
           fakeSellerAPI.getSeller(uniqueID: "uniqueID") { (error, loadedSellers) in

               //Then
               XCTAssertNil(loadedSellers)
               if let error = error {
                   XCTAssertEqual(error.message, "Sorry, there is an error !")
               }
               expectation.fulfill()
           }
           wait(for: [expectation], timeout: 0.5)
       }

    func testGetSellerWithDataWithNoErrorSouldReturnSeller() {
        //Given

        let goodData = [FakeData.seller]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: nil, data: goodData)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.getSeller(uniqueID: "uniqueID") { (error, loadedSellers) in

            //Then
            XCTAssertNil(error)
            if let loadedSellers = loadedSellers {
                XCTAssertEqual(loadedSellers.uniqueID, goodData.first?.uniqueID)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "loadSellerFor" function
    func testLoadNoPurseWithDataWithNoErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.seller]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: nil, data: goodData)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.loadSellersFor(purseName: nil) { (error, loadedSellers) in

            //Then
            XCTAssertNil(loadedSellers)
            if let error = error { XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadNoDataWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection, error: nil, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.loadSellersFor(purseName: purse.name) { (error, loadedSellers) in

            //Then
            XCTAssertNil(loadedSellers)
            if let error = error { XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadDataWithErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.seller]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection, error: FakeData.error,
                                                                  data: goodData)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.loadSellersFor(purseName: purse.name) { (error, loadedSellers) in

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
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection, error: nil,
                                                                  data: goodData)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.loadSellersFor(purseName: purse.name) { (error, loadedSellers) in

            //Then
            XCTAssertNil(error)
            guard let listOfSellers = loadedSellers else { XCTFail("error is nil")
                return
            }
            XCTAssertEqual(listOfSellers[0].uniqueID, goodData[0].uniqueID)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "loadSeller" function
    func testLoadByUniqueIDWithDataWithErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.seller]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: FakeData.error, data: goodData)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.loadSeller(uniqueID: "uniqueID") { (error, loadedSellers) in

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

    func testLoadByUniqueIDWithNoDataWithNoErrorSouldReturnError() {
        //Given

        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: nil, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.loadSeller(uniqueID: "uniqueID") { (error, loadedSellers) in

            //Then
            XCTAssertNil(loadedSellers)
            if let error = error { XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadByUniqueIDWithDataWithNoErrorSouldReturnSeller() {
        //Given

        let goodData = [FakeData.seller]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: nil, data: goodData)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.loadSeller(uniqueID: "uniqueID") { (error, loadedSellers) in

            //Then
            XCTAssertNil(error)
            if let loadedSellers = loadedSellers {
                XCTAssertEqual(loadedSellers.uniqueID, goodData.first?.uniqueID)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "getExistingSellerCode" function
       func testgetExistingSellerCodeWithDataWithErrorSouldReturnError() {
           //Given
            let goodData = [FakeData.seller, FakeData.seller]
           let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                     error: FakeData.error, data: goodData)
           let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

           //When
           let expectation = XCTestExpectation(description: "Wait for queue change.")
           fakeSellerAPI.getExistingSellerCode { (error, loadedSellers) in

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

    func testgetExistingSellerCodeWithNoDataWithNoErrorSouldReturnError() {
        //Given

        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: nil, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.getExistingSellerCode { (error, loadedSellers) in

            //Then
            XCTAssertNil(loadedSellers)
            if let error = error {  XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testgetExistingSellerCodeWithDataWithNoErrorSouldReturnSeller() {
        //Given

        let goodData = [FakeData.seller, FakeData.seller]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: nil, data: goodData)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.getExistingSellerCode { (error, loadedSellers) in

            //Then
            XCTAssertNil(error)
            if let loadedSellers = loadedSellers {
                XCTAssertEqual(loadedSellers[0], goodData[0].code)
                XCTAssertEqual(loadedSellers[1], goodData[1].code)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "createSeller" function
    func testCreateSellerWithNoPurseWithNoErrorSouldReturnError() {
        //Given
        let seller = FakeData.seller
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: nil, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.createSeller(newSeller: seller, in: nil, completionHandler: { (error) in

            //Then
            if let error = error { XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
    }

    func testCreateSellerWithPurseWithErrorSouldReturnError() {
        //Given
        let purse = FakeData.purse
        let seller = FakeData.seller
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: FakeData.error, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.createSeller(newSeller: seller, in: purse, completionHandler: { (error) in

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

    func testCreateSellerWithPurseWithNoErrorSouldReturnNil() {
        //Given
        let purse = FakeData.purse
        let seller = FakeData.seller
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Seller.collection,
                                                                  error: nil, data: nil)
        let fakeSellerAPI = SellerAPI(sellerRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSellerAPI.createSeller(newSeller: seller, in: purse, completionHandler: { (error) in

            //Then
            XCTAssertNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
    }
}
