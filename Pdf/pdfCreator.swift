//
//  pdfCreator.swift
//  BourseAPE
//
//  Created by David Dubez on 05/03/2020.
//  Copyright © 2020 David Dubez. All rights reserved.
//

import Foundation
import UIKit
import PDFKit

class PDFCreator: NSObject {

    // MARK: Set the font of the page
    let titlePageSize: CGFloat = 14
    let titlePageWeight: UIFont.Weight = .bold
    let attributeTextLabelSize: CGFloat = 11
    let attributeTextLabelWeight: UIFont.Weight = .bold
    let attributeTextValueSize: CGFloat = 11
    let attributeTextValueWeight: UIFont.Weight = .regular
    let columsTitleTextSize: CGFloat = 11
    let columsTitleTextWeight: UIFont.Weight = .bold
    let columsValueTextSize: CGFloat = 11
    let columsValueTextWeight: UIFont.Weight = .regular

    // MARK: PDF generation for seller state
        func generateStateSheet(articles: [Article], seller: Seller) -> Data {

            let pdfMetaData = [
                kCGPDFContextCreator: "état du vendeur",
                kCGPDFContextAuthor: "Bourse APE"
            ]
            let format = UIGraphicsPDFRendererFormat()
            format.documentInfo = pdfMetaData as [String: Any]

            // Set pag in A4 (72 point pr inch)
            let pageWidth = 8.3 * 72.0
            let pageHeight = 11.7 * 72.0
            let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

            let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

            let data = renderer.pdfData { (context) in

                context.beginPage()

                // General informations
                let pageTitleBottom = addPageTitle(pageRect: pageRect, text: "Fiche Récapitulative", atYPosition: 20)
                let pagePurseNameBottom = addAttributeText(pageRect: pageRect, label: "Nom de la bourse :",
                                 value: seller.purseName,
                                 atPosition: CGPoint(x: 20, y: pageTitleBottom + 20))

                let date = Date()
                let frenchFormatter = DateFormatter()
                frenchFormatter.dateStyle = .short
                frenchFormatter.timeStyle = .short
                frenchFormatter.locale = Locale(identifier: "FR-fr")
                let currentDate = frenchFormatter.string(from: date)

                let pageDateBottom = addAttributeText(pageRect: pageRect, label: "Date d'édition :", value: currentDate,
                atPosition: CGPoint(x: 20, y: pagePurseNameBottom + 15))

                let cgContext = context.cgContext
                drawSeparation(cgContext, pageRect: pageRect, separationY: pageDateBottom + 25)

                // Information about seller
                let informationsLineOneBottom  = addAttributeText(pageRect: pageRect, label: "Nom Vendeur :",
                                 value: seller.familyName,
                                 atPosition: CGPoint(x: 20, y: pageDateBottom + 35))
                _ = addAttributeText(pageRect: pageRect, label: "Prenom :",
                                 value: seller.firstName,
                                 atPosition: CGPoint(x: 250, y: pageDateBottom + 35))
                _ = addAttributeText(pageRect: pageRect, label: "Code :",
                                 value: seller.code,
                                 atPosition: CGPoint(x: 450, y: pageDateBottom + 35))
                let informationsLineTwoBottom = addAttributeText(pageRect: pageRect,
                                                                 label: "Total articles enregistrés :",
                                 value: String(seller.articleRegistered),
                                 atPosition: CGPoint(x: 20, y: informationsLineOneBottom + 15))
                _ = addAttributeText(pageRect: pageRect, label: "Montant du dépot :",
                                 value: String(seller.depositFeeAmount),
                                 atPosition: CGPoint(x: 250, y: informationsLineOneBottom + 15))
                let informationsLineTreeBottom = addAttributeText(pageRect: pageRect, label: "Email :",
                                 value: seller.email,
                                 atPosition: CGPoint(x: 20, y: informationsLineTwoBottom + 15))
                _ = addAttributeText(pageRect: pageRect, label: "Téléphone :",
                                 value: seller.phoneNumber,
                                 atPosition: CGPoint(x: 250, y: informationsLineTwoBottom + 15))
                let informationsLineFourBottom = addAttributeText(pageRect: pageRect, label: "Créé par :",
                                 value: seller.createdBy,
                                 atPosition: CGPoint(x: 20, y: informationsLineTreeBottom + 15))
                _ = addAttributeText(pageRect: pageRect, label: "ID :",
                                 value: seller.uniqueID,
                                 atPosition: CGPoint(x: 250, y: informationsLineTreeBottom + 15))

                 drawSeparation(cgContext, pageRect: pageRect, separationY: informationsLineFourBottom + 25)

                let registeredArticles: [Article] = articles.compactMap {
                    if !$0.returned && !$0.sold {
                        return $0
                    }
                    return nil
                }

                let soldedArticles: [Article] = articles.compactMap {
                    if $0.sold {
                        return $0
                    }
                    return nil
                }

                let returnedArticles: [Article] = articles.compactMap {
                    if $0.returned {
                        return $0
                    }
                    return nil
                }

                // List of article registered
                let articleRegisteredChartBottom = addMultiPageArticleChartWithTitle(
                    context: context,
                    pageRect: pageRect, articles: registeredArticles,
                    atPosition: CGPoint(x: 20, y: informationsLineFourBottom + 35),
                    title: "Nombre d'articles déposés restant à vendre :")

                drawSeparation(cgContext, pageRect: pageRect, separationY: articleRegisteredChartBottom + 25)

                // List of article solded
                let articleSoldedChartBottom = addMultiPageArticleChartWithTitle(
                context: context,
                pageRect: pageRect, articles: soldedArticles,
                atPosition: CGPoint(x: 20, y: articleRegisteredChartBottom + 35),
                title: "Nombre d'articles vendus :")

                drawSeparation(cgContext, pageRect: pageRect, separationY: articleSoldedChartBottom + 25)

                // List of article returned
                let articleReturnedChartBottom = addMultiPageArticleChartWithTitle(
                           context: context,
                           pageRect: pageRect, articles: returnedArticles,
                           atPosition: CGPoint(x: 20, y: articleSoldedChartBottom + 35),
                           title: "Nombre d'articles rendus :")

                drawSeparation(cgContext, pageRect: pageRect, separationY: articleReturnedChartBottom + 25)

                // TODO: chek the sapce
                // Information about returnation
                _ = addPageFooter(
                    context: context,
                    pageRect: pageRect, seller: seller,
                    atYPosition: articleReturnedChartBottom + 35)

            }

            return data
        }

