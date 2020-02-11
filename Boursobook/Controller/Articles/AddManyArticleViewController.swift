//
//  AddManyArticleViewController.swift
//  Boursobook
//
//  Created by David Dubez on 11/02/2020.
//  Copyright © 2020 David Dubez. All rights reserved.
//

import Foundation
import UIKit

class AddManyArticleViewController: UIViewController {
    // MARK: - Properties
       var activeTextField: UITextField?
       var selectedSeller: Seller?
       var articleAPI = ArticleAPI()
       var purseAPI = PurseAPI()

    // MARK: - IBOUTLET
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var sortPickerView: UIPickerView!
    @IBOutlet weak var seriesNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var activityIndicatorStack: UIStackView!

    // MARK: - IBACTION
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        resignAllTextField()
        saveManyArticle()
    }

    // MARK: - Override
      override func viewDidLoad() {
          super.viewDidLoad()
          setStyleOfVC()
          toogleActivity(loading: false)

          guard let seller = selectedSeller else {
              self.navigationController?.popViewController(animated: true)
              return
          }
          sellerNameLabel.text = "-> " + seller.firstName + " " + seller.familyName
      }

      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          addKeyboardNotification()
      }

      override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          removeKeyboardNotification()
      }

    // MARK: - Function
    private func saveManyArticle() {
        guard let seriesNameValue = seriesNameTextField.text,
            let numberText = numberTextField.text,
            let priceText = priceTextField.text
        else {
                return
        }
        if seriesNameValue == "" || numberText == "" || priceText == "" {
            displayAlert(message: NSLocalizedString("Please, fill the name, number and the price !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
            return
        }
        guard let priceValue = valueForTextField(priceTextField) else {
            displayAlert(message: NSLocalizedString("Incorrect price !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
            return
        }
        guard let numberValue = intValueForTextField(numberTextField) else {
            displayAlert(message: NSLocalizedString("Incorrect number !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
            return
        }
        toogleActivity(loading: true)
        let sortValueIndex = sortPickerView.selectedRow(inComponent: 0)
        let sortValue = Article.sort[sortValueIndex]

        //create the number of article
        let creatingArticlesGroup = DispatchGroup()

        for index in 0..<numberValue {
            creatingArticlesGroup.enter()

            let newArticle = Article(title: seriesNameValue + "_\(String(index + 1))", sort: sortValue,
            author: "", description: "",
            isbn: "", price: priceValue)
            articleAPI.createArticle(purse: InMemoryStorage.shared.inWorkingPurse,
            seller: selectedSeller,
            article: newArticle) { (error) in

               if let error = error {
                   self.displayAlert(
                       message: error.message,
                       title: NSLocalizedString(
                           "Error !", comment: ""))
               }
                creatingArticlesGroup.leave()
            }
        }

        creatingArticlesGroup.notify(queue: .main) {
            self.toogleActivity(loading: false)
            self.displayAlert(message: NSLocalizedString("Articles have been created !", comment: ""),
                              title: NSLocalizedString("Done !", comment: ""))
            self.resetForm()
        }
    }

    private func setStyleOfVC() {
        saveButton.layer.cornerRadius = 10
    }

    func toogleActivity(loading: Bool) {
        activityIndicatorStack.isHidden = !loading
        saveButton.isHidden = loading
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

    private func intValueForTextField(_ textField: UITextField) -> Int? {
        guard let textFieldValue = textField.text else {
            return nil
        }

        if let number = Int(textFieldValue) {
            return number
        } else {
            return nil
        }
    }

    private func resetForm() {
        seriesNameTextField.text = ""
        priceTextField.text = ""
        numberTextField.text = ""
    }
}

// MARK: - PICKERVIEW
extension AddManyArticleViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Article.sort.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Article.sort[row]
    }

}

// MARK: - KEYBOARD
extension AddManyArticleViewController: UITextFieldDelegate {

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        resignAllTextField()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignAllTextField()
        return true
    }

    private func resignAllTextField() {
        seriesNameTextField.resignFirstResponder()
        numberTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
    }

    @objc func keyboardWasShown(notification: NSNotification) {
        let userInfo = notification.userInfo!
        guard let keyboardFrameBegin = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardSize = keyboardFrameBegin.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        mainScrollView.contentInset = contentInsets
        mainScrollView.scrollIndicatorInsets = contentInsets

        var aRect = self.view.frame
        aRect.size.height -= keyboardSize.height

        guard let activeTextField = activeTextField else {
            return
        }
        if !aRect.contains(activeTextField.frame.origin) {
            mainScrollView.scrollRectToVisible(activeTextField.frame, animated: true)
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        mainScrollView.contentInset = contentInsets
        mainScrollView.scrollIndicatorInsets = contentInsets
    }

    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
    }
}
