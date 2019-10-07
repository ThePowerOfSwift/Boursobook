//
//  ArticleAPITestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 05/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class ArticleAPITestCaseWithMockR: XCTestCase {
    // MARK: Test in local with mock

    let seller = FakeData.seller
    let purse = FakeData.purse

    // MARK: - Test "getArticleFor" function
    func testGetArticleWithDataWithErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: FakeData.error, data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.getArticle(uniqueID: "uniqueID") { (error, loadedArticles) in

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

    func testGetArticleWithNoDataWithNoErrorSouldReturnError() {
           //Given
           let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                     error: nil, data: nil)
           let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

           //When
           let expectation = XCTestExpectation(description: "Wait for queue change.")
           fakeArticleAPI.getArticle(uniqueID: "uniqueID") { (error, loadedArticles) in

               //Then
               XCTAssertNil(loadedArticles)
               if let error = error { XCTAssertEqual(error.message, "Sorry, there is an error !")
               }
               expectation.fulfill()
           }
           wait(for: [expectation], timeout: 0.5)
       }

    func testGetArticleWithDataWithNoErrorSouldReturnSeller() {
        //Given

        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.getArticle(uniqueID: "uniqueID") { (error, loadedArticles) in

            //Then
            XCTAssertNil(error)
            if let loadedArticles = loadedArticles {
                XCTAssertEqual(loadedArticles.uniqueID, goodData.first?.uniqueID)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "loadArticle" function
    func testLoadArticleWithNoPurseWithDataWithNoErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadArticle(code: "code", purse: nil) { (error, loadedArticles) in

            //Then
            XCTAssertNil(loadedArticles)
            if let error = error { XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadArticleWithPurseWithNoDataWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadArticle(code: "code", purse: purse) { (error, loadedArticles) in

            //Then
            XCTAssertNil(loadedArticles)
            if let error = error { XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadArticleWithPurseWithDataWithErrorSouldReturnError() {
           //Given
            let goodData = [FakeData.firstArticleNotSold]
            let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                      error: FakeData.error, data: goodData)
            let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

            //When
            let expectation = XCTestExpectation(description: "Wait for queue change.")
            fakeArticleAPI.loadArticle(code: "code", purse: purse) { (error, loadedArticles) in

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

    func testLoadArticleWithPurseWithDataOkWithNoErrorSouldReturnArticle() {
        //Given

        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadArticle(code: "AAAA 0001", purse: purse) { (error, loadedArticle) in

            //Then
            XCTAssertNil(error)
            XCTAssertNotNil(loadedArticle)
            if let loadedArticle = loadedArticle {
                XCTAssertEqual(loadedArticle.code, "AAAA 0001")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadArticleWithPurseWithDataKoWithNoErrorSouldReturnArticle() {
        //Given

        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadArticle(code: "Wrong Code", purse: purse) { (error, loadedArticle) in

            //Then
            XCTAssertNil(error)
            XCTAssertNil(loadedArticle)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "loadArticleFor" function
    func testLoadNoSellerWithDataWithNoErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadArticlesFor(seller: nil) { (error, loadedArticles) in

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
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection, error: nil, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadArticlesFor(seller: seller) { (error, loadedArticles) in

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
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection, error: FakeData.error,
                                                                  data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadArticlesFor(seller: seller) { (error, loadedArticles) in

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
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection, error: nil,
                                                                  data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadArticlesFor(seller: seller) { (error, loadedArticles) in

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

extension ArticleAPITestCaseWithMockR {

    // MARK: - Test "loadNoSoldArticleFor" function
    func testLoadNoSoldNoPurseWithDataWithNoErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadNoSoldArticlesFor(purse: nil) { (error, loadedArticles) in

            //Then
            XCTAssertNil(loadedArticles)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadNoSoldWithPurseWithNoDataWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: nil)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadNoSoldArticlesFor(purse: purse) { (error, loadedArticles) in

            //Then
            XCTAssertNil(loadedArticles)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadNoSoldWithPurseWithDataWithErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: FakeData.error, data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadNoSoldArticlesFor(purse: purse) { (error, loadedArticles) in

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

    func testLoadNoSoldWithPurseWithDataWithNoErrorSouldReturnArticle() {
        //Given
        let goodData = [FakeData.firstArticleNotSold]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadNoSoldArticlesFor(purse: purse) { (error, loadedArticles) in

            //Then
            XCTAssertNil(error)
            if let loadedArticles = loadedArticles {
                XCTAssertEqual(loadedArticles[0].uniqueID, goodData[0].uniqueID)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadNoSoldWithPurseWithDataSoldWithNoErrorSouldReturnNil() {
        //Given
        let goodData = [FakeData.articleSold, FakeData.articleReturned]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Article.collection,
                                                                  error: nil, data: goodData)
        let fakeArticleAPI = ArticleAPI(articleRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleAPI.loadNoSoldArticlesFor(purse: purse) { (error, loadedArticles) in

            //Then
            XCTAssertNil(error)
            if let loadedArticles = loadedArticles {

                XCTAssertTrue(loadedArticles.isEmpty)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
}
