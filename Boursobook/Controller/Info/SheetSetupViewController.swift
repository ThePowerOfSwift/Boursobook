//
//  SheetSetupViewController.swift
//  Boursobook
//
//  Created by David Dubez on 09/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SheetSetupViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var sheetWidthInMMTextField: UITextField!
    @IBOutlet weak var sheetHeightInMMTextField: UITextField!
    @IBOutlet weak var labelWidthInMMTextField: UITextField!
    @IBOutlet weak var labelHeightInMMTextField: UITextField!
    @IBOutlet weak var firstLablePositionXInMMTextField: UITextField!
    @IBOutlet weak var firstLablePositionYInMMTextField: UITextField!
    @IBOutlet weak var labelSpacingXInMMTextField: UITextField!
    @IBOutlet weak var labelSpacingYInMMTextField: UITextField!

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    // MARK: - IBActions
    @IBAction func didTapSaveButton(_ sender: Any) {
        saveLabelSheetSetup()
    }
    @IBAction func didTapCancelButton(_ sender: Any) {
        updateValues()
    }

    // MARK: - Properties
    var labelSheet = LabelSheet()

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()
        updateValues()
    }

    // MARK: - Functions
    private func updateValues() {
        sheetWidthInMMTextField.text = formatDiplayedNumber(labelSheet.sheetWidthInMM)
        sheetHeightInMMTextField.text = formatDiplayedNumber(labelSheet.sheetHeightInMM)
        labelWidthInMMTextField.text = formatDiplayedNumber(labelSheet.labelWidthInMM)
        labelHeightInMMTextField.text = formatDiplayedNumber(labelSheet.labelHeightInMM)
        firstLablePositionXInMMTextField.text = formatDiplayedNumber(labelSheet.firstLablePositionXInMM)
        firstLablePositionYInMMTextField.text = formatDiplayedNumber(labelSheet.firstLablePositionYInMM)
        labelSpacingXInMMTextField.text = formatDiplayedNumber(labelSheet.labelSpacingXInMM)
        labelSpacingYInMMTextField.text = formatDiplayedNumber(labelSheet.labelSpacingYInMM)
    }

    private func saveLabelSheetSetup() {
        resignAllTextField()
        guard let sheetWidthInMMValue = valueForTextField(sheetWidthInMMTextField),
            let sheetHeightInMMValue = valueForTextField(sheetHeightInMMTextField),
            let labelWidthInMMValue = valueForTextField(labelWidthInMMTextField),
            let labelHeightInMMValue = valueForTextField(labelHeightInMMTextField),
            let firstLablePositionXInMMValue = valueForTextField(firstLablePositionXInMMTextField),
            let firstLablePositionYInMMValue = valueForTextField(firstLablePositionYInMMTextField),
            let labelSpacingXInMMValue = valueForTextField(labelSpacingXInMMTextField),
            let labelSpacingYInMMValue = valueForTextField(labelSpacingYInMMTextField)
            else {
                displayAlert(message: NSLocalizedString("Please, fill correctly all the field !", comment: ""),
                             title: NSLocalizedString("Error !", comment: ""))
                return
        }

        if labelSheet.isLabelPortrait {
            displayAlert(message: NSLocalizedString("We advise you to create a landscape label !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
        }

        labelSheet.sheetWidthInMM = sheetWidthInMMValue
        labelSheet.sheetHeightInMM = sheetHeightInMMValue
        labelSheet.labelWidthInMM = labelWidthInMMValue
        labelSheet.labelHeightInMM = labelHeightInMMValue
        labelSheet.firstLablePositionXInMM = firstLablePositionXInMMValue
        labelSheet.firstLablePositionYInMM = firstLablePositionYInMMValue
        labelSheet.labelSpacingXInMM = labelSpacingXInMMValue
        labelSheet.labelSpacingYInMM = labelSpacingYInMMValue

        labelSheet.saveInUserDefaults()
        updateValues()
    }

    private func formatDiplayedNumber(_ number: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
            return formattedNumber
        } else {
            return nil
        }
    }

    private func valueForTextField(_ textField: UITextField) -> Double? {
        guard let textFieldValue = textField.text else {
            return nil
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let formattedNumber = formatter.number(from: textFieldValue) {
            return Double(truncating: formattedNumber)
        } else {
            return nil
        }
    }

    private func setStyleOfVC() {
        saveButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
    }

}

// MARK: - KEYBOARD
extension SheetSetupViewController: UITextFieldDelegate {

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        resignAllTextField()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignAllTextField()
        return true
    }

    private func resignAllTextField() {
        sheetWidthInMMTextField.resignFirstResponder()
        sheetHeightInMMTextField.resignFirstResponder()
        labelWidthInMMTextField.resignFirstResponder()
        labelHeightInMMTextField.resignFirstResponder()
        firstLablePositionXInMMTextField.resignFirstResponder()
        firstLablePositionYInMMTextField.resignFirstResponder()
        labelSpacingXInMMTextField.resignFirstResponder()
        labelSpacingYInMMTextField.resignFirstResponder()
    }
}
