//
//  Article.swift
//  Boursobook
//
//  Created by David Dubez on 25/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class Article {

    // MARK: - Properties
    var title: String
    var sort: String
    var author: String
    var description: String
    var purseName: String
    var isbn: String
    var code: String
    var price: Double
    var sellerCode: String
    var solded: Bool

    static let sort = ["Book", "Comic", "Novel", "Guide", "Game", "Compact Disk", "DVD", "Video Game", "Other"]

 // MARK: - Initialisation
    init(title: String, sort: String, author: String, description: String,
         purseName: String, isbn: String, code: String, price: Double, sellerCode: String, solded: Bool) {
        self.title = title
        self.sort = sort
        self.author = author
        self.description = description
        self.purseName = purseName
        self.isbn = isbn
        self.code = code
        self.price = price
        self.sellerCode = sellerCode
        self.solded = solded
    }

    init?(snapshot: DataSnapshot) {
        code = snapshot.key
        guard
            let snapshotValue = snapshot.value as? [String: AnyObject],
                let titleValue = snapshotValue["title"] as? String,
                let sortValue = snapshotValue["sort"] as? String,
                let authorValue = snapshotValue["author"] as? String,
                let descriptionValue = snapshotValue["description"] as? String,
                let purseNameValue = snapshotValue["purseName"] as? String,
                let isbnValue = snapshotValue["isbn"] as? String,
                let priceValue = snapshotValue["price"] as? Double,
                let soldedValue = snapshotValue["solded"] as? Bool,
                let sellerCodeValue = snapshotValue["sellerCode"] as? String else {
            return nil
        }

        title = titleValue
        sort = sortValue
        author = authorValue
        description = descriptionValue
        purseName = purseNameValue
        isbn = isbnValue
        price = priceValue
        solded = soldedValue
        sellerCode = sellerCodeValue

    }
}

// TODO:         - gerer la generaltion du code
//         - generer le qrcode
//          - tests à faire
