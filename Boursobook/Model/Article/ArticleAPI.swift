//
//  ArticleAPI.swift
//  Boursobook
//
//  Created by David Dubez on 05/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class ArticleAPI {
    // Manage the acces of "article" data

    // MARK: Properties
    private var articleRemoteDataBaseRequest: RemoteDatabaseRequest
        = FireBaseDataRequest(collection: Article.collection)

    // MARK: Initialisation
    init() {}
    init(articleRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.articleRemoteDataBaseRequest = articleRemoteDataBaseRequest
    }

    // MARK: Functions
    func loadArticlesFor(purse: Purse?, completionHandler: @escaping (Error?, [Article]?) -> Void) {
        // Query Articles from database for a purse

        guard let purse = purse else {
            completionHandler(AAPIError.other, nil)
            return
        }
        let condition = RemoteDataBase.Condition(key: "purseName", value: purse.name)

        articleRemoteDataBaseRequest
            .readAndListenData(conditionInField: condition) { (error, loadedArticles: [Article]? ) in
                                                        if let error = error {
                                                            completionHandler(error, nil)
                                                        } else {
                                                            guard let loadedArticles = loadedArticles else {
                                                                completionHandler(AAPIError.other, nil)
                                                                return
                                                            }
                                                            completionHandler(nil, loadedArticles)
                                                        }
        }
    }

    func getArticlesFor(seller: Seller?, completionHandler: @escaping (Error?, [Article]?) -> Void) {
        // Query Articles from database for a seller

        guard let seller = seller else {
            completionHandler(AAPIError.other, nil)
            return
        }
        let condition = RemoteDataBase.Condition(key: "sellerUniqueId", value: seller.uniqueID)

        articleRemoteDataBaseRequest
            .get(conditionInField: condition) { (error, loadedArticles: [Article]? ) in
                if let error = error {
                    completionHandler(error, nil)
                } else {
                    guard let loadedArticles = loadedArticles else {
                        completionHandler(AAPIError.other, nil)
                        return
                    }
                    completionHandler(nil, loadedArticles)
                }
        }
    }

    func createArticle(purse: Purse?,
                       seller: Seller?,
                       article: Article,
                       completionHandler: @escaping (Error?) -> Void) {
        guard let purse = purse, let seller = seller else {
            completionHandler(AAPIError.other)
            return
        }

        var orderNumber: Int = 0
        let sellerCode = seller.code
        let oldSellerDepositFeeAmount = seller.depositFeeAmount
        var newSellerDepositFeeAmount: Double = 0
        article.purseName = purse.name
        article.sellerUniqueId = seller.uniqueID

        articleRemoteDataBaseRequest.runTransaction(firstModel: seller, secondModel: purse,
                                                    firstBlock: { (remoteSeller) -> [String: Any] in
                                                        remoteSeller.articleRegistered += 1
                                                        remoteSeller.setDepositFeeAmount(with: purse)
                                                        newSellerDepositFeeAmount = remoteSeller.depositFeeAmount
                                                        orderNumber = remoteSeller.orderNumber
                                                        return ["articleRegistered": remoteSeller.articleRegistered,
                                                                "orderNumber": orderNumber + 1,
                                                                "depositFeeAmount": remoteSeller.depositFeeAmount]
        },
                                                    secondBlock: { (remotePurse) -> [String: Any] in
                                                        remotePurse.numberOfArticleRegistered += 1
                                                        remotePurse.totalDepositFeeAmount += newSellerDepositFeeAmount
                                                            - oldSellerDepositFeeAmount
                                                        return ["numberOfArticleRegistered": remotePurse
                                                            .numberOfArticleRegistered,
                                                                "totalDepositFeeAmount": remotePurse
                                                                    .totalDepositFeeAmount]
        },
                                                    resultBlock: { () -> Article in
                                                        let code = sellerCode + String(format: "%03d", orderNumber)
                                                        article.code = code
                                                        article.uniqueID = code + " " + UUID().description
                                                        return article

        },
                                                    completionHandler: { (error) in
                                                        if let error = error {
                                                            completionHandler(error)
                                                        } else {
                                                            completionHandler(nil)
                                                        }
        })
    }
}

extension ArticleAPI {
    /**
     'AAPIError' is the error type returned by ArticleAPI.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     */
    enum AAPIError: String, Error {
        case other = "Sorry, there is an error !"
    }
}
