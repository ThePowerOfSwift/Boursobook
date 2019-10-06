//
//  ArticleAPITestCaseWithMockUD.swift
//  BoursobookTests
//
//  Created by David Dubez on 07/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class ArticleAPITestCaseWithMockUD: XCTestCase {
    // MARK: Test in local with mock

    let seller = FakeData.seller
    let purse = FakeData.purse
    let article = FakeData.firstArticleNotSold

    // MARK: - Test "removeArticle" function
    func testRemoveNoSellerNoPurseWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.removeArticle(purse: nil, seller: nil, article: article) { (error) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testRemoveWithSellerandPurseWithErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: FakeData.error, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.removeArticle(purse: purse, seller: seller, article: article) { (error) in

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

    func testRemoveWithSellerandPurseWithNoErrorSouldReturnNil() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.removeArticle(purse: purse, seller: seller, article: article) { (error) in

            //Then
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "removeArticleForDeleteSeller" function
    func testRemoveForDeleteNoSellerNoPurseWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.removeArticleForDeleteSeller(purse: nil, article: article) { (error) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testRemoveForDeleteWithSellerandPurseWithErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: FakeData.error, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.removeArticleForDeleteSeller(purse: purse, article: article) { (error) in

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

    func testRemoveForDeleteWithSellerandPurseWithNoErrorSouldReturnNil() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.removeArticleForDeleteSeller(purse: purse, article: article) { (error) in

            //Then
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "removeHard" function
    func testRemoveHardWithErrorSouldReturnError() {
        //Given

        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: FakeData.error, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.removeHard(article: article, completionHandler: { (error) in

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
           let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                     error: nil, data: nil)
           let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

           //When
           let expectation = XCTestExpectation(description: "Wait for queue change.")
           fakeArticleAPI.removeHard(article: article, completionHandler: { (error) in

               //Then
                XCTAssertNil(error)
                expectation.fulfill()
           })
           wait(for: [expectation], timeout: 0.5)
       }
}
