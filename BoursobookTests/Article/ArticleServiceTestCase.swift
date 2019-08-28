//
//  ArticleServiceTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 26/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
import Firebase
@testable import Boursobook

class ArticleServiceTestCase: XCTestCase {

    let testPurse = FakeData.purse
    let testArticle = FakeData.firstArticleNotSold
    let firstArticleNotSold = FakeData.firstArticleNotSold
    let secondArticleNotSold = FakeData.secondArticleNotSold

    override func setUp() {
    }

    override func tearDown() {
    }

    // MARK: Test in local with mock
    func testReadArticleDataSouldReturnArticles() {
        //Given
        let fakeArticleService = ArticleService(articleRemoteDataBaseRequest:
            RemoteDatabaseRequestMock(snapshot: FakeArticleDataSnapshot()))

        //When
        let expectaion = XCTestExpectation(description: "Wait for queue change.")
        fakeArticleService.readAndListenData(for: testPurse) { (done, readedArticle) in
            //Then
            XCTAssertTrue(done)
            XCTAssertEqual(readedArticle[0].uniqueID, "ID Article - fake article For test")
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 0.5)
    }

    // MARK: Test with firebase

    func testRealReadArticleDataSouldReturnArticle() {

        //Given
        let articleService = ArticleService()

        let firstExpectation = XCTestExpectation(description: "Wait for reading.")

        // Confirm if a article with testArticle uniqueID doesn't exist
        articleService.readAndListenData(for: testPurse) { (done, articlesReaded) in
            if done {
                for article in articlesReaded
                    where article.uniqueID == self.testArticle.uniqueID {
                        XCTFail("error article allready exist")
                }
            }
            XCTAssertTrue(done)
            articleService.stopListen()
            firstExpectation.fulfill()
        }
        wait(for: [firstExpectation], timeout: 5.0)

        //When

        let secondExpectation = XCTestExpectation(description: "Wait for create and reading.")
        // Create a article in FireBase and test if it exist after
        articleService.create(article: testArticle)
        articleService.readAndListenData(for: testPurse) { (done, articlesReaded) in

            //Then
            if done {
                for article in articlesReaded
                    where article.uniqueID == self.testArticle.uniqueID {
                        XCTAssertEqual(article.title, "titre article")
                        XCTAssertEqual(article.isbn, "1234567890123")
                }
            }
            XCTAssertTrue(done)
            articleService.stopListen()
            secondExpectation.fulfill()
        }
        wait(for: [secondExpectation], timeout: 5.0)

        // delete the article from firebase and confirm it
        articleService.remove(article: testArticle)

        let finalExpectation = XCTestExpectation(description: "Wait for deleting and reading.")
        articleService.readAndListenData(for: testPurse) { (done, articlesReaded) in

            //Then
            if done {
                for article in articlesReaded
                    where article.uniqueID == self.testArticle.uniqueID {
                        XCTFail("error article allready exist")
                }
            }
            XCTAssertTrue(done)
            articleService.stopListen()
            finalExpectation.fulfill()
        }
        wait(for: [finalExpectation], timeout: 5.0)
    }

    func testUpdateSoldListOfArticleSouldReturnArticleSold() {

        //Given

        let updateList = [firstArticleNotSold.uniqueID: true, secondArticleNotSold.uniqueID: true]
        let articleService = ArticleService()

        // Create the two articles in FireBase and test if they are not sold
        let firstExpectation = XCTestExpectation(description: "Wait for creating and reading.")
        articleService.create(article: firstArticleNotSold)
        articleService.create(article: secondArticleNotSold)
        articleService.readAndListenData(for: testPurse) { (done, articlesReaded) in
            if done {
                for article in articlesReaded
                    where article.uniqueID == self.firstArticleNotSold.uniqueID
                        || article.uniqueID == self.secondArticleNotSold.uniqueID {
                        XCTAssertEqual(article.sold, false)
                }
            }
            XCTAssertTrue(done)
            articleService.stopListen()
            firstExpectation.fulfill()
        }
        wait(for: [firstExpectation], timeout: 5.0)

        //When
        // Update the two articles in FireBase and test if they are sold after
        let secondExpectation = XCTestExpectation(description: "Wait for updating and reading.")
        articleService.updatesoldList(list: updateList)
        articleService.readAndListenData(for: testPurse) { (done, articlesReaded) in

            //Then
            if done {
                for article in articlesReaded
                    where article.uniqueID == self.firstArticleNotSold.uniqueID
                        || article.uniqueID == self.secondArticleNotSold.uniqueID {
                        XCTAssertEqual(article.sold, true)
                }
            }
            XCTAssertTrue(done)
            articleService.stopListen()
            secondExpectation.fulfill()
        }
        wait(for: [secondExpectation], timeout: 5.0)

        // Delete the two articles in FireBase
        articleService.remove(article: firstArticleNotSold)
        articleService.remove(article: secondArticleNotSold)

        let finalExpectation = XCTestExpectation(description: "Wait for updating and reading.")
        articleService.readAndListenData(for: testPurse) { (done, articlesReaded) in

            if done {
                for article in articlesReaded
                    where article.uniqueID == self.firstArticleNotSold.uniqueID
                        || article.uniqueID == self.secondArticleNotSold.uniqueID {
                        XCTFail("error articles wasn't delete")
                }
            }
            XCTAssertTrue(done)
            articleService.stopListen()
            finalExpectation.fulfill()
        }
        wait(for: [finalExpectation], timeout: 5.0)
    }
}
