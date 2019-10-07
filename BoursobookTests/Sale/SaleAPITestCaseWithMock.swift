//
//  SaleAPITestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 03/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class SaleAPITestCaseWithMock: XCTestCase {
    // Test in local with mock

    // MARK: - Test "getSaler" function
    func testGetSaleWithDataWithErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.sale]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Sale.collection,
                                                                  error: FakeData.error, data: goodData)
        let fakeSaleAPI = SaleAPI(saleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSaleAPI.getSale(uniqueID: "uniqueID") { (error, loadedSales) in

            //Then
            XCTAssertNil(loadedSales)
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

    func testGetSaleWithNoDataWithNoErrorSouldReturnError() {
           //Given
           let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Sale.collection,
                                                                     error: nil, data: nil)
           let fakeSaleAPI = SaleAPI(saleRemoteDataBaseRequest: remoteDatabaseRequestMock)

           //When
           let expectation = XCTestExpectation(description: "Wait for queue change.")
           fakeSaleAPI.getSale(uniqueID: "uniqueID") { (error, loadedSales) in

               //Then
               XCTAssertNil(loadedSales)
               if let error = error {
                   XCTAssertEqual(error.message, "Sorry, there is an error !")
               }
               expectation.fulfill()
           }
           wait(for: [expectation], timeout: 0.5)
       }

    func testGetSalerWithDataWithNoErrorSouldReturnSeller() {
        //Given

        let goodData = [FakeData.sale]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Sale.collection,
                                                                  error: nil, data: goodData)
        let fakeSaleAPI = SaleAPI(saleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSaleAPI.getSale(uniqueID: "uniqueID") { (error, loadedSales) in

            //Then
            XCTAssertNil(error)
            if let loadedSales = loadedSales {
                XCTAssertEqual(loadedSales.uniqueID, goodData.first?.uniqueID)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "createNewSale" function
    func testCreateWithNoPurseWithNoErrorSouldReturnError() {
        //Given

        let user = FakeData.user
        let saleRemoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Sale.collection,
                                                                  error: nil, data: nil)
        let fakeSaleAPI = SaleAPI(saleRemoteDataBaseRequest: saleRemoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSaleAPI.createNewSale(purse: nil, user: user) { (error, createdSale) in

            //Then
            XCTAssertNil(createdSale)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testCreateWithNoUserWithNoErrorSouldReturnError() {
        //Given

        let purse = FakeData.purse
        let saleRemoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Sale.collection,
                                                                  error: nil, data: nil)
        let fakeSaleAPI = SaleAPI(saleRemoteDataBaseRequest: saleRemoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSaleAPI.createNewSale(purse: purse, user: nil) { (error, createdSale) in

            //Then
            XCTAssertNil(createdSale)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testCreateWithPurseAndUserWithErrorSouldReturnError() {
        //Given

        let purse = FakeData.purse
        let user = FakeData.user
        let saleRemoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Sale.collection,
                                                                  error: FakeData.error, data: nil)
        let fakeSaleAPI = SaleAPI(saleRemoteDataBaseRequest: saleRemoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSaleAPI.createNewSale(purse: purse, user: user) { (error, createdSale) in

            //Then
            XCTAssertNil(createdSale)
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

    func testCreateWithSaleWithNoErrorSouldReturnSale() {
        //Given
        let purse = FakeData.purse
        let user = FakeData.user
        let saleRemoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Sale.collection,
                                                                  error: nil, data: nil)
        let fakeSaleAPI = SaleAPI(saleRemoteDataBaseRequest: saleRemoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSaleAPI.createNewSale(purse: purse, user: user) { (error, createdSale) in

            //Then
            XCTAssertNil(error)
            guard let newSale = createdSale else {
                XCTFail("error is nil")
                return
            }
            XCTAssertEqual(newSale.purseName, purse.name)
            XCTAssertEqual(newSale.madeByUser, user.email)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

     // MARK: - Test "updateDataforArticleSold" function

    func testUpdateWithNoPurseWithNoErrorSouldReturnError() {
        //Given

        let article = FakeData.firstArticleNotSold
        let sale = FakeData.sale

        let saleRemoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Sale.collection,
                                                                  error: nil, data: nil)
        let fakeSaleAPI = SaleAPI(saleRemoteDataBaseRequest: saleRemoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSaleAPI.updateDataforArticleSold(article: article, sale: sale, purse: nil) { (error) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            } else {
                XCTFail("there no error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testUpdateWithPurseWithErrorSouldReturnError() {
        //Given

        let article = FakeData.firstArticleNotSold
        let sale = FakeData.sale
        let purse = FakeData.purse

        let saleRemoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Sale.collection,
                                                                  error: FakeData.error, data: nil)
        let fakeSaleAPI = SaleAPI(saleRemoteDataBaseRequest: saleRemoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSaleAPI.updateDataforArticleSold(article: article, sale: sale, purse: purse) { (error) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            } else {
                XCTFail("there no error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testUpdateWithPurseWithNoErrorSouldReturnNil() {
        //Given

        let article = FakeData.firstArticleNotSold
        let sale = FakeData.sale
        let purse = FakeData.purse

        let saleRemoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Sale.collection,
                                                                  error: nil, data: nil)
        let fakeSaleAPI = SaleAPI(saleRemoteDataBaseRequest: saleRemoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSaleAPI.updateDataforArticleSold(article: article, sale: sale, purse: purse) { (error) in

            //Then
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

     // MARK: - Test "removeHard" function
    func testRemoveWithErrorSouldReturnError() {
        //Given
        let sale = FakeData.sale

        let saleRemoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Sale.collection,
                                                                  error: FakeData.error, data: nil)
        let fakeSaleAPI = SaleAPI(saleRemoteDataBaseRequest: saleRemoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSaleAPI.removeHard(sale: sale) { (error) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            } else {
                XCTFail("there no error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testRemoveWithNoErrorSouldReturnNoError() {
        //Given
        let sale = FakeData.sale

        let saleRemoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Sale.collection,
                                                                  error: nil, data: nil)
        let fakeSaleAPI = SaleAPI(saleRemoteDataBaseRequest: saleRemoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeSaleAPI.removeHard(sale: sale) { (error) in

            //Then
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
}