        func addMultiPageArticleChartWithTitle(
            context: UIGraphicsPDFRendererContext, pageRect: CGRect,
            articles: [Article], atPosition: CGPoint, title: String) -> CGFloat {

            if isNotSpaceForTitleAndOneLine(pageRect: pageRect, yPosition: atPosition.y) {
                context.beginPage()
            }

            let titleBottom = addAttributeText(
                pageRect: pageRect,
                label: title,
                value: String(articles.count),
                atPosition: atPosition)

            let chartBottom = addArticleChart(
                context: context,
                pageRect: pageRect,
                articles: articles,
                atPosition: CGPoint(x: 20, y: titleBottom + 20))

            return chartBottom
        }

        func addPageFooter(context: UIGraphicsPDFRendererContext, pageRect: CGRect,
                           seller: Seller, atYPosition: CGFloat) -> CGFloat {

            var linePosition: CGFloat = atYPosition
            if isNotSpaceForFooter(pageRect: pageRect, yPosition: atYPosition) {
                               context.beginPage()
                               linePosition = 20
                           }

            _ = addAttributeText(
                pageRect: pageRect, label: "Articles rendus :",
                value: String(seller.refundDone),
                atPosition: CGPoint(x: 20, y: linePosition))
            _ = addAttributeText(
                pageRect: pageRect, label: "Date :",
                value: seller.refundDate,
                atPosition: CGPoint(x: 200, y: linePosition))
            _ = addAttributeText(
                pageRect: pageRect, label: "Par :",
                value: seller.refundBy,
                atPosition: CGPoint(x: 350, y: linePosition))
            let returnedLineOneBottom = addAttributeText(
                pageRect: pageRect, label: "Signature Vendeur :",
                value: "",
                atPosition: CGPoint(x: 20, y: linePosition + 15))
            return returnedLineOneBottom
        }

