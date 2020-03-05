//
//  PdfPreviewVC.swift
//  BourseAPE
//
//  Created by David Dubez on 02/03/2020.
//  Copyright © 2020 David Dubez. All rights reserved.
//

import UIKit
import PDFKit

class PdfPreviewVC: UIViewController {

    // MARK: - Properties
    public var documentData: Data?

    // MARK: - IBOutlets
    @IBOutlet weak var pdfView: PDFView!

    @IBAction func sharePreview(_ sender: Any) {
        shareAction()
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = documentData {
            pdfView.document = PDFDocument(data: data)
            pdfView.autoScales = true
        }
    }

    // MARK: - Functions
    private func shareAction() {
        if let data = documentData {
            let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            }
            present(activityController, animated: true, completion: nil)
        }
    }

}
