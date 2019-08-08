//
//  LabelSheetTestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 04/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class LabelSheetTestCase: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testGetNumberOfColumsShouldReturnGoodNumber() {
        // Given
        let labelSheet = LabelSheet()
        labelSheet.sheetWidthInPSP = 100
        labelSheet.firstLablePositionXInPSP = 10
        labelSheet.labelWidthInPSP = 20
        labelSheet.labelSpacingXInPSP = 5

        // When
        let numberOfColums = labelSheet.getNumberOfColumns()

        // Then
        XCTAssertEqual(numberOfColums, 3)
    }

    func testGetNumberOfRowShouldReturnGoodNumber() {
        // Given
        let labelSheet = LabelSheet()
        labelSheet.sheetHeightInPSP = 200
        labelSheet.firstLablePositionYInPSP = 10
        labelSheet.labelHeightInPSP = 10
        labelSheet.labelSpacingYInPSP = 5

        // When
        let numberOfRows = labelSheet.getNumberOfRows()

        // Then
        XCTAssertEqual(numberOfRows, 12)
    }

    func testGetNumberPerSheetShouldReturnGoodNumber() {
        // Given
        let labelSheet = LabelSheet()
        labelSheet.sheetWidthInPSP = 100
        labelSheet.firstLablePositionXInPSP = 10
        labelSheet.labelWidthInPSP = 20
        labelSheet.labelSpacingXInPSP = 5
        labelSheet.sheetHeightInPSP = 200
        labelSheet.firstLablePositionYInPSP = 10
        labelSheet.labelHeightInPSP = 10
        labelSheet.labelSpacingYInPSP = 5

        // When
        let numberPerSheet = labelSheet.getNumberPerSheet()

        // Then
        XCTAssertEqual(numberPerSheet, 36)
    }
}