        func addPageTitle(pageRect: CGRect, text: String, atYPosition: CGFloat) -> CGFloat {
            // set font for the title
            let titleFont = UIFont.systemFont(ofSize: titlePageSize, weight: titlePageWeight)
            let titleAttributes: [NSAttributedString.Key: Any] =
                [NSAttributedString.Key.font: titleFont]
            let attributedTitle = NSAttributedString(string: text, attributes: titleAttributes)
            let titleStringSize = attributedTitle.size()
            let titleStringRect = CGRect(x: (pageRect.width - titleStringSize.width) / 2.0,
                                         y: atYPosition, width: titleStringSize.width,
                                         height: titleStringSize.height)

            // draw the title text
            attributedTitle.draw(in: titleStringRect)

            return atYPosition + titleStringSize.height
        }

        func addAttributeText(pageRect: CGRect, label: String, value: String, atPosition: CGPoint) -> CGFloat {

            // set font for the label
            let labelFont = UIFont.systemFont(ofSize: attributeTextLabelSize, weight: attributeTextLabelWeight)
            let labelAttributes: [NSAttributedString.Key: Any] =
                [NSAttributedString.Key.font: labelFont]
            let attributedLabel = NSAttributedString(string: label, attributes: labelAttributes)
            let labelStringSize = attributedLabel.size()

            // set font for the value
            let valueFont = UIFont.systemFont(ofSize: attributeTextValueSize, weight: attributeTextValueWeight)
            let valueAttributes: [NSAttributedString.Key: Any] =
                [NSAttributedString.Key.font: valueFont]
            let attributedValue = NSAttributedString(string: value, attributes: valueAttributes)
            let valueStringSize = attributedValue.size()

            // draw the label text
            let labelStringRect = CGRect(x: atPosition.x,
                                         y: atPosition.y,
                                         width: labelStringSize.width,
                                         height: labelStringSize.height)
            attributedLabel.draw(in: labelStringRect)

            // draw the label text
            let valueStringRect = CGRect(x: atPosition.x + labelStringSize.width + 5,
                                         y: atPosition.y,
                                         width: valueStringSize.width,
                                         height: valueStringSize.height)
            attributedValue.draw(in: valueStringRect)

            return atPosition.y + labelStringSize.height
        }

        func drawSeparation(_ drawContext: CGContext, pageRect: CGRect,
                            separationY: CGFloat) {

          drawContext.saveGState()
          drawContext.setLineWidth(2.0)

          drawContext.move(to: CGPoint(x: 20, y: separationY))
          drawContext.addLine(to: CGPoint(x: pageRect.width - 20, y: separationY))
          drawContext.strokePath()
          drawContext.restoreGState()

        }

    func addArticleChart(context: UIGraphicsPDFRendererContext, pageRect: CGRect,
                         articles: [Article], atPosition: CGPoint) -> CGFloat {
            // set colums titles
            let titleLineBottom = addTitleLine(atPosition: atPosition)

            // set colums values
            var lineYPosition: CGFloat = titleLineBottom + 5

            for article in articles {
                if isNotSpaceForOneLine(pageRect: pageRect, yPosition: lineYPosition) {
                    context.beginPage()
                    lineYPosition = 20
                    lineYPosition = addTitleLine(atPosition: CGPoint(x: atPosition.x, y: lineYPosition))
                }

                //let columYPosition = lineYPosition + 5 + (columNumber * 15)
                _ = addColumsValue(text: article.code, atPosition: CGPoint(x: atPosition.x, y: lineYPosition))
                _ = addColumsValue(text: article.sort, atPosition: CGPoint(x: atPosition.x + 80, y: lineYPosition))
                _ = addColumsValue(text: article.title, atPosition: CGPoint(x: atPosition.x + 150, y: lineYPosition))
                _ = addColumsValue(text: article.description,
                                   atPosition: CGPoint(x: atPosition.x + 250, y: lineYPosition))
                _ = addColumsValue(text: String(article.price),
                                   atPosition: CGPoint(x: atPosition.x + 500, y: lineYPosition))
                lineYPosition += 15
            }

            return lineYPosition
        }

