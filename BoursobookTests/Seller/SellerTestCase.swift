//
//  SellerTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 03/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class SellerTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testInitSellerSouldReturnSeller() {
        //Given
        let familyName = "Dupond"
        let firstName = "Gerad"
        let email = "g.dupond@free.fr"
        let phoneNumber = "0123456789"
        let code = "DUPG"
        let createdBy = "michel@me.com"
        let purseName = "APE 2019"
        let uniqueID = "diuzhdbfp djdjdj"
        let refundDate = "14/05/18"
        let refundBy = "jeannine@aol.fr"

        //When
        let seller = Seller(familyName: familyName, firstName: firstName, email: email, phoneNumber: phoneNumber,
                            code: code, createdBy: createdBy, purseName: purseName, uniqueID: uniqueID,
                            refundDate: refundDate, refundBy: refundBy)

        //Then
        XCTAssertEqual(seller.familyName, familyName)
        XCTAssertEqual(seller.firstName, firstName)
        XCTAssertEqual(seller.email, email)
        XCTAssertEqual(seller.phoneNumber, phoneNumber)
        XCTAssertEqual(seller.code, code)
        XCTAssertEqual(seller.createdBy, createdBy)
        XCTAssertEqual(seller.purseName, purseName)
        XCTAssertEqual(seller.uniqueID, uniqueID)
        XCTAssertEqual(seller.refundDate, refundDate)
        XCTAssertEqual(seller.refundBy, refundBy)
        XCTAssertEqual(seller.articlesold, 0)
        XCTAssertEqual(seller.articleRegistered, 0)
        XCTAssertEqual(seller.orderNumber, 0)
        XCTAssertEqual(seller.depositFeeAmount, 0)
        XCTAssertEqual(seller.salesAmount, 0)
        XCTAssertEqual(seller.refundDone, false)
    }

    func testInitSellerWithDictionarySouldReturnSeller() {
        //Given
        let familyName = "Dupond"
        let firstName = "Gerad"
        let email = "g.dupond@free.fr"
        let phoneNumber = "0123456789"
        let code = "DUPG"
        let createdBy = "michel@me.com"
        let purseName = "APE 2019"
        let uniqueID = "diuzhdbfp djdjdj"
        let refundDate = "14/05/18"
        let refundBy = "jeannine@aol.fr"
        let articlesold = 23
        let articleRegistered = 42
        let orderNumber = 47
        let depositFeeAmount = 2.9
        let salesAmount = 39.3
        let refundDone = true

        let sellerDataDictionary = FakeDataDictionary().seller

        //When
        guard let seller = Seller(dictionary: sellerDataDictionary) else {
            XCTFail("error in init of seller")
            return
        }

        //Then
        XCTAssertEqual(seller.familyName, familyName)
        XCTAssertEqual(seller.firstName, firstName)
        XCTAssertEqual(seller.email, email)
        XCTAssertEqual(seller.phoneNumber, phoneNumber)
        XCTAssertEqual(seller.code, code)
        XCTAssertEqual(seller.createdBy, createdBy)
        XCTAssertEqual(seller.purseName, purseName)
        XCTAssertEqual(seller.uniqueID, uniqueID)
        XCTAssertEqual(seller.refundDate, refundDate)
        XCTAssertEqual(seller.refundBy, refundBy)
        XCTAssertEqual(seller.articlesold, articlesold)
        XCTAssertEqual(seller.articleRegistered, articleRegistered)
        XCTAssertEqual(seller.orderNumber, orderNumber)
        XCTAssertEqual(seller.depositFeeAmount, depositFeeAmount)
        XCTAssertEqual(seller.salesAmount, salesAmount)
        XCTAssertEqual(seller.refundDone, refundDone)
    }

    func testInitSellerWithEmptyDictionarySouldReturnNil() {
        //Given
        let emptyDataDictionary = FakeDataDictionary().empty

        //When
        guard let seller = Seller(dictionary: emptyDataDictionary) else {
            XCTAssertTrue(true)
            return
        }

        //Then
        XCTAssertNil(seller)
        XCTFail("Seller is initialised")

    }

    func testGetDictionarySouldReturnGoodValues() {
        //Given
        let fakeSellerDataDictionary = FakeDataDictionary().seller

        //When
        guard let seller = Seller(dictionary: fakeSellerDataDictionary) else {
            XCTFail("error in init seller")
            return
        }
        var dictionaryValues = seller.dictionary

        //Then
        XCTAssertEqual(dictionaryValues["familyName"] as? String, fakeSellerDataDictionary["familyName"] as? String)
        XCTAssertEqual(dictionaryValues["firstName"] as? String, fakeSellerDataDictionary["firstName"] as? String)
        XCTAssertEqual(dictionaryValues["email"] as? String, fakeSellerDataDictionary["email"] as? String)
        XCTAssertEqual(dictionaryValues["phoneNumber"] as? String, fakeSellerDataDictionary["phoneNumber"] as? String)
        XCTAssertEqual(dictionaryValues["code"] as? String, fakeSellerDataDictionary["code"] as? String)
        XCTAssertEqual(dictionaryValues["createdBy"] as? String, fakeSellerDataDictionary["createdBy"] as? String)
        XCTAssertEqual(dictionaryValues["purseName"] as? String, fakeSellerDataDictionary["purseName"] as? String)
        XCTAssertEqual(dictionaryValues["uniqueID"] as? String, fakeSellerDataDictionary["uniqueID"] as? String)
        XCTAssertEqual(dictionaryValues["refundDate"] as? String, fakeSellerDataDictionary["refundDate"] as? String)
        XCTAssertEqual(dictionaryValues["refundBy"] as? String, fakeSellerDataDictionary["refundBy"] as? String)

        XCTAssertEqual(dictionaryValues["articlesold"] as? Int, fakeSellerDataDictionary["articlesold"] as? Int)
        XCTAssertEqual(dictionaryValues["articleRegistered"] as? Int,
                       fakeSellerDataDictionary["articleRegistered"] as? Int)
        XCTAssertEqual(dictionaryValues["orderNumber"] as? Int, fakeSellerDataDictionary["orderNumber"] as? Int)

        XCTAssertEqual(dictionaryValues["depositFeeAmount"] as? Double,
                       fakeSellerDataDictionary["depositFeeAmount"] as? Double)
        XCTAssertEqual(dictionaryValues["salesAmount"] as? Double, fakeSellerDataDictionary["salesAmount"] as? Double)

        XCTAssertEqual(dictionaryValues["refundDone"] as? Bool, fakeSellerDataDictionary["refundDone"] as? Bool)
    }

    func testCompareTwoIdenticalSellerShouldReturnTrue() {
        //Given
        let firstSellerDataDictionary = FakeDataDictionary().seller
        let secondSellerDataDictionary = FakeDataDictionary().seller

        guard let firstSeller = Seller(dictionary: firstSellerDataDictionary),
            let secondSeller = Seller(dictionary: secondSellerDataDictionary) else {
            XCTFail("error in init seller")
            return
        }

        //When
       var compare: Bool {
           return firstSeller == secondSeller
        }

        //Then
        XCTAssertTrue(compare)
    }

    func testCompareTwoDifferentSellerShouldReturnFalse() {
        //Given
        let firstSellerDataDictionary = FakeDataDictionary().seller
        let secondSellerDataDictionary = FakeDataDictionary().seller

        guard let firstSeller = Seller(dictionary: firstSellerDataDictionary),
            var secondSeller = Seller(dictionary: secondSellerDataDictionary) else {
            XCTFail("error in init seller")
            return
        }
        secondSeller.uniqueID = "different value"

        //When
        var compare: Bool {
            return firstSeller == secondSeller
        }

        //Then
        XCTAssertFalse(compare)
    }
}
