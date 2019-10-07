//
//  LabelSheet.swift
//  Boursobook
//
//  Created by David Dubez on 20/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class LabelSheet {

    // MARK: Properties
    private var userDefaults: UserDefaults
    var sheetWidthInMM: Double
    var sheetHeightInMM: Double
    var labelWidthInMM: Double
    var labelHeightInMM: Double

    var firstLablePositionXInMM: Double
    var firstLablePositionYInMM: Double

    var labelSpacingXInMM: Double
    var labelSpacingYInMM: Double

    var isLabelPortrait: Bool {
        if labelWidthInMM > labelHeightInMM {
            return false
        }
        return true
    }

    // MARK: Initialisation
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        if let labelSheetSetup = userDefaults.dictionary(forKey: "labelSheetSetup") {
            self.sheetWidthInMM = labelSheetSetup["sheetWidthInMM"] as? Double ?? 210
            self.sheetHeightInMM = labelSheetSetup["sheetHeightInMM"] as? Double ?? 297
            self.labelWidthInMM = labelSheetSetup["labelWidthInMM"] as? Double ?? 50
            self.labelHeightInMM = labelSheetSetup["labelHeightInMM"] as? Double ?? 20
            self.firstLablePositionXInMM = labelSheetSetup["firstLablePositionXInMM"] as? Double ?? 10
            self.firstLablePositionYInMM = labelSheetSetup["firstLablePositionYInMM"] as? Double ?? 10
            self.labelSpacingXInMM = labelSheetSetup["labelSpacingXInMM"] as? Double ?? 10
            self.labelSpacingYInMM = labelSheetSetup["labelSpacingYInMM"] as? Double ?? 10
        } else {
            self.sheetWidthInMM = 210
            self.sheetHeightInMM = 297
            self.labelWidthInMM = 50
            self.labelHeightInMM = 20
            self.firstLablePositionXInMM = 10
            self.firstLablePositionYInMM = 10
            self.labelSpacingXInMM = 10
            self.labelSpacingYInMM = 10
        }
    }

    // MARK: Functions
    func getNumberOfColumns() -> Int {
        let calculation = (sheetWidthInMM - firstLablePositionXInMM ) / ( labelWidthInMM + labelSpacingXInMM)
        return Int(calculation.rounded(.towardZero)) - 1
    }

    func getNumberOfRows() -> Int {
        let calculation = (sheetHeightInMM - firstLablePositionYInMM ) / ( labelHeightInMM + labelSpacingYInMM)
        return Int(calculation.rounded(.towardZero)) - 1
    }

    func getNumberPerSheet() -> Int {
        return getNumberOfRows() * getNumberOfColumns()
    }

    func saveInUserDefaults() {
        var labelSheetSetup = [String: Double]()
        labelSheetSetup.updateValue(sheetWidthInMM, forKey: "sheetWidthInMM")
        labelSheetSetup.updateValue(sheetHeightInMM, forKey: "sheetHeightInMM")
        labelSheetSetup.updateValue(labelWidthInMM, forKey: "labelWidthInMM")
        labelSheetSetup.updateValue(labelHeightInMM, forKey: "labelHeightInMM")
        labelSheetSetup.updateValue(firstLablePositionXInMM, forKey: "firstLablePositionXInMM")
        labelSheetSetup.updateValue(firstLablePositionYInMM, forKey: "firstLablePositionYInMM")
        labelSheetSetup.updateValue(labelSpacingXInMM, forKey: "labelSpacingXInMM")
        labelSheetSetup.updateValue(labelSpacingYInMM, forKey: "labelSpacingYInMM")
        userDefaults.setValue(labelSheetSetup, forKey: "labelSheetSetup")
  //      UserDefaults.standard.setValue(labelSheetSetup, forKey: "labelSheetSetup")
    }
}

// PDF use PostScriptPoints as unit
// 71 PSP = 1 inch = 25,4 mm

// standard A4 210 mm = 8,2677 inch = 587,00 PSP
// standard A4 297 mm = 11,6929 inch = 830,1968 PSP
// 25.4 mm = 71 PSP
// 10 mm = 27,9527 PSP
