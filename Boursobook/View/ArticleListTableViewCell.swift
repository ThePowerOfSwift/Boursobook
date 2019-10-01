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
    @IBOutlet weak var soldLabel: UILabel!

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
        if article.sold == true {
            soldLabel.text = NSLocalizedString("sold", comment: "")
            soldLabel.textColor = #colorLiteral(red: 0.3313049078, green: 0.7027626634, blue: 0.8799206614, alpha: 1)
        } else if article.returned == true {
            soldLabel.text = NSLocalizedString("returned", comment: "")
            soldLabel.textColor = #colorLiteral(red: 0.9996456504, green: 0.3689938188, blue: 0.396720767, alpha: 1)
        } else {
            soldLabel.text = NSLocalizedString("avail.", comment: "")
            soldLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
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
