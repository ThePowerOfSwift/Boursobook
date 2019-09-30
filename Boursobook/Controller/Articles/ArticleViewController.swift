//
//  ArticleViewController.swift
//  Boursobook
//
//  Created by David Dubez on 26/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    // MARK: - Properties
    var selectedArticleUniqueID: String?
    var isRegisterSale: Bool?
    var displayedArticle: Article?
    let articleAPI = ArticleAPI()

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!

    @IBOutlet weak var articleLabelView: UIView!
    @IBOutlet weak var qRCodeImage: UIImageView!
    @IBOutlet weak var articleLabelCodeLabel: UILabel!
    @IBOutlet weak var articleLabelPriceLabel: UILabel!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var selectButtonStackView: UIStackView!
    @IBOutlet weak var selectButton: UIButton!

    // MARK: - IBActions
    @IBAction func didTapSelectButton(_ sender: UIButton) {
        didSelectArticle(articleUniqueID: selectedArticleUniqueID)
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()
        toogleActivity(loading: true)

        guard let isRegisterSaleState = isRegisterSale else {
            return
        }
        toogleRegisterSaleView(registering: isRegisterSaleState)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadArticleToDisplay()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        articleAPI.stopListen()
    }

    deinit {
        articleAPI.stopListen()
    }

    // MARK: - functions
    private func updateValues() {
        guard let article = displayedArticle else {
            return
        }
        titleLabel.text = article.title
        authorLabel.text = article.author
        descriptionTextField.text = article.description
        isbnLabel.text = article.isbn
        priceLabel.text = formatDiplayedNumber(article.price)
        codeLabel.text = article.code
        if let qRCode = generateQrCode(from: article.uniqueID) {
            qRCodeImage.image = qRCode
        }
        articleLabelCodeLabel.text = article.code
        articleLabelPriceLabel.text = formatDiplayedNumber(article.price)

    }

    private func loadArticleToDisplay() {
           guard let uniqueID = selectedArticleUniqueID else {
               self.navigationController?.popViewController(animated: true)
               return
           }
           articleAPI.loadArticle(uniqueID: uniqueID) { (error, loadedArticle) in
               self.toogleActivity(loading: false)
               if let error = error {
                   self.displayAlert(
                       message: error.message,
                       title: NSLocalizedString(
                           "Error !", comment: ""))
               } else {
                   guard let article = loadedArticle else {
                       self.navigationController?.popViewController(animated: true)
                       return
                   }
                   self.displayedArticle = article
                   self.updateValues()
               }
           }
       }

    private func toogleRegisterSaleView(registering: Bool) {
        selectButtonStackView.isHidden = !registering
        articleLabelView.isHidden = registering
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

    private func generateQrCode(from stingToConvert: String) -> UIImage? {
        // create QRCode from the code of the article
        // Get data from the string
        let data = stingToConvert.data(using: String.Encoding.ascii)
        // Get a QR CIFilter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        // Input the data
        qrFilter.setValue(data, forKey: "inputMessage")
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return nil }
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)

    }

    private func didSelectArticle(articleUniqueID: String? ) {
        guard let articleUniqueID = articleUniqueID else {
            return
        }
        InMemoryStorage.shared.uniqueIdOfArticlesInCurrentSales.append(articleUniqueID)
        self.performSegue(withIdentifier: "undwindToBuyVC", sender: self)
    }

    private func setStyleOfVC() {
           selectButton.layer.cornerRadius = 10
           articleLabelView.layer.cornerRadius = 10
           articleLabelView.layer.borderColor = #colorLiteral(red: 0.9996456504, green: 0.3689938188, blue: 0.396720767, alpha: 1)
           articleLabelView.layer.borderWidth = 2
       }

    private func toogleActivity(loading: Bool) {
        activityIndicator.isHidden = !loading
        mainStackView.isHidden = loading
    }
}
