//
//  ArticleAPITestCaseWithMockCR.swift
//  BoursobookTests
//
//  Created by David Dubez on 07/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class ArticleAPITestCaseWithMockCR: XCTestCase {
    // MARK: Test in local with mock

    let seller = FakeData.seller
    let purse = FakeData.purse
    let article = FakeData.firstArticleNotSold

    // MARK: - Test "getArticleFor" function
    func testGetNoSellerWithDataWithNoErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.getArticlesFor(seller: nil) { (error, loadedArticles) in

            //Then
            XCTAssertNil(loadedArticles)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetNoDataWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection, error: nil, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.getArticlesFor(seller: seller) { (error, loadedArticles) in

            //Then
            XCTAssertNil(loadedArticles)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetDataWithErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection, error: FakeData.error,
                                                                  data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.getArticlesFor(seller: seller) { (error, loadedArticles) in

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

    func testGetDataWithNoErrorSouldReturnData() {
        //Given
        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection, error: nil,
                                                                  data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.getArticlesFor(seller: seller) { (error, loadedArticles) in

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

    // MARK: - Test "createArticle" function
    func testCreateNoSellerNoPurseWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.createArticle(purse: nil, seller: nil, article: article) { (error) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testCreateWithSellerandPurseWithErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: FakeData.error, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.createArticle(purse: purse, seller: seller, article: article) { (error) in

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

    func testCreateWithSellerandPurseWithNoErrorSouldReturnNil() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.createArticle(purse: purse, seller: seller, article: article) { (error) in

            //Then
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

}
