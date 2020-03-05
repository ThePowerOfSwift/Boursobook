//
//  pdfCreator+saleView.swift
//  BourseAPE
//
//  Created by David Dubez on 05/03/2020.
//  Copyright © 2020 David Dubez. All rights reserved.
//

import Foundation
import UIKit
import PDFKit

extension PDFCreator {
    func generateSaleSheet(sale: Sale, articles: [Article]) -> Data {

        let pdfMetaData = [
            kCGPDFContextCreator: "Vente",
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
            let pageTitleBottom = addPageTitle(pageRect: pageRect, text: "Fiche Vente", atYPosition: 20)
            let pagePurseNameBottom = addAttributeText(pageRect: pageRect, label: "Nom de la bourse :",
                             value: sale.purseName,
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

            // Information about sale
            let informationsLineOneBottom  = addAttributeText(pageRect: pageRect, label: "Nombre d'article :",
                                                              value: String(sale.numberOfArticle),
                                                              atPosition: CGPoint(x: 20, y: pageDateBottom + 35))
            _ = addAttributeText(pageRect: pageRect, label: "Montant :",
                                 value: String(sale.amount),
                                 atPosition: CGPoint(x: 250, y: pageDateBottom + 35))
            _ = addAttributeText(pageRect: pageRect, label: "Effectuée par :",
                                 value: sale.madeByUser,
                                 atPosition: CGPoint(x: 350, y: pageDateBottom + 35))
            let informationsLineTwoBottom = addAttributeText(
                pageRect: pageRect,
                label: "ID Vente :",
                value: String(sale.uniqueID),
                atPosition: CGPoint(x: 20, y: informationsLineOneBottom + 15))

            drawSeparation(cgContext, pageRect: pageRect, separationY: informationsLineTwoBottom + 25)

            // List of article sold
            let articleSoldedChartBottom = addMultiPageArticleChartWithTitle(
                context: context,
                pageRect: pageRect, articles: articles,
                atPosition: CGPoint(x: 20, y: informationsLineTwoBottom + 35),
                title: "Liste des articles :")

            drawSeparation(cgContext, pageRect: pageRect, separationY: articleSoldedChartBottom + 25)

            // Visa
            _ = addAttributeText(
            pageRect: pageRect, label: "Signature Acheteur :",
            value: "",
            atPosition: CGPoint(x: 20, y: articleSoldedChartBottom + 40))

        }

        return data
    }
}
