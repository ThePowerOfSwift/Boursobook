//
//  SellerListTableViewCell.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class SellerListTableViewCell: UITableViewCell {

    // MARK: - IBOUTLET
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var registerdArticle: UILabel!
    @IBOutlet weak var soldArticleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with seller: Seller) {
        if seller.refundDone {
            codeLabel.text = NSLocalizedString("refunded", comment: "")
            familyNameLabel.text = seller.familyName
            firstNameLabel.text = seller.firstName
            registerdArticle.text = String(seller.articleRegistered)
            soldArticleLabel.text = String(seller.articlesold)

            familyNameLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            firstNameLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        } else {
            familyNameLabel.text = seller.familyName
            codeLabel.text = seller.code
            firstNameLabel.text = seller.firstName
            registerdArticle.text = String(seller.articleRegistered)
            soldArticleLabel.text = String(seller.articlesold)
        }
    }
}
