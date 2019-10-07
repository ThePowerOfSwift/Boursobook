//
//  ErrorExtensionTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 07/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class ErrorExtensionTestCase: XCTestCase {

    func testErrorAsBSErrorShouldReturnRaw() {
        // Given
        let error = BookService.BSError.errorInStatusCode
        let stringRawValue = BookService.BSError.errorInStatusCode.rawValue

        // Then
        XCTAssertEqual(error.message, NSLocalizedString(stringRawValue, comment: ""))
    }

    func testErrorAsPAPIErrorShouldReturnRaw() {
        // Given
        let error = PurseAPI.PAPIError.nothing
        let stringRawValue = error.rawValue

           // Then
           XCTAssertEqual(error.message, NSLocalizedString(stringRawValue, comment: ""))
       }

    func testErrorAsSAAPIErrorShouldReturnRaw() {
     // Given
        let error = SellerAPI.SAPIError.other
     let stringRawValue = error.rawValue

        // Then
        XCTAssertEqual(error.message, NSLocalizedString(stringRawValue, comment: ""))
    }

    func testErrorAsAAPIErrorShouldReturnRaw() {
     // Given
        let error = ArticleAPI.AAPIError.other
     let stringRawValue = error.rawValue

        // Then
        XCTAssertEqual(error.message, NSLocalizedString(stringRawValue, comment: ""))
    }

    func testErrorAsUAAPIErrorShouldReturnRaw() {
     // Given
        let error = UserAuthAPI.UAAPIError.other
     let stringRawValue = error.rawValue

        // Then
        XCTAssertEqual(error.message, NSLocalizedString(stringRawValue, comment: ""))
    }

    func testErrorAsUAPIErrorShouldReturnRaw() {
     // Given
        let error = UserAPI.UAPIError.other
     let stringRawValue = error.rawValue

        // Then
        XCTAssertEqual(error.message, NSLocalizedString(stringRawValue, comment: ""))
    }

    func testErrorAsRDBErrorShouldReturnRaw() {
     // Given
        let error = RemoteDataBase.RDBError.cantInitModel
     let stringRawValue = error.rawValue

        // Then
        XCTAssertEqual(error.message, NSLocalizedString(stringRawValue, comment: ""))
    }

    func testErrorAsRAErrorShouldReturnRaw() {
     // Given
        let error = RemoteAuthentication.RAError.emailAlreadyExist
     let stringRawValue = error.rawValue

        // Then
        XCTAssertEqual(error.message, NSLocalizedString(stringRawValue, comment: ""))
    }

    func testErrorAsSAPIErrorShouldReturnRaw() {
        // Given
        let error = SaleAPI.SAPIError.nothing
        let stringRawValue = error.rawValue

           // Then
           XCTAssertEqual(error.message, NSLocalizedString(stringRawValue, comment: ""))
       }

    func testErrorAsUnknownShouldReturnDescribing() {
        // Given
        let error = FakeData.error

        // Then
        XCTAssertEqual(error.message, NSLocalizedString("Error !", comment: "")
            + "\n" + "BoursobookTests.FakeData.FakeError")
    }
}