    func addTitleLine(atPosition: CGPoint) -> CGFloat {
        _ = addColumsTitle(text: "Code", atPosition: atPosition)
        _ = addColumsTitle(text: "Type", atPosition: CGPoint(x: atPosition.x + 80, y: atPosition.y))
        _ = addColumsTitle(text: "Titre", atPosition: CGPoint(x: atPosition.x + 150, y: atPosition.y))
        _ = addColumsTitle(text: "Description", atPosition: CGPoint(x: atPosition.x + 250, y: atPosition.y))
        let titleLineBottom = addColumsTitle(text: "Prix", atPosition: CGPoint(x: atPosition.x + 500, y: atPosition.y))

        return titleLineBottom

    }

        func addColumsTitle(text: String, atPosition: CGPoint) -> CGFloat {
            let titleFont = UIFont.systemFont(ofSize: columsTitleTextSize, weight: columsTitleTextWeight)
            let titleAttributes: [NSAttributedString.Key: Any] =
                [NSAttributedString.Key.font: titleFont]
            let attributedTitle = NSAttributedString(string: text, attributes: titleAttributes)
            let titleStringSize = attributedTitle.size()
            let titleStringRect = CGRect(x: atPosition.x,
                                         y: atPosition.y,
                                         width: titleStringSize.width,
                                         height: titleStringSize.height)
            attributedTitle.draw(in: titleStringRect)

            return atPosition.y + titleStringSize.height
        }

        func addColumsValue(text: String, atPosition: CGPoint) -> CGFloat {
            let titleFont = UIFont.systemFont(ofSize: columsValueTextSize, weight: columsValueTextWeight)
            let titleAttributes: [NSAttributedString.Key: Any] =
                [NSAttributedString.Key.font: titleFont]
            let attributedTitle = NSAttributedString(string: text, attributes: titleAttributes)
            let titleStringSize = attributedTitle.size()
            let titleStringRect = CGRect(x: atPosition.x,
                                         y: atPosition.y,
                                         width: titleStringSize.width,
                                         height: titleStringSize.height)
            attributedTitle.draw(in: titleStringRect)

            return atPosition.y + titleStringSize.height
        }

    func isNotSpaceForTitleAndOneLine(pageRect: CGRect, yPosition: CGFloat) -> Bool {
        let titleHeight = getHeightOfFont(size: attributeTextLabelSize, weight: attributeTextLabelWeight)
        let titleColumHeight = getHeightOfFont(size: columsTitleTextSize, weight: columsTitleTextWeight)
        let valueColumHeight = getHeightOfFont(size: columsValueTextSize, weight: columsValueTextWeight)

        if (titleHeight + 20 + titleColumHeight + 20 + valueColumHeight + 10) > (pageRect.height - yPosition) {
            return true
        } else {
            return false
        }
    }

    func isNotSpaceForFooter(pageRect: CGRect, yPosition: CGFloat) -> Bool {
        let attributeHeight = getHeightOfFont(size: attributeTextLabelSize, weight: attributeTextLabelWeight)

        if ( 20 + attributeHeight + 15 + attributeHeight + 10) > (pageRect.height - yPosition) {
            return true
        } else {
            return false
        }
    }

    func isNotSpaceForOneLine(pageRect: CGRect, yPosition: CGFloat) -> Bool {

        let valueColumHeight = getHeightOfFont(size: columsValueTextSize, weight: columsValueTextWeight)
        if (15 + valueColumHeight + 10) > (pageRect.height - yPosition) {
            return true
        } else {
            return false
        }
    }

    func getHeightOfFont(size: CGFloat, weight: UIFont.Weight) -> CGFloat {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        let attributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: font]
        let attributedFont = NSAttributedString(string: "Test", attributes: attributes)
        let fontStringSize = attributedFont.size()
        return fontStringSize.height

    }
}
