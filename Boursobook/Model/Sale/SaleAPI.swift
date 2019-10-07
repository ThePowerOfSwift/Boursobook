//
//  SaleAPI.swift
//  Boursobook
//
//  Created by David Dubez on 23/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class SaleAPI {
    // Manage the acces of "sale" data

    // MARK: Properties
    private var saleRemoteDataBaseRequest: RemoteDatabaseRequest
        = FireBaseDataRequest(collection: Sale.collection)

    // MARK: Initialisation
    init() {}
    init(saleRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.saleRemoteDataBaseRequest = saleRemoteDataBaseRequest
    }

    // MARK: Functions
    func getSale(uniqueID: String,
                 completionHandler: @escaping (Error?, Sale?) -> Void) {
        // Get a sale from database only once
        let condition = RemoteDataBase.Condition(key: "uniqueID", value: uniqueID)

        saleRemoteDataBaseRequest.get(conditionInField: condition) { (error, loadedSales: [Sale]? ) in
            if let error = error {
                completionHandler(error, nil)
            } else {
                guard let loadedSales = loadedSales else {
                    completionHandler(SAPIError.other, nil)
                    return
                }
                completionHandler(nil, loadedSales.first)
            }
        }
    }

    func createNewSale(purse: Purse?,
                       user: User?,
                       completionHandler: @escaping (Error?, Sale?) -> Void) {
        guard let purse = purse, let user = user else {
            completionHandler(SAPIError.other, nil)
            return
        }

        let date = Date()
        let frenchFormatter = DateFormatter()
        frenchFormatter.dateStyle = .short
        frenchFormatter.timeStyle = .short
        frenchFormatter.locale = Locale(identifier: "FR-fr")
        let currentDate = frenchFormatter.string(from: date)

        let uniqueID = purse.name + " " + date.description + " " + UUID().description
        let newSale = Sale(date: currentDate, uniqueID: uniqueID, amount: 0,
                           numberOfArticle: 0, madeByUser: user.email,
                           inArticlesCode: [""], purseName: purse.name)
        saleRemoteDataBaseRequest
            .createWithOneTransaction(
                model: purse,
                block: { (remotePurse) -> [String: Any] in
                    remotePurse.numberOfSales += 1
                    return ["numberOfSales": remotePurse.numberOfSales]
                },
                resultBlock: { () -> Sale in
                    return newSale
                },
                completionHandler: { (error) in
                    if let error = error {
                        completionHandler(error, nil)
                    } else {
                        completionHandler(nil, newSale)
                    }
            })
    }

    func updateDataforArticleSold(article: Article, sale: Sale, purse: Purse?,
                                  completionHandler: @escaping (Error?) -> Void) {
        guard let purse = purse else { completionHandler(SAPIError.other)
                                        return }

        let fakeSellerForId = Seller(familyName: "", firstName: "", email: "",
                                 phoneNumber: "", code: "", createdBy: "", purseName: "",
                                 uniqueID: article.sellerUniqueId, refundDate: "", refundBy: "")
        var articlePrice: Double = 0
        var benefitOnSalesAmountForPurse: Double = 0

        saleRemoteDataBaseRequest
            .uptadeWithFourTransactions(
                modelsA: (firstModel: article, secondModel: purse),
                modelsB: (thirdModel: fakeSellerForId, fourthModel: sale),
                blocksA: (
                    firstBlock: { (remoteArticle) -> [String: Any] in
                        remoteArticle.sold = true
                        articlePrice = remoteArticle.price
                        return ["sold": remoteArticle.sold]
                        },
                    secondBlock: { (remotePurse) -> [String: Any] in
                        remotePurse.numberOfArticlesold += 1
                        remotePurse.totalSalesAmount += articlePrice
                        benefitOnSalesAmountForPurse = articlePrice * remotePurse.percentageOnSales * 0.01
                        remotePurse.totalBenefitOnSalesAmount += benefitOnSalesAmountForPurse

                        return ["numberOfArticlesold": remotePurse.numberOfArticlesold,
                               "totalSalesAmount": remotePurse.totalSalesAmount,
                               "totalBenefitOnSalesAmount": remotePurse.totalBenefitOnSalesAmount]
                       }),
                blocksB: (
                    thirdBlock: { (remoteSeller) -> [String: Any] in
                        remoteSeller.articlesold += 1
                        remoteSeller.salesAmount += articlePrice - benefitOnSalesAmountForPurse
                        return ["articlesold": remoteSeller.articlesold,
                               "salesAmount": remoteSeller.salesAmount]
                        },
                    fourthBlock: { (remoteSale) -> [String: Any] in
                        remoteSale.amount += articlePrice
                        remoteSale.inArticlesCode.append(article.code)
                        remoteSale.numberOfArticle += 1
                        return ["amount": remoteSale.amount,
                                "inArticlesCode": remoteSale.inArticlesCode,
                                "numberOfArticle": remoteSale.numberOfArticle]
                        }),
                completionHandler: { (error) in
                     if let error = error { completionHandler(error)
                         } else { completionHandler(nil) }
            })
    }

    // remove a sale without any implementation on other model in the database
    // For testing
    func removeHard(sale: Sale,
                    completionHandler: @escaping (Error?) -> Void) {
        saleRemoteDataBaseRequest.remove(model: sale) { (error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }

    func stopListen() {
        saleRemoteDataBaseRequest.stopListen()
    }
}

extension SaleAPI {
    /**
     'SAPIError' is the error type returned by SaleAPI.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     */
    enum SAPIError: String, Error {
        case other = "Sorry, there is an error !"
        case nothing = "Sorry, there is no sale with this name !"
    }
}
