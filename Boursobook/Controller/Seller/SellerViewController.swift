//
//  SellerViewController.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SellerViewController: UIViewController {

    // MARK: - Properties
    var uniqueIdOfSelectedSeller: String?
    var labelSheet = LabelSheet()
    let sellerAPI = SellerAPI()
    var displayedSeller: Seller?
    let articleAPI = ArticleAPI()

    // MARK: - IBOutlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var numberOfArticlesoldLabel: UILabel!
    @IBOutlet weak var numberOfArticleRegisteredLabel: UILabel!
    @IBOutlet weak var amountDepositFeeLabel: UILabel!
    @IBOutlet weak var amountOfSalesLabel: UILabel!
    @IBOutlet weak var numerOfArticleToReturnLabel: UILabel!
    @IBOutlet weak var numberReturnedCheckedSwitch: UISwitch!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var listOfArticleButton: UIButton!
    @IBOutlet weak var printLablesButton: UIButton!
    @IBOutlet weak var refundButton: UIButton!

    // MARK: - IBActions
    @IBAction func didTapPrintButton(_ sender: UIButton) {
        shareLabelsSheetPdf(on: labelSheet)
    }
    @IBAction func didTapRefundButton(_ sender: UIButton) {
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()
        toogleActivity(loading: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSellerToDisplay()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sellerAPI.stopListen()
    }

    deinit {
        sellerAPI.stopListen()
    }

    // MARK: - functions
    private func updateValues() {

        guard let seller = displayedSeller else {
            return
        }
        firstNameLabel.text = seller.firstName
        familyNameLabel.text = seller.familyName
        emailLabel.text = seller.email
        phoneLabel.text = seller.phoneNumber
        codeLabel.text = seller.code
        createdByLabel.text = seller.createdBy
        numberOfArticleRegisteredLabel.text = String(seller.articleRegistered)
        amountDepositFeeLabel.text = formatDiplayedNumber(seller.depositFeeAmount)
        numberOfArticlesoldLabel.text = String(seller.articlesold)
        amountOfSalesLabel.text = formatDiplayedNumber(seller.salesAmount)
        numerOfArticleToReturnLabel.text = String(seller.articleRegistered - seller.articlesold)
    }

    private func loadSellerToDisplay() {
        guard let uniqueID = uniqueIdOfSelectedSeller else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        sellerAPI.loadSeller(uniqueID: uniqueID) { (error, loadedSeller) in
            self.toogleActivity(loading: false)
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
            } else {
                guard let seller = loadedSeller else {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                self.displayedSeller = seller
                self.updateValues()
            }
        }
    }

    private func setStyleOfVC() {
        listOfArticleButton.layer.cornerRadius = 10
        printLablesButton.layer.cornerRadius = 10
        refundButton.layer.cornerRadius = 10
    }

    private func toogleActivity(loading: Bool) {
        activityIndicator.isHidden = !loading
        mainStackView.isHidden = loading
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAddArticle" {
            if let addArticleVC = segue.destination as? AddArticleViewController {
                addArticleVC.selectedSeller = displayedSeller
            }
        }
        if segue.identifier == "segueToArticleList" {
            if let articleListVC = segue.destination as? ArticleListTableViewController {
                articleListVC.selectedSeller = displayedSeller
            }
        }
    }
}
// MARK: PDF and Label generation
extension SellerViewController {
    private func shareLabelsSheetPdf(on sheet: LabelSheet) {
        toogleActivity(loading: true)

        // Get all articles for the seller
        guard let seller = displayedSeller else {
            return
        }
        articleAPI.getArticlesFor(seller: seller) { (error, sellerArticles) in
            self.toogleActivity(loading: false)
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
            } else {
                guard let articles = sellerArticles else {
                    return
                }
                self.generateLablesSheet(articles: articles, sheet: sheet)
            }
        }
    }

    private func generateLablesSheet(articles: [Article], sheet: LabelSheet) {

        // A4 size
        let pageRect = CGRect(x: 0, y: 0, width: sheet.sheetWidthInMM, height: sheet.sheetHeightInMM)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        // Generate all the label
        var labels = [UIImage]()

        for article in articles {
            if let imageToAdd = generateLabel(from: article) {
                labels.append(imageToAdd)
            }
        }

        // Create pdf with labels creating with disposition of labelSheet
        let data = renderer.pdfData { (context) in
            var page = 0
            var row = 0
            var column = 0
            var positionInX: Double {
                if column == 0 {
                    return labelSheet.firstLablePositionXInMM
                } else {
                    return Double(column) * (labelSheet.labelWidthInMM + labelSheet.labelSpacingXInMM)
                        + labelSheet.firstLablePositionXInMM
                }
            }
            var positionInY: Double {
                if row == 0 {
                    return labelSheet.firstLablePositionYInMM
                } else {
                    return Double(row) * (labelSheet.labelHeightInMM + labelSheet.labelSpacingYInMM)
                        + labelSheet.firstLablePositionYInMM
                }
            }

            context.beginPage()

            for label in labels {
                label.draw(in: CGRect(x: positionInX, y: positionInY,
                                      width: labelSheet.labelWidthInMM, height: labelSheet.labelHeightInMM))

                column += 1
                if column > labelSheet.getNumberOfColumns() && row <= labelSheet.getNumberOfRows() {
                    row += 1
                    column = 0
                } else if column > labelSheet.getNumberOfColumns() && row > labelSheet.getNumberOfRows() {
                    page += 1
                    row = 0
                    column = 0
                    context.beginPage()
                }
            }
        }
        let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in

        }
        present(activityController, animated: true, completion: nil)
    }

    private func generateLabel(from article: Article) -> UIImage? {
        // create label with the QRCode from the article
        UIGraphicsBeginImageContext(CGSize(width: labelSheet.labelWidthInMM, height: labelSheet.labelHeightInMM))

        // Get data from the uniqueID string
        let data = article.uniqueID.data(using: String.Encoding.ascii)
        // Get a QR CIFilter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        // Input the data
        qrFilter.setValue(data, forKey: "inputMessage")
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return nil }
        // get the UIImage

        let QRcodeUIImage = UIImage(ciImage: qrImage, scale: 1, orientation: .up)

        // Draw QRCode
        QRcodeUIImage.draw(in: CGRect(x: 0, y: 0,
                                      width: labelSheet.labelHeightInMM,
                                      height: labelSheet.labelHeightInMM ))

        // add text + price
        guard let stringPrice = formatDiplayedNumber(article.price) else {
            return nil
        }
        let stringLabel = article.code
        let priceLabel = stringPrice + " €"
        let textAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 50)]
        let formattedStringLabel = NSMutableAttributedString(string: stringLabel, attributes: textAttributes)
        formattedStringLabel.draw(in: CGRect(x: labelSheet.labelWidthInMM / 2 ,
                                             y: (labelSheet.labelHeightInMM / 4 ) * 1,
                                             width: (labelSheet.labelWidthInMM / 2),
                                             height: labelSheet.labelHeightInMM / 3))
        let formattedPriceLabel = NSMutableAttributedString(string: priceLabel, attributes: textAttributes)
        formattedPriceLabel.draw(in: CGRect(x: labelSheet.labelWidthInMM / 2 ,
                                             y: (labelSheet.labelHeightInMM / 4 ) * 3,
                                             width: (labelSheet.labelWidthInMM / 2),
                                             height: labelSheet.labelHeightInMM / 3))

        // draw a rectangle
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0,
                                             width: labelSheet.labelWidthInMM,
                                             height: labelSheet.labelHeightInMM))
        UIColor.black.setStroke()
        path.lineWidth = 10
        path.stroke()

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
