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
                                        sellerUniqueId: "AAAA 44FGDRGERT",
                                        sold: false,
                                        returned: false,
                                        uniqueID: "ID Article - first fake article For test")

    static let secondArticleNotSold = Article(title: "titre second article",
                                             sort: "Other",
                                             author: "DUPOND",
                                             description: "un livre moyen",
                                             purseName: "APE 2019",
                                             isbn: "1234567890987",
                                             code: "BBBB 0003",
                                             price: 3.0,
                                             sellerUniqueId: "BBBB RDD832UF G",
                                             sold: false,
                                             returned: false,
                                             uniqueID: "ID Second Article - fake article For test")

    static let articleSold = Article(title: "titre article",
                        sort: "Book",
                        author: "DURANS",
                        description: "un livre sympa",
                        purseName: "APE 2019",
                        isbn: "1234567890123",
                        code: "AAAA 0001",
                        price: 2.4,
                        sellerUniqueId: "AAAA 44FGDRGERT",
                        sold: true,
                        returned: false,
                        uniqueID: "ID Article - first fake article For test")

    static let articleReturned = Article(title: "titre article",
                        sort: "Book",
                        author: "DURANS",
                        description: "un livre sympa",
                        purseName: "APE 2019",
                        isbn: "1234567890123",
                        code: "AAAA 0001",
                        price: 2.4,
                        sellerUniqueId: "AAAA 44FGDRGERT",
                        sold: false,
                        returned: true,
                        uniqueID: "ID Article - first fake article For test")

    static let sale = Sale(date: "15/01/19",
                                         uniqueID: "ID Sale - fake sale For test",
                                         amount: 23.4,
                                         numberOfArticle: 7,
                                         madeByUser: "michel",
                                         inArticlesCode: ["livre"],
                                         purseName: "APE 2019")

    static let depositFee = Purse.DepositFee(underFifty: 2.0,
                                             underOneHundred: 4.0,
                                             underOneHundredFifty: 6.0,
                                             underTwoHundred: 8.0,
                                             underTwoHundredFifty: 10.0,
                                             overTwoHundredFifty: 12.0)

    static let purse = Purse(name: "APE 2019",
                             uniqueID: "APE 2019 UNIQUEID",
                             numberOfArticleRegistered: 13,
                             numberOfSellers: 8,
                             numberOfArticlesold: 8,
                             numberOfArticleReturned: 2,
                             numberOfSales: 4,
                             percentageOnSales: 14.5,
                             depositFee: FakeData.depositFee,
                             totalSalesAmount: 12.6,
                             totalBenefitOnSalesAmount: 2.4,
                             totalDepositFeeAmount: 2.2,
                             administrators: ["me": true],
                             users: ["me@me.fr"])

    static let purseForUnitTests = Purse(name: "Purse For Unit Testing",
                                            uniqueID: "Purse For Unit Testing",
                                            numberOfArticleRegistered: 13,
                                            numberOfSellers: 8,
                                            numberOfArticlesold: 8,
                                            numberOfArticleReturned: 2,
                                            numberOfSales: 4,
                                            percentageOnSales: 14.5,
                                            depositFee: FakeData.depositFee,
                                            totalSalesAmount: 12.6,
                                            totalBenefitOnSalesAmount: 2.4,
                                            totalDepositFeeAmount: 2.2,
                                            administrators: ["ddubez@free.fr": true],
                                            users: ["me@me.fr"])

    static let seller = Seller(familyName: "Dupond",
                               firstName: "Gerad",
                               email: "g.dupond@free.fr",
                               phoneNumber: "0123456789",
                               code: "DUPG", createdBy: "michel@me.com",
                               purseName: "APE 2019", uniqueID: "diuzhdbfp djdjdj",
                               refundDate: "14/05/18", refundBy: "jeannine@aol.fr")

    static let user = User(email: "me@me.fr", uniqueID: "uid of user me")

    // MARK: - Error
    class FakeError: Error {}
    static let error = FakeError()

}
