//
//  ArticleViewController.swift
//  Boursobook
//
//  Created by David Dubez on 26/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

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

    // MARK: - Properties
    var codeOfSelectedArticle: String?

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        updateValues()
        NotificationCenter.default.addObserver(self, selector: #selector(updateValues),
                                               name: InMemoryStorage.articleUpdatedNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: InMemoryStorage.articleUpdatedNotification,
                                                  object: nil)
    }

    // MARK: - functions
    @objc private func updateValues() {
        if let codeOfSelectedArticle = codeOfSelectedArticle {
            guard let articleToLoad = InMemoryStorage.shared.selectArticle(by: codeOfSelectedArticle) else {return}
            titleLabel.text = articleToLoad.title
            authorLabel.text = articleToLoad.author
            descriptionTextField.text = articleToLoad.description
            isbnLabel.text = articleToLoad.isbn
            priceLabel.text = String(articleToLoad.price) + " €"
            codeLabel.text = articleToLoad.code
            if let qRCode = generateQrCode(from: articleToLoad.code) {
                qRCodeImage.image = qRCode
            }
            articleLabelCodeLabel.text = articleToLoad.code
            articleLabelPriceLabel.text = String(articleToLoad.price) + " €"
        } else {
            self.navigationController?.popViewController(animated: true)
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
}

// TODO:    - arrondir les angles de l'étiquette
