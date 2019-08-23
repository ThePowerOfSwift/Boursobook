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
        labelSheet.sheetWidthInMM = 100
        labelSheet.firstLablePositionXInMM = 10
        labelSheet.labelWidthInMM = 20
        labelSheet.labelSpacingXInMM = 5

        // When
        let numberOfColums = labelSheet.getNumberOfColumns()

        // Then
        XCTAssertEqual(numberOfColums, 3)
    }

    func testGetNumberOfRowShouldReturnGoodNumber() {
        // Given
        let labelSheet = LabelSheet()
        labelSheet.sheetHeightInMM = 200
        labelSheet.firstLablePositionYInMM = 10
        labelSheet.labelHeightInMM = 10
        labelSheet.labelSpacingYInMM = 5

        // When
        let numberOfRows = labelSheet.getNumberOfRows()

        // Then
        XCTAssertEqual(numberOfRows, 12)
    }

    func testGetNumberPerSheetShouldReturnGoodNumber() {
        // Given
        let labelSheet = LabelSheet()
        labelSheet.sheetWidthInMM = 100
        labelSheet.firstLablePositionXInMM = 10
        labelSheet.labelWidthInMM = 20
        labelSheet.labelSpacingXInMM = 5
        labelSheet.sheetHeightInMM = 200
        labelSheet.firstLablePositionYInMM = 10
        labelSheet.labelHeightInMM = 10
        labelSheet.labelSpacingYInMM = 5

        // When
        let numberPerSheet = labelSheet.getNumberPerSheet()

        // Then
        XCTAssertEqual(numberPerSheet, 36)
    }
}
