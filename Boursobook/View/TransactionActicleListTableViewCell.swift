//
//  TransactionActicleListTableViewCell.swift
//  Boursobook
//
//  Created by David Dubez on 18/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class TransactionActicleListTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with article: Article) {
        codeLabel.text = article.code
        titleLabel.text = article.title
        priceLabel.text = String(article.price) + " €"
    }
}
