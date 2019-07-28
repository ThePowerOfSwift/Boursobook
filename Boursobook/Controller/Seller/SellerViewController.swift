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
    var codeOfSelectedSeller: String?
    var labelSheet = LabelSheet()

    // MARK: - IBOutlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var numberOfArticleSoldedLabel: UILabel!
    @IBOutlet weak var numberOfArticleRegisteredLabel: UILabel!
    @IBOutlet weak var amountDepositFeeLabel: UILabel!
    @IBOutlet weak var amountOfSalesLabel: UILabel!
    @IBOutlet weak var numerOfArticleToReturnLabel: UILabel!
    @IBOutlet weak var numberReturnedCheckedSwitch: UISwitch!

    // MARK: - IBActions
    @IBAction func didTapPrintButton(_ sender: UIButton) {
        sharePdf(on: labelSheet)
    }
    @IBAction func didTapRefundButton(_ sender: UIButton) {
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateValues),
                                               name: InMemoryStorage.sellerUpdatedNotification,
                                               object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateValues()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: InMemoryStorage.sellerUpdatedNotification,
                                                  object: nil)
    }

    // MARK: - functions
    @objc private func updateValues() {

        guard let code = codeOfSelectedSeller else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        if let displayedSeller = InMemoryStorage.shared.selectSellerWithCode(code) {

            firstNameLabel.text = displayedSeller.firstName
            familyNameLabel.text = displayedSeller.familyName
            emailLabel.text = displayedSeller.email
            phoneLabel.text = displayedSeller.phoneNumber
            codeLabel.text = displayedSeller.code
            createdByLabel.text = displayedSeller.createdBy
            numberOfArticleRegisteredLabel.text = String(displayedSeller.articleRegistered)
            amountDepositFeeLabel.text = String(displayedSeller.depositFeeAmount)
            numberOfArticleSoldedLabel.text = String(displayedSeller.articleSolded)
            amountOfSalesLabel.text = String(displayedSeller.salesAmount)
            numerOfArticleToReturnLabel.text = String(displayedSeller.articleRegistered - displayedSeller.articleSolded)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAddArticle" {
            if let addArticleVC = segue.destination as? AddArticleViewController {
                addArticleVC.codeOfSelectedSeller = codeOfSelectedSeller
            }
        }
        if segue.identifier == "segueToArticleList" {
            if let articleListVC = segue.destination as? ArticleListTableViewController {
                articleListVC.codeOfSelectedSeller = codeOfSelectedSeller
            }
        }
    }
}
// MARK: PDF and Lable generation
extension SellerViewController {
    private func sharePdf(on sheet: LabelSheet) {
        // A4 size
        let pageRect = CGRect(x: 0, y: 0, width: sheet.sheetWidthInPSP, height: sheet.sheetHeightInPSP)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        // Generate all the label
        var labels = [UIImage]()

        let articlesToDisplay = InMemoryStorage.shared.filterArticles(by: codeOfSelectedSeller)
        for article in articlesToDisplay {
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
                    return labelSheet.firstLablePositionXInPSP
                } else {
                    return Double(column) * (labelSheet.labelWidthInPSP + labelSheet.labelSpacingXInPSP)
                        + labelSheet.firstLablePositionXInPSP
                }
            }
            var positionInY: Double {
                if row == 0 {
                    return labelSheet.firstLablePositionYInPSP
                } else {
                    return Double(row) * (labelSheet.labelHeightInPSP + labelSheet.labelSpacingYInPSP)
                        + labelSheet.firstLablePositionYInPSP
                }
            }

            context.beginPage()

            for label in labels {
                label.draw(in: CGRect(x: positionInX, y: positionInY,
                                      width: labelSheet.labelWidthInPSP, height: labelSheet.labelHeightInPSP))

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
        UIGraphicsBeginImageContext(CGSize(width: labelSheet.labelWidthInPSP, height: labelSheet.labelHeightInPSP))

        // Get data from the code string
        let data = article.code.data(using: String.Encoding.ascii)
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
                                      width: labelSheet.labelHeightInPSP,
                                      height: labelSheet.labelHeightInPSP ))

        // add text + price
        let stringLabel = article.code
        let priceLabel = String(article.price) + " €"
        let textAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 50)]
        let formattedStringLabel = NSMutableAttributedString(string: stringLabel, attributes: textAttributes)
        formattedStringLabel.draw(in: CGRect(x: labelSheet.labelWidthInPSP / 2 ,
                                             y: (labelSheet.labelHeightInPSP / 4 ) * 1,
                                             width: (labelSheet.labelWidthInPSP / 2),
                                             height: labelSheet.labelHeightInPSP / 3))
        let formattedPriceLabel = NSMutableAttributedString(string: priceLabel, attributes: textAttributes)
        formattedPriceLabel.draw(in: CGRect(x: labelSheet.labelWidthInPSP / 2 ,
                                             y: (labelSheet.labelHeightInPSP / 4 ) * 3,
                                             width: (labelSheet.labelWidthInPSP / 2),
                                             height: labelSheet.labelHeightInPSP / 3))

        // draw a rectangle
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0,
                                             width: labelSheet.labelWidthInPSP,
                                             height: labelSheet.labelHeightInPSP))
        UIColor.black.setStroke()
        path.lineWidth = 10
        path.stroke()

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// TODO:    - Mettre la posibilité de modifier les informations des vendeurs
//          - Imprimer la liste des articles vendus et restants PDF
//              avec les prix de ventes / montants revenants au vendeur
//          - Calculer forfait d'insription en fonction du nombre d'article
//              ( et creer une vente fictive pour enregister transaction
//          - #### Mettre a jour le montant de desposit fee dans la purse #####
//          - Mettre les chiffres au format
//          - Traiter la partie pour la restitution des livres
//          - Améliorer la résolution des QRCODE et la position des ecritures sur les etiquettes
//          - tester generation plusieurs pages d'étiquettes
