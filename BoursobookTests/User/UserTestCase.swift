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
}
