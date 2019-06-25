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
    @IBOutlet weak var itemToSoldLabel: UILabel!
    @IBOutlet weak var soldedItemLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with seller: Seller) {
        familyNameLabel.text = seller.familyName
        codeLabel.text = seller.code
        firstNameLabel.text = seller.firstName
        itemToSoldLabel.text = String(seller.itemsToSold)
        soldedItemLabel.text = String(seller.soldedItem)
    }
}
