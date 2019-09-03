//
//  addNewSellerViewController.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit
import Firebase

class AddNewSellerViewController: UIViewController {

    // MARK: - Properties

    // MARK: - IBOutlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var familyNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var codePickerView: UIPickerView!

    // MARK: - IBActions
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        saveSeller()
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Function
    private func saveSeller() {
        guard let userLogIn = UserService.shared.userLogIn,
            let currentPurse = InMemoryStorage.shared.currentPurse else {
                return
        }

        guard let firstNameValue = firstNameTextField.text, let familyNameValue = familyNameTextField.text,
            let emailValue = emailTextField.text, let phoneNumberValue = phoneNumberTextField.text else {
            return
        }
        if firstNameValue == "" || familyNameValue == "" || emailValue == "" || phoneNumberValue == "" {
            displayAlert(message: NSLocalizedString("Please, fill all the field !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
            return
        }

        var code = ""
        for index in 0...(codePickerView.numberOfComponents - 1) {
            let codeIndex = codePickerView.selectedRow(inComponent: index)
            code += SellerCode.caractersList[codeIndex]
        }

        if InMemoryStorage.shared.isExistingSellerWith(code: code) {
            displayAlert(message: NSLocalizedString("Code already exist, please change it !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
            return
        }
        let uniqueIDValue = code + " " + UUID().description
        let seller = Seller(familyName: familyNameValue, firstName: firstNameValue, email: emailValue,
                            phoneNumber: phoneNumberValue, code: code,
                            createdBy: userLogIn.email, purseName: currentPurse.name,
                            uniqueID: uniqueIDValue, refundDate: "nil", refundBy: "nil")

        InMemoryStorage.shared.addSeller(seller)

        self.navigationController?.popViewController(animated: true)
    }

    private func setCode() {
        // set the pickerView with the letters of the family name and the first name
        guard let familyNameValue = familyNameTextField.text else {
            return
        }
        guard let firstNameValue = firstNameTextField.text else {
            return
        }

        selectLetters(from: familyNameValue, for: codePickerView, startComponent: 0, number: 3)
        selectLetters(from: firstNameValue, for: codePickerView, startComponent: 3, number: 1)
    }

    private func selectLetters(from text: String, for pickerView: UIPickerView, startComponent: Int, number: Int) {
        // display the letter corresponding of the carracters in text
        var textArray = [String]()
        for index in text.indices {
            textArray.append(String(text[index].uppercased()))
        }
        if textArray.count == 0 {
            for component in 0...(number - 1) {
                pickerView.selectRow(0, inComponent: (component + startComponent), animated: true)
            }
            return
        } else if textArray.count < number {
            for component in 0...(number - 1) {
            pickerView.selectRow(0, inComponent: (component + startComponent), animated: true)
            }
            for component in 0...(textArray.count - 1) {
                for (index, letter)  in SellerCode.caractersList.enumerated()
                    where letter == textArray[component] {
                        pickerView.selectRow(index, inComponent: (component + startComponent), animated: true)
                }
            }
            return
        }
        for component in 0...(number - 1) {
            for (index, letter)  in SellerCode.caractersList.enumerated()
                where letter == textArray[component] {
                    pickerView.selectRow(index, inComponent: (component + startComponent), animated: true)
            }
        }
    }
}

// MARK: - PICKERVIEW
extension AddNewSellerViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 26
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SellerCode.caractersList[row]
    }

}

// MARK: - KEYBOARD
extension AddNewSellerViewController: UITextFieldDelegate {

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        resignAllTextField()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignAllTextField()
        return true
    }

    private func resignAllTextField() {
        firstNameTextField.resignFirstResponder()
        familyNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        setCode()
    }
}
