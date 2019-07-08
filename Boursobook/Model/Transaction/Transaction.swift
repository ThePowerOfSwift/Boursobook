//
//  Transaction.swift
//  Boursobook
//
//  Created by David Dubez on 04/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

struct Transaction {
    var date: Date
    var amount: Double
    var numberOfArticle: Int
    var articles: [Article]
}
