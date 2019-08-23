//
//  BookServiceTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 07/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class BookServiceTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testGetBookShouldPostFailedCallbackIfError() {
        // Given
        let bookService = BookService(
            session: URLSessionFake(data: nil,
                                    response: nil,
                                    error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        bookService.getBook(isbn: "123456789") { (success, bookVolumeInfo, error) in

            // Then
            XCTAssertFalse(success)
            XCTAssertNil(bookVolumeInfo)
            XCTAssertEqual(error, BookService.BSError.errorInData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetBookShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let bookService = BookService(
            session: URLSessionFake(data: FakeResponseData.CorrectBookData,
                                    response: FakeResponseData.responseKO,
                                    error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        bookService.getBook(isbn: "123456789") { (success, bookVolumeInfo, error) in

            // Then
            XCTAssertFalse(success)
            XCTAssertNil(bookVolumeInfo)
            XCTAssertEqual(error, BookService.BSError.errorInStatusCode)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetBookShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let bookService = BookService(
            session: URLSessionFake(data: FakeResponseData.incorrectData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        bookService.getBook(isbn: "123456789") { (success, bookVolumeInfo, error) in

            // Then
            XCTAssertFalse(success)
            XCTAssertNil(bookVolumeInfo)
            XCTAssertEqual(error, BookService.BSError.errorInJSONDecoder)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetBookShouldPostFailedCallbackIfNoSuccesInBook() {
        // Given
        let bookService = BookService(
            session: URLSessionFake(data: FakeResponseData.CorrectDataWithError,
                                    response: FakeResponseData.responseOK,
                                    error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        bookService.getBook(isbn: "123456789") { (success, bookVolumeInfo, error) in

            // Then
            XCTAssertFalse(success)
            XCTAssertNil(bookVolumeInfo)
            XCTAssertEqual(error, BookService.BSError.errorInAPIResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetBookShouldPostFailedCallbackIfNoMatch() {
        // Given
        let bookService = BookService(
            session: URLSessionFake(data: FakeResponseData.CorrectDataWithNoBook,
                                    response: FakeResponseData.responseOK,
                                    error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        bookService.getBook(isbn: "123456789") { (success, bookVolumeInfo, error) in

            // Then
            XCTAssertFalse(success)
            XCTAssertNil(bookVolumeInfo)
            XCTAssertEqual(error, BookService.BSError.errorNoMatch)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetBookShouldPostSuccessCallbackIfMatch() {
        // Given
        let bookService = BookService(
            session: URLSessionFake(data: FakeResponseData.CorrectBookData,
                                    response: FakeResponseData.responseOK,
                                    error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        bookService.getBook(isbn: "123456789") { (success, bookVolumeInfo, error) in

            // Then
            XCTAssertTrue(success)
            XCTAssertNil(error)
            XCTAssertEqual(bookVolumeInfo?.title, "Les piliers de la terre")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetBookServiceShouldPostSuccessCallback() {
        // Given
        let bookService = BookService()

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        bookService.getBook(isbn: "9782253059530") { (success, bookVolumeInfo, error) in

            // Then
            XCTAssertTrue(success)
            XCTAssertNil(error)

            XCTAssertEqual(bookVolumeInfo?.title, "Les piliers de la terre")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
