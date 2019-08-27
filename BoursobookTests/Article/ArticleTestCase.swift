//
//  ArticleTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 23/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
import Firebase
@testable import Boursobook

class ArticleTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testInitArticleSouldReturnArticle() {
        //Given
        let title = "titre article"
        let sort = "Book"
        let author = "DURANS"
        let description = "un livre sympa"
        let purseName = "APE 2019"
        let isbn = "1234567890123"
        let code = "AAAA 0001"
        let price = 2.4
        let sellerCode = "AAAA"
        let sold = true
        let uniqueID = "23456643RRRRR"

        //When
        let article = Article(title: title, sort: sort,
                              author: author, description: description,
                              purseName: purseName, isbn: isbn,
                              code: code, price: price,
                              sellerCode: sellerCode,
                              solded: sold, uniqueID: uniqueID)

        //Then
        XCTAssertEqual(article.title, title)
        XCTAssertEqual(article.sort, sort)
        XCTAssertEqual(article.author, author)
        XCTAssertEqual(article.description, description)
        XCTAssertEqual(article.purseName, purseName)
        XCTAssertEqual(article.isbn, isbn)
        XCTAssertEqual(article.code, code)
        XCTAssertEqual(article.price, price)
        XCTAssertEqual(article.sellerCode, sellerCode)
        XCTAssertEqual(article.solded, sold )
        XCTAssertEqual(article.uniqueID, uniqueID)
    }

    func testInitArticleWithDataSnapshotSouldReturnArticle() {
        //Given
        let title = "titre article"
        let sort = "Book"
        let author = "DURANS"
        let description = "un livre sympa"
        let purseName = "APE 2019"
        let isbn = "1234567890123"
        let code = "AAAA 0001"
        let price = 2.4
        let sellerCode = "AAAA"
        let sold = false
        let uniqueID = "ID Article - fake article For test"

        let fakeArticleDataSnapshot = FakeArticleDataSnapshot()

        //When
        guard let article = Article(snapshot: fakeArticleDataSnapshot) else {
            XCTFail("error in init of article")
            return
        }

        //Then
        XCTAssertEqual(article.title, title)
        XCTAssertEqual(article.sort, sort)
        XCTAssertEqual(article.author, author)
        XCTAssertEqual(article.description, description)
        XCTAssertEqual(article.purseName, purseName)
        XCTAssertEqual(article.isbn, isbn)
        XCTAssertEqual(article.code, code)
        XCTAssertEqual(article.price, price)
        XCTAssertEqual(article.sellerCode, sellerCode)
        XCTAssertEqual(article.solded, sold )
        XCTAssertEqual(article.uniqueID, uniqueID)
    }

    func testInitArticleWithEmptyDataSnapshotSouldReturnNil() {
        //Given
        let emptyArticleDataSnapshot = DataSnapshot()

        //When
        guard let article = Article(snapshot: emptyArticleDataSnapshot) else {
            XCTAssertTrue(true)
            return
        }

        //Then
        XCTAssertNil(article)
        XCTFail("transaction is initialised")

    }

    func testSetValuesSouldReturnCorrectValues() {
        //Given
        let fakeArticleDataSnapshot = FakeArticleDataSnapshot()

        guard let article = Article(snapshot: fakeArticleDataSnapshot) else {
            XCTFail("error in init of article")
            return
        }

        //When
        let values = article.setValuesForRemoteDataBase()

        //Then
        XCTAssertEqual(values["title"] as? String, "titre article")
        XCTAssertEqual(values["sort"] as? String, "Book")
        XCTAssertEqual(values["author"] as? String, "DURANS")
        XCTAssertEqual(values["description"] as? String, "un livre sympa")
        XCTAssertEqual(values["purseName"] as? String, "APE 2019")
        XCTAssertEqual(values["isbn"] as? String, "1234567890123")
        XCTAssertEqual(values["code"] as? String, "AAAA 0001")
        XCTAssertEqual(values["price"] as? Double, 2.4)
        XCTAssertEqual(values["sellerCode"] as? String, "AAAA")
        XCTAssertEqual(values["solded"] as? Bool, false)
        XCTAssertEqual(values["uniqueID"] as? String, "ID Article - fake article For test")
    }
}
