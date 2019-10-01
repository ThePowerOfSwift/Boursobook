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
    @IBOutlet weak var dateOfRefundLabel: UILabel!

    @IBOutlet weak var listOfArticleButton: UIButton!
    @IBOutlet weak var printLablesButton: UIButton!
    @IBOutlet weak var refundButton: UIButton!
    @IBOutlet weak var addArticleButton: UIBarButtonItem!
    @IBOutlet weak var numberCheckedStack: UIStackView!
    @IBOutlet weak var refundButtonStack: UIStackView!
    @IBOutlet weak var numberArticleToReturnStack: UIStackView!
    @IBOutlet weak var dateOfRefundStack: UIStackView!

    // MARK: - IBActions
    @IBAction func didTapPrintButton(_ sender: UIButton) {
        let labelSheet = LabelSheet()
        shareLabelsSheetPdf(on: labelSheet)
    }
    @IBAction func didTapRefundButton(_ sender: UIButton) {
        refundArticles()
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()
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
        if seller.refundDone {
            setDisplayToSeller(refunded: true)
        } else {
            setDisplayToSeller(refunded: false)
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
        dateOfRefundLabel.text = seller.refundDate
    }

    private func loadSellerToDisplay() {
        guard let uniqueID = uniqueIdOfSelectedSeller else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        toogleActivity(loading: true)
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

    private func setDisplayToSeller(refunded: Bool) {
        addArticleButton.isEnabled = !refunded
        printLablesButton.isHidden = refunded
        numberCheckedStack.isHidden = refunded
        refundButtonStack.isHidden = refunded
        numberArticleToReturnStack.isHidden = refunded
        dateOfRefundStack.isHidden = !refunded
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

    private func refundArticles() {
        toogleActivity(loading: true)
        if numberReturnedCheckedSwitch.isOn {
            //Get articles of seller no solded
            guard let seller = displayedSeller else { return }

            articleAPI.getArticlesFor(seller: seller) { (error, sellerArticles) in
                self.toogleActivity(loading: false)
                if let error = error {
                    self.displayAlert(message: error.message, title: NSLocalizedString("Error !", comment: ""))
                } else {
                    guard let articles = sellerArticles else { return }
                    let noSoldArticles: [Article] = articles.compactMap {
                        if !$0.sold && !$0.returned { return $0 }
                        return nil
                    }
                    var numberOfArticlesInError = 0
                    //for earch article no solded, update data in remote database
                    let updatingArticlesGroup = DispatchGroup()
                            noSoldArticles.forEach { (article) in
                                updatingArticlesGroup.enter()
                                self.sellerAPI
                                    .updateDataForArticleReturned(article: article, seller: seller,
                                                                  purse: InMemoryStorage.shared.inWorkingPurse,
                                                                  user: InMemoryStorage.shared.userLogIn) {(error) in
                                        if error != nil {
                                            numberOfArticlesInError += 1
                                        }
                                        updatingArticlesGroup.leave()
                                }
                            }
                            updatingArticlesGroup.notify(queue: .main) {
                                self.toogleActivity(loading: false)
                                if numberOfArticlesInError == 0 {
                                    self.displayAlert(message: NSLocalizedString("The seller was refunded",
                                                                                 comment: ""),
                                                      title: NSLocalizedString("Done !", comment: ""))
                                    self.setDisplayToSeller(refunded: true)

                                } else {
                                    self.displayAlert(
                                        message: NSLocalizedString("The seller was refunded, but some article failed !",
                                                                   comment: ""),
                                        title: NSLocalizedString("Done !", comment: ""))
                                    self.setDisplayToSeller(refunded: true)
                                }
                            }
                        }
                    }
        } else {
            toogleActivity(loading: false)
            self.displayAlert(message: NSLocalizedString("Please check the number !", comment: ""),
                              title: NSLocalizedString("Warning", comment: ""))
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
            if let imageToAdd = generateLabel(from: article, on: sheet) {
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
                    return sheet.firstLablePositionXInMM
                } else {
                    return Double(column) * (sheet.labelWidthInMM + sheet.labelSpacingXInMM)
                        + sheet.firstLablePositionXInMM
                }
            }
            var positionInY: Double {
                if row == 0 {
                    return sheet.firstLablePositionYInMM
                } else {
                    return Double(row) * (sheet.labelHeightInMM + sheet.labelSpacingYInMM)
                        + sheet.firstLablePositionYInMM
                }
            }

            context.beginPage()

            for label in labels {
                label.draw(in: CGRect(x: positionInX, y: positionInY,
                                      width: sheet.labelWidthInMM, height: sheet.labelHeightInMM))

                column += 1
                if column > sheet.getNumberOfColumns() && row <= sheet.getNumberOfRows() {
                    row += 1
                    column = 0
                } else if column > sheet.getNumberOfColumns() && row > sheet.getNumberOfRows() {
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

    private func generateLabel(from article: Article, on sheet: LabelSheet) -> UIImage? {
        // create label with the QRCode from the article
        let labelWidthResolution = 300
        let labelRatio = sheet.labelWidthInMM / sheet.labelHeightInMM
        let labelheight = Int((Double(labelWidthResolution) / labelRatio).rounded())
        let labelSize = CGSize(width: labelWidthResolution, height: labelheight )
        UIGraphicsBeginImageContext(labelSize)

        guard let QRcodeUIImage = generateQRCode(from: article.uniqueID) else {
            return nil
        }
        // Draw QRCode
        QRcodeUIImage.draw(in: CGRect(x: 0, y: 0,
                                      width: labelSize.height,
                                      height: labelSize.height ))

        // add text + price
        guard let stringPrice = formatDiplayedNumber(article.price) else {
            return nil
        }
        let stringLabel = article.code
        let priceLabel = stringPrice + " €"
        let titleLabel = article.title

        stringLabel.draw(in: CGRect(x: labelSize.width / 2 ,
                                             y: (labelSize.height / 4 ) * 1,
                                             width: (labelSize.width / 2),
                                             height: labelSize.height / 3))
        titleLabel.draw(in: CGRect(x: labelSize.width / 2 ,
                                   y: (labelSize.height / 4 ) * 2,
                                   width: (labelSize.width / 2),
                                   height: labelSize.height / 3))

        priceLabel.draw(in: CGRect(x: labelSize.width / 2 ,
                                             y: (labelSize.height / 4 ) * 3,
                                             width: (labelSize.width / 2),
                                             height: labelSize.height / 3))

        // draw a rectangle
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0,
                                             width: labelSize.width,
                                             height: labelSize.height))
        UIColor.black.setStroke()
        path.lineWidth = 10
        path.stroke()

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }

}
