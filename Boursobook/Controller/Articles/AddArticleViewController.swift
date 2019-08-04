//
//  AddArticleViewController.swift
//  Boursobook
//
//  Created by David Dubez on 25/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class AddArticleViewController: UIViewController, SearchingBookDelegate {

    // MARK: - Properties
    var codeOfSelectedSeller: String?
    var orderNumber: Int?

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
        guard let codeOfSeller = codeOfSelectedSeller else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        for seller in InMemoryStorage.shared.sellers where seller.code == codeOfSeller {
            sellerNameLabel.text = "Seller : " + seller.firstName + " " + seller.familyName
            orderNumber = seller.orderNumber + 1
        }
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
            let codeOfSeller = codeOfSelectedSeller,
            let orderNumberValue = orderNumber
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
                                  description: descriptionValue, purseName: currentPurse.name,
                                  isbn: isbnValue, code: codeOfSeller + String(format: "%03d", orderNumberValue),
                                  price: priceValue, sellerCode: codeOfSeller, solded: false)
            InMemoryStorage.shared.addArticle(article, for: codeOfSeller)
            self.navigationController?.popViewController(animated: true)
        }

    }

    // To conform to SearchingBookDelegate Protocol
    func didFindExistingBook(info: Book.VolumeInfo, isbn: String) {
        loadValueFrom(info: info, isbn: isbn)
    }

    private func loadValueFrom(info: Book.VolumeInfo, isbn: String) {
        titleTextField.text = info.title
        var authorList = ""
        for author in info.authors {
            authorList += author
            authorList += " "
        }
        authorTexField.text = authorList
        descriptionTextView.text = info.description
        isbnTextField.text = isbn
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToScanBook" {
            if let scanBookVC: ScanBookViewController = segue.destination as? ScanBookViewController {
                scanBookVC.searchingDelegate = self
            }
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
// TODO:    - Gerer le format du prix / et celui de l'isbn
//          - probleme avec certain livre error in JSONDECODER
