//
//  Article.swift
//  Boursobook
//
//  Created by David Dubez on 25/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

struct Article {
    var title: String
    var sort: Article.Sort = .other
    var author: String
    var description: String
    var isbn: String
    var code: String {
        return "ddd"
    }
    var qrCode: String  {
        return "ddd"
    }
    var price: Double
    var seller: Seller
    var solded: Bool

    enum Sort: String, CaseIterable {
        case book = "book"
        case comic = "comic"
        case novel = "novel"
        case guide = "guide"
        case game = "game"
        case compactDisk = "compactDisk"
        case dvd = "dvd"
        case videoGame = "videoGame"
        case other = "other"
    }
}
// TODO:         - gerer la generaltion du code
//         - generer le qrcode
//          - tests à faire
