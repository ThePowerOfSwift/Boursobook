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

    // MARK: - Properties
    var selectedArticle: Article?

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        loadValues()
    }

    // MARK: - functions
    private func loadValues() {
        guard let articleToLoad = selectedArticle else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        titleLabel.text = articleToLoad.title
        authorLabel.text = articleToLoad.author
        descriptionTextField.text = articleToLoad.description
        isbnLabel.text = articleToLoad.isbn
        priceLabel.text = String(articleToLoad.price) + " €"
        codeLabel.text = articleToLoad.code
    }
}
