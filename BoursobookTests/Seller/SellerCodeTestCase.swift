//
//  SellerCodeTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 06/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class SellerCodeTestCase: XCTestCase {

    func testGetCaractersList() {
        //When
        let listOfCaracters = SellerCode.caractersList

        //Then
        XCTAssertEqual(listOfCaracters, [
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K",
            "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"])
    }

}
