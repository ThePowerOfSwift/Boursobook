//
//  UserTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 06/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class UserTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testInitUserSouldReturnUser() {
        //Given
        let uniqueID = "yUUEOOOD SFZEFER"
        let email = "g.dupond@free.fr"

        //When
        let user = User(email: email, uniqueID: uniqueID)

        //Then
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.uniqueID, uniqueID)

    }

    func testInitUserWithDictionarySouldReturnUser() {
        //Given
        let uniqueID = "ID user - fake sale For test"
        let email = "email@email.com"
        let fakeUserDataDictionary = FakeDataDictionary().user

        //When
        guard let user = User(dictionary: fakeUserDataDictionary) else {
            XCTFail("error in init of user")
            return
        }

        //Then
        XCTAssertEqual(user.uniqueID, uniqueID)
        XCTAssertEqual(user.email, email)
    }

    func testInitUserWithEmptyDictionarySouldReturnNil() {
        //Given
        let fakeemptyDataDictionary = FakeDataDictionary().empty

        //When
        guard let user = User(dictionary: fakeemptyDataDictionary) else {
            XCTAssertTrue(true)
            return
        }

        //Then
        XCTAssertNil(user)
        XCTFail("user is initialised")

    }

    func testGetDictionarySouldReturnGoodValues() {
        //Given
        let fakeUserDataDictionary = FakeDataDictionary().user

        //When
        guard let user = User(dictionary: fakeUserDataDictionary) else {
            XCTFail("error in init User")
            return
        }
        let dictionaryValues = user.dictionary

        //Then
        XCTAssertEqual(dictionaryValues["uniqueID"] as? String, fakeUserDataDictionary["uniqueID"] as? String)
        XCTAssertEqual(dictionaryValues["email"] as? String,
                       fakeUserDataDictionary["email"] as? String)
    }
}
