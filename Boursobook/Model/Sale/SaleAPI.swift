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
    func createSale(purse: Purse?,
                    user: User?,
                    sale: Sale,
                    completionHandler: @escaping (Error?) -> Void) {
        guard let purse = purse, let user = user else {
            completionHandler(SAPIError.other)
            return
        }

        // FIXME: enregistrement a faire

//        var orderNumber: Int = 0
//        let sellerCode = seller.code
//        let oldSellerDepositFeeAmount = seller.depositFeeAmount
//        var newSellerDepositFeeAmount: Double = 0
//        article.purseName = purse.name
//        article.sellerUniqueId = seller.uniqueID
//
//        articleRemoteDataBaseRequest
//            .runTransactionForCreate(models: (firstModel: seller, secondModel: purse),
//                                     blocks: (
//                                        firstBlock: { (remoteSeller) -> [String: Any] in
//                                            remoteSeller.articleRegistered += 1
//                                            remoteSeller.setDepositFeeAmount(with: purse)
//                                            newSellerDepositFeeAmount = remoteSeller.depositFeeAmount
//                                            orderNumber = remoteSeller.orderNumber
//                                            return ["articleRegistered": remoteSeller.articleRegistered,
//                                                    "orderNumber": orderNumber + 1,
//                                                    "depositFeeAmount": remoteSeller.depositFeeAmount]
//                                            },
//                                        secondBlock: { (remotePurse) -> [String: Any] in
//                                            remotePurse.numberOfArticleRegistered += 1
//                                            remotePurse.totalDepositFeeAmount += newSellerDepositFeeAmount
//                                              - oldSellerDepositFeeAmount
//                                            return ["numberOfArticleRegistered": remotePurse
//                                                        .numberOfArticleRegistered,
//                                                    "totalDepositFeeAmount": remotePurse
//                                                        .totalDepositFeeAmount]
//                                            }),
//                                        resultBlock: { () -> Article in
//                                            let code = sellerCode + String(format: "%03d", orderNumber)
//                                            article.code = code
//                                            article.uniqueID = code + " " + UUID().description
//                                            return article
//                                        },
//                                        completionHandler: { (error) in
//                                            if let error = error {
//                                                completionHandler(error)
//                                            } else {
//                                                completionHandler(nil)
//                                            }
//                                        })
    }

// FIXME: suppression a faire

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
    }
}
