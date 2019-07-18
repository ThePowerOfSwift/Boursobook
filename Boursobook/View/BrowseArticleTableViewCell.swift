//
//  BrowseArticleTableViewCell.swift
//  Boursobook
//
//  Created by David Dubez on 17/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class BrowseArticleTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!

    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Functions
    func configure(with article: Article) {
        titleLabel.text = article.title
        priceLabel.text = String(article.price) + " €"
        codeLabel.text = article.code
    }

}
