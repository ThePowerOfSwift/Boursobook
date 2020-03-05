//
//  PdfSalePreviewVC.swift
//  BourseAPE
//
//  Created by David Dubez on 05/03/2020.
//  Copyright © 2020 David Dubez. All rights reserved.
//

import Foundation

import UIKit
import PDFKit

class PdfSalePreviewVC: UIViewController {

    // MARK: - Properties
    let saleAPI = SaleAPI()
    let articleAPI = ArticleAPI()
    var displayedSale: Sale?
    var acticlesOfSale = [Article]()
    var documentData: Data?

    public var saleId: String?

    // MARK: - IBOutlets
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var activityIncicator: UIActivityIndicatorView!

    // MARK: - IBActions

    @IBAction func sharePreview(_ sender: Any) {
         shareAction()
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        toogleLoadingView(searching: true)
        loadData()
    }

    // MARK: - Functions

    private func loadPdfPreview() {

        guard let sale = displayedSale else {
                return
        }

        let pdfCreator = PDFCreator()
        documentData = pdfCreator.generateSaleSheet(sale: sale, articles: acticlesOfSale)

        if let data = documentData {
            pdfView.document = PDFDocument(data: data)
            pdfView.autoScales = true
        }
    }

    private func loadData() {

        guard let uniqueID = saleId else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        saleAPI.getSale(uniqueID: uniqueID) { (error, loadedSale) in
            if let error = error {
                self.displayAlert(
                    message: error.message,
                    title: NSLocalizedString(
                        "Error !", comment: ""))
            } else {
                guard let sale = loadedSale else {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                self.displayedSale = sale
                self.getArticles()
            }
        }
    }

    private func getArticles() {

        guard let sale = displayedSale else {
            return
        }
        let dispatchGroup = DispatchGroup()

        sale.inArticlesCode.forEach { articleCode in
            dispatchGroup.enter()
            articleAPI.getArticle(code: articleCode,
                                  purse: InMemoryStorage.shared.inWorkingPurse) { (error, loadedArticle) in
                                    if let error = error {
                                        self.displayAlert(
                                            message: error.message,
                                            title: NSLocalizedString(
                                                "Error !", comment: ""))
                                    } else {
                                        guard let article = loadedArticle else {
                                            return
                                        }
                                        self.acticlesOfSale.append(article)
                                        dispatchGroup.leave()
                                    }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.toogleLoadingView(searching: false)
            self.displayMessage()
            self.loadPdfPreview()
        }
    }

    private func displayMessage() {
        self.displayAlert(message: NSLocalizedString("The sale was saved", comment: ""),
                          title: NSLocalizedString("Done !", comment: ""))
    }

    private func shareAction() {
        if let data = documentData {
            let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            }
            present(activityController, animated: true, completion: nil)
        }
    }

    func toogleLoadingView(searching: Bool) {
        pdfView.isHidden = searching
        activityIncicator.isHidden = !searching
    }

}
