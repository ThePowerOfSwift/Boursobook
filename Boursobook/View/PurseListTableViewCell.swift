//
//  PurseListTableViewCell.swift
//  Boursobook
//
//  Created by David Dubez on 31/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class PurseListTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var purseNameLabel: UILabel!

    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Functions
    func configure(with purse: Purse) {
        purseNameLabel.text = purse.name
    }

}
