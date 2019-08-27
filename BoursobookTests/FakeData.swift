//
//  TestData.swift
//  BoursobookTests
//
//  Created by David Dubez on 26/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase
@testable import Boursobook

class FakeData {
    // class to create data for tests

    static let firstArticleNotSold = Article(title: "titre article",
                                        sort: "Book",
                                        author: "DURANS",
                                        description: "un livre sympa",
                                        purseName: "APE 2019",
                                        isbn: "1234567890123",
                                        code: "AAAA 0001",
                                        price: 2.4,
                                        sellerCode: "AAAA",
                                        solded: false,
                                        uniqueID: "ID Article - first fake article For test")

    static let secondArticleNotSold = Article(title: "titre second article",
                                             sort: "Other",
                                             author: "DUPOND",
                                             description: "un livre moyen",
                                             purseName: "APE 2019",
                                             isbn: "1234567890987",
                                             code: "BBBB 0003",
                                             price: 3.0,
                                             sellerCode: "BBBB",
                                             solded: false,
                                             uniqueID: "ID Second Article - fake article For test")

    static let transaction = Transaction(date: "15/01/19",
                                         uniqueID: "ID Transaction - fake transaction For test",
                                         amount: 23.4,
                                         numberOfArticle: 7,
                                         madeByUser: "michel",
                                         articles: ["livre": true],
                                         purseName: "APE 2019")

    static let depositFee = Purse.DepositFee(underFifty: 2.0,
                                             underOneHundred: 4.0,
                                             underOneHundredFifty: 6.0,
                                             underTwoHundred: 8.0,
                                             underTwoHundredFifty: 10.0,
                                             overTwoHundredFifty: 12.0)

    static let purse = Purse(name: "APE 2019",
                             numberOfArticleRegistered: 13,
                             numberOfSellers: 8,
                             numberOfArticleSolded: 8,
                             numberOfTransaction: 4,
                             percentageOnSales: 14.5,
                             depositFee: FakeData.depositFee,
                             totalSalesAmount: 12.6,
                             totalBenefitOnSalesAmount: 2.4,
                             totalDepositFeeAmount: 2.2,
                             administrators: ["me": true],
                             users: ["me": "me@me.fr"])

}
