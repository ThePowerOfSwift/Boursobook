//
//  UserListTableViewCell.swift
//  Boursobook
//
//  Created by David Dubez on 09/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var userEmailLabel: UILabel!

    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Functions
    func configure(with user: User) {
        userEmailLabel.text = user.email
    }
}
