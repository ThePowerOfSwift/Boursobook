//
//  AddArticleViewController.swift
//  Boursobook
//
//  Created by David Dubez on 25/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class AddArticleViewController: UIViewController {

    // MARK: - Properties
    var selectedSeller: Seller?

    // MARK: - IBOUTLET
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var sortPickerView: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTexField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var isbnTextField: UITextField!
    @IBOutlet weak var articleCodeLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!

    // MARK: - IBACTION
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        resignAllTextField()
        saveArticle()
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let seller = selectedSeller else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        sellerNameLabel.text = "Seller : " + seller.firstName + " " + seller.familyName
    }

    override func viewWillAppear(_ animated: Bool) {
        // Listen for keyBoard events
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    // MARK: - Function
    private func saveArticle() {
        guard let titleValue = titleTextField.text,
            let authorValue = authorTexField.text,
            let descriptionValue = descriptionTextView.text,
            let isbnValue = isbnTextField.text,
            let priceText = priceTextField.text,
            let seller = selectedSeller
        else {
                return
        }
        if titleValue == "" || priceText == "" {
            displayAlert(message: NSLocalizedString("Please, fill the name and the price !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
            return
        }
        guard let priceValue = Double(priceText) else {
            displayAlert(message: NSLocalizedString("Incorrect price !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
            return
        }
        let sortValueIndex = sortPickerView.selectedRow(inComponent: 0)
        let sortValue = Article.sort[sortValueIndex]

        if let currentPurse = InMemoryStorage.shared.currentPurse {
            let article = Article(title: titleValue, sort: sortValue, author: authorValue,
                                  description: descriptionValue, purseName: currentPurse.name, isbn: isbnValue, code: seller.nextOrderNumber(), price: priceValue,
                                  sellerCode: seller.code, solded: false)
            InMemoryStorage.shared.addArticle(article)
            self.navigationController?.popViewController(animated: true)
        }

    }

}
// MARK: - PICKERVIEW
extension AddArticleViewController: UIPickerViewDelegate, UIPickerViewDataSource {

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
extension AddArticleViewController: UITextFieldDelegate {

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        resignAllTextField()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignAllTextField()
        return true
    }

    private func resignAllTextField() {
        titleTextField.resignFirstResponder()
        authorTexField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        isbnTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
    }

    @objc func keyboardWillChange(notification: NSNotification) {
        // move the view when adding text in secondTextView
        if titleTextField.isFirstResponder || authorTexField.isFirstResponder {
            return
        }
        guard let keyboardRect =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {

            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
}
// TODO:    - Ajouter la fonction pour scanner l'isbn
//          - Gerer le format du prix
