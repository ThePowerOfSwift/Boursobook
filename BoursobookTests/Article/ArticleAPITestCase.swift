//
//  ArticleAPITestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 05/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class ArticleAPITestCase: XCTestCase {

    let purse = FakeData.purse

    override func setUp() {
    }

    override func tearDown() {
    }

    // MARK: Test in local with mock
    func testLoadNoPurseWithDataWithNoErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: nil, data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadArticlesFor(purse: nil) { (error, loadedArticles) in

            //Then
            XCTAssertNil(loadedArticles)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadNoDataWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: nil, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadArticlesFor(purse: purse) { (error, loadedArticles) in

            //Then
            XCTAssertNil(loadedArticles)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadDataWithErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: FakeData.error,
                                                                  data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadArticlesFor(purse: purse) { (error, loadedArticles) in

            //Then
            XCTAssertNil(loadedArticles)
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
        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: nil,
                                                                  data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadArticlesFor(purse: purse) { (error, loadedArticles) in

            //Then
            XCTAssertNil(error)
            guard let listOfArticles = loadedArticles else {
                XCTFail("error is nil")
                return
            }
            XCTAssertEqual(listOfArticles[0].uniqueID, goodData[0].uniqueID)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
}
