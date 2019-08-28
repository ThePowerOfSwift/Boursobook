//
//  Article.swift
//  Boursobook
//
//  Created by David Dubez on 25/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class Article: RemoteDataBaseModel {

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
    var sold: Bool
    var uniqueID: String

    static let sort = ["Book", "Comic", "Novel", "Guide", "Game", "Compact Disk", "DVD", "Video Game", "Other"]

 // MARK: - Initialisation
    init(title: String, sort: String, author: String, description: String,
         purseName: String, isbn: String, code: String,
         price: Double, sellerCode: String, sold: Bool,
         uniqueID: String) {
        self.title = title
        self.sort = sort
        self.author = author
        self.description = description
        self.purseName = purseName
        self.isbn = isbn
        self.code = code
        self.price = price
        self.sellerCode = sellerCode
        self.sold = sold
        self.uniqueID = uniqueID
    }

    required init?(snapshot: DataSnapshot) {
        guard
            let snapshotValue = snapshot.value as? [String: AnyObject],
                let titleValue = snapshotValue["title"] as? String,
                let codeValue = snapshotValue["code"] as? String,
                let sortValue = snapshotValue["sort"] as? String,
                let authorValue = snapshotValue["author"] as? String,
                let descriptionValue = snapshotValue["description"] as? String,
                let purseNameValue = snapshotValue["purseName"] as? String,
                let isbnValue = snapshotValue["isbn"] as? String,
                let priceValue = snapshotValue["price"] as? Double,
                let soldValue = snapshotValue["sold"] as? Bool,
                let uniqueIDValue = snapshotValue["uniqueID"] as? String,
                let sellerCodeValue = snapshotValue["sellerCode"] as? String else {
            return nil
        }

        title = titleValue
        code = codeValue
        sort = sortValue
        author = authorValue
        description = descriptionValue
        purseName = purseNameValue
        isbn = isbnValue
        price = priceValue
        sold = soldValue
        sellerCode = sellerCodeValue
        uniqueID = uniqueIDValue
    }

    func setValuesForRemoteDataBase() -> [String: Any] {
        let values: [String: Any] = ["title": title,
                                     "code": code,
                                     "sort": sort,
                                     "author": author,
                                     "description": description,
                                     "purseName": purseName,
                                     "isbn": isbn,
                                     "price": price,
                                     "sold": sold,
                                     "uniqueID": uniqueID,
                                     "sellerCode": sellerCode]
        return values
    }
}
