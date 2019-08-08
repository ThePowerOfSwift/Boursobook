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
    // PDF use PostScriptPoints as unit
    // 71 PSP = 1 inch = 25,4 mm

    var sheetWidthInPSP: Double = 5870           // standard A4 210 mm = 8,2677 inch = 587,00 PSP
    var sheetHeightInPSP: Double = 8301.968      // standard A4 297 mm = 11,6929 inch = 830,1968 PSP
    var labelWidthInPSP: Double = 710             // 25.4 mm = 71 PSP
    var labelHeightInPSP: Double = 279.527            // 10 mm = 27,9527 PSP

    var firstLablePositionXInPSP: Double = 150
    var firstLablePositionYInPSP: Double = 150

    var labelSpacingXInPSP: Double = 150
    var labelSpacingYInPSP: Double = 150

    // MARK: Functions
    func getNumberOfColumns() -> Int {
        let calculation = (sheetWidthInPSP - firstLablePositionXInPSP ) / ( labelWidthInPSP + labelSpacingXInPSP)
        return Int(calculation.rounded(.towardZero))
    }

    func getNumberOfRows() -> Int {
        let calculation = (sheetHeightInPSP - firstLablePositionYInPSP ) / ( labelHeightInPSP + labelSpacingYInPSP)
        return Int(calculation.rounded(.towardZero))
    }

    func getNumberPerSheet() -> Int {
        return getNumberOfRows() * getNumberOfColumns()
    }
}

// TODO:    - Imposer taille etiquette h = 50 % largeur
//          - Mettre taille en mm et transformer en
//          - verifier si valeur diff de zero
