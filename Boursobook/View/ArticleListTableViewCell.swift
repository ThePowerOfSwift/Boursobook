//
//  ArticleListTableViewCell.swift
//  Boursobook
//
//  Created by David Dubez on 25/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class ArticleListTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var sortLabel: UILabel!
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
        sortLabel.text = article.sort
        titleLabel.text = article.title
        codeLabel.text = article.code
        guard let price = formatDiplayedNumber(article.price) else {
                return
        }
        priceLabel.text = price + " €"
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
}
