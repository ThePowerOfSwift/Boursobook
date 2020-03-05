//
//  SellerViewController+pdfRender.swift
//  BourseAPE
//
//  Created by David Dubez on 01/03/2020.
//  Copyright © 2020 David Dubez. All rights reserved.
//

import Foundation
import PDFKit

extension SellerViewController {

    // MARK: PDF generation for label sheet
    func generateLablesSheet(articles: [Article], sheet: LabelSheet) -> Data {

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
        return data
    }

    private func generateLabel(from article: Article, on sheet: LabelSheet) -> UIImage? {
        // create label with the QRCode from the article
        let labelWidthResolution = 300
        let labelRatio = sheet.labelWidthInMM / sheet.labelHeightInMM
        let labelheight = Int((Double(labelWidthResolution) / labelRatio).rounded())
        let labelSize = CGSize(width: labelWidthResolution, height: labelheight )
        UIGraphicsBeginImageContext(labelSize)

        guard let QRcodeUIImage = generateQRCode(from: article.code) else {
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
        path.lineWidth = 2
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
