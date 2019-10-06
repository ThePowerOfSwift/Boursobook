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

    private var userDefaultsForTest: UserDefaults!

    override func setUp() {
        userDefaultsForTest = UserDefaults(suiteName: #file)
        userDefaultsForTest.removePersistentDomain(forName: #file)
    }

    override func tearDown() {
    }

    func testGetNumberOfColumsShouldReturnGoodNumber() {
        // Given
        let labelSheet = LabelSheet(userDefaults: userDefaultsForTest)
        labelSheet.sheetWidthInMM = 100
        labelSheet.firstLablePositionXInMM = 10
        labelSheet.labelWidthInMM = 20
        labelSheet.labelSpacingXInMM = 5

        // When
        let numberOfColums = labelSheet.getNumberOfColumns()

        // Then
        XCTAssertEqual(numberOfColums, 2)
    }

    func testGetNumberOfRowShouldReturnGoodNumber() {
        // Given
        let labelSheet = LabelSheet(userDefaults: userDefaultsForTest)
        labelSheet.sheetHeightInMM = 200
        labelSheet.firstLablePositionYInMM = 10
        labelSheet.labelHeightInMM = 10
        labelSheet.labelSpacingYInMM = 5

        // When
        let numberOfRows = labelSheet.getNumberOfRows()

        // Then
        XCTAssertEqual(numberOfRows, 11)
    }

    func testGetNumberPerSheetShouldReturnGoodNumber() {
        // Given
        let labelSheet = LabelSheet(userDefaults: userDefaultsForTest)
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
        XCTAssertEqual(numberPerSheet, 22)
    }

    func testGetisLabelPortraitWithLandScapeShouldReturnFalse() {
        // Given
        let labelSheet = LabelSheet(userDefaults: userDefaultsForTest)
        labelSheet.labelWidthInMM = 20
        labelSheet.labelHeightInMM = 10

        // When
        let isPortrait = labelSheet.isLabelPortrait

        // Then
        XCTAssertEqual(isPortrait, false)
    }

    func testGetisLabelPortraitWithPortraitShouldReturnTrue() {
        // Given
        let labelSheet = LabelSheet(userDefaults: userDefaultsForTest)
        labelSheet.labelWidthInMM = 10
        labelSheet.labelHeightInMM = 20

        // When
        let isPortrait = labelSheet.isLabelPortrait

        // Then
        XCTAssertEqual(isPortrait, true)
    }

    func testSaveInUserDefaultsShouldReturnSaving() {
        // Given
        let labelSheet = LabelSheet(userDefaults: userDefaultsForTest)
        labelSheet.sheetWidthInMM = 400
        labelSheet.sheetHeightInMM = 430
        labelSheet.labelWidthInMM = 18
        labelSheet.labelHeightInMM = 25
        labelSheet.firstLablePositionXInMM = 74
        labelSheet.firstLablePositionYInMM = 86
        labelSheet.labelSpacingXInMM = 45
        labelSheet.labelSpacingYInMM = 77

        // When
        labelSheet.saveInUserDefaults()
        let nextLabelSheet = LabelSheet(userDefaults: userDefaultsForTest)

        // Then
        XCTAssertEqual(nextLabelSheet.sheetWidthInMM, labelSheet.sheetWidthInMM)
    }

    func testWriteWronfValuesInUserDefaultsShouldReturnDefault() {
        // Given
        var wrongLabelSheetSetup = [String: String]()
        wrongLabelSheetSetup.updateValue("wrongClass", forKey: "sheetWidthInMM")
        wrongLabelSheetSetup.updateValue("wrongClass", forKey: "sheetHeightInMM")
        wrongLabelSheetSetup.updateValue("wrongClass", forKey: "labelWidthInMM")
        wrongLabelSheetSetup.updateValue("wrongClass", forKey: "labelHeightInMM")
        wrongLabelSheetSetup.updateValue("wrongClass", forKey: "firstLablePositionXInMM")
        wrongLabelSheetSetup.updateValue("wrongClass", forKey: "firstLablePositionYInMM")
        wrongLabelSheetSetup.updateValue("wrongClass", forKey: "labelSpacingXInMM")
        wrongLabelSheetSetup.updateValue("wrongClass", forKey: "labelSpacingYInMM")

        userDefaultsForTest.setValue(wrongLabelSheetSetup, forKey: "labelSheetSetup")

        // When
        let labelSheet = LabelSheet(userDefaults: userDefaultsForTest)

        // Then
        XCTAssertEqual(labelSheet.sheetWidthInMM, 210)
        XCTAssertEqual(labelSheet.sheetHeightInMM, 297)
        XCTAssertEqual(labelSheet.labelWidthInMM, 25.4)
        XCTAssertEqual(labelSheet.labelHeightInMM, 10)
        XCTAssertEqual(labelSheet.firstLablePositionXInMM, 10)
        XCTAssertEqual(labelSheet.firstLablePositionYInMM, 10)
        XCTAssertEqual(labelSheet.labelSpacingXInMM, 10)
        XCTAssertEqual(labelSheet.labelSpacingYInMM, 10)
    }
}
