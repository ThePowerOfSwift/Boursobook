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
    var activeTextField: UITextField?
    var selectedSeller: Seller?
    var articleAPI = ArticleAPI()
    var purseAPI = PurseAPI()

    // MARK: - IBOUTLET
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var sortPickerView: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTexField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var isbnTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scanABookButton: UIButton!
    @IBOutlet weak var ActivityIndicatorStack: UIStackView!

    // MARK: - IBACTION
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        resignAllTextField()
        saveArticle()
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()

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
    private func saveArticle() {
        guard let titleValue = titleTextField.text,
            let authorValue = authorTexField.text,
            let descriptionValue = descriptionTextView.text,
            let isbnValue = isbnTextField.text,
            let priceText = priceTextField.text
        else {
                return
        }
        if titleValue == "" || priceText == "" {
            displayAlert(message: NSLocalizedString("Please, fill the name and the price !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
            return
        }
        guard let priceValue = valueForTextField(priceTextField) else {
            displayAlert(message: NSLocalizedString("Incorrect price !", comment: ""),
                         title: NSLocalizedString("Error !", comment: ""))
            return
        }
        toogleActivity(loading: true)
        let sortValueIndex = sortPickerView.selectedRow(inComponent: 0)
        let sortValue = Article.sort[sortValueIndex]

        let newArticle = Article(title: titleValue, sort: sortValue,
                                 author: authorValue, description: descriptionValue,
                                 isbn: isbnValue, price: priceValue)
        articleAPI.createArticle(purse: InMemoryStorage.shared.inWorkingPurse,
                                 seller: selectedSeller,
                                 article: newArticle) { (error) in
                                    self.toogleActivity(loading: false)
                                    if let error = error {
                                        self.displayAlert(
                                            message: error.message,
                                            title: NSLocalizedString(
                                                "Error !", comment: ""))
                                    } else {
                                        self.navigationController?.popViewController(animated: true)
                                    }
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

    private func setStyleOfVC() {
        saveButton.layer.cornerRadius = 10
        scanABookButton.layer.cornerRadius = 10
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        descriptionTextView.layer.borderWidth = 1
    }

    func toogleActivity(loading: Bool) {
        ActivityIndicatorStack.isHidden = !loading
        scanABookButton.isHidden = loading
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
        titleTextField.resignFirstResponder()
        authorTexField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        isbnTextField.resignFirstResponder()
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
