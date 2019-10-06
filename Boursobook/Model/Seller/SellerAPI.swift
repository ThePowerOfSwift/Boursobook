//
//  SellerAPI.swift
//  Boursobook
//
//  Created by David Dubez on 05/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class SellerAPI {
    // Manage the acces of "seller" data

    // MARK: Properties
    private var sellerRemoteDataBaseRequest: RemoteDatabaseRequest = FireBaseDataRequest(collection: Seller.collection)

    // MARK: Initialisation
    init() {}
    init(sellerRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.sellerRemoteDataBaseRequest = sellerRemoteDataBaseRequest
    }

    // MARK: Functions
    func getSeller(uniqueID: String, completionHandler: @escaping (Error?, Seller?) -> Void) {
        // Query a seller from database by his uniqueID

        let condition = RemoteDataBase.Condition(key: "uniqueID", value: uniqueID)
        sellerRemoteDataBaseRequest.get(conditionInField: condition) { (error, loadedSellers: [Seller]? ) in
            if let error = error {
                completionHandler(error, nil)
            } else {
                guard let loadedSellers = loadedSellers else {
                    completionHandler(SAPIError.other, nil)
                    return
                }
                completionHandler(nil, loadedSellers.first)
            }
        }
    }

    func loadSellersFor(purseName: String?, completionHandler: @escaping (Error?, [Seller]?) -> Void) {
        // Query sellers from database for a purse

        guard let purseName = purseName else {
            completionHandler(SAPIError.other, nil)
            return
        }
        let condition = RemoteDataBase.Condition(key: "purseName", value: purseName)

        sellerRemoteDataBaseRequest
            .readAndListenData(conditionInField: condition) { (error, loadedSellers: [Seller]? ) in
                                                        if let error = error {
                                                            completionHandler(error, nil)
                                                        } else {
                                                            guard let loadedSellers = loadedSellers else {
                                                                completionHandler(SAPIError.other, nil)
                                                                return
                                                            }
                                                            completionHandler(nil, loadedSellers)
                                                        }
        }
    }

    func loadSeller(uniqueID: String, completionHandler: @escaping (Error?, Seller?) -> Void) {
        // Query a seller from database with his uniqueID
        let condition = RemoteDataBase.Condition(key: "uniqueID", value: uniqueID)

        sellerRemoteDataBaseRequest
            .readAndListenData(conditionInField: condition) { (error, loadedSellers: [Seller]? ) in
            if let error = error {
                completionHandler(error, nil)
            } else {
                guard let loadedSellers = loadedSellers else {
                    completionHandler(SAPIError.other, nil)
                    return
                }
                completionHandler(nil, loadedSellers.first)
            }
        }
    }

    func getExistingSellerCode(completionHandler: @escaping (Error?, [String]?) -> Void) {
        sellerRemoteDataBaseRequest.get { (error, loadedSellers: [Seller]?) in
            var sellerCodeList = [String]()

            if let error = error {
                completionHandler(error, nil)
            } else {
                guard let loadedSellers = loadedSellers else {
                    completionHandler(SAPIError.other, nil)
                    return
                }
                for seller in loadedSellers {
                    sellerCodeList.append(seller.code)
                }
                completionHandler(nil, sellerCodeList)
            }
        }
    }

    func createSeller(newSeller: Seller,
                      in purse: Purse?,
                      completionHandler: @escaping (Error?) -> Void) {

        guard let purse = purse else {
                   completionHandler(SAPIError.other)
                   return
               }

        sellerRemoteDataBaseRequest
                   .createWithOneTransaction(model: purse,
                                             block: { (remotePurse) -> [String: Any] in
                                                remotePurse.numberOfSellers += 1
                                                return ["numberOfSellers":
                                                    remotePurse.numberOfSellers]
                                                },
                                            resultBlock: { () -> Seller in
                                                return newSeller
                                               },
                                            completionHandler: { (error) in
                                                if let error = error {
                                                    completionHandler(error)
                                                } else {
                                                    completionHandler(nil)
                                                }
                                            })

    }

    func removeSeller(seller: Seller,
                      in purse: Purse?,
                      completionHandler: @escaping (Error?) -> Void) {

        guard let purse = purse else {
                   completionHandler(SAPIError.other)
                   return
               }

        sellerRemoteDataBaseRequest
                   .removeWithOneTransaction(model: purse,
                                             block: { (remotePurse) -> [String: Any] in
                                                remotePurse.numberOfSellers -= 1
                                                return ["numberOfSellers":
                                                    remotePurse.numberOfSellers]
                                                },
                                            modelToRemove: seller,
                                            completionHandler: { (error) in
                                                if let error = error {
                                                    completionHandler(error)
                                                } else {
                                                    completionHandler(nil)
                                                }
                                            })

    }

    func updateDataForArticleReturned(article: Article,
                                      seller: Seller,
                                      purse: Purse?,
                                      user: User?,
                                      completionHandler: @escaping (Error?) -> Void) {
        guard let purse = purse, let user = user else {
          completionHandler(SAPIError.other)
          return
      }
        let date = Date()
        let frenchFormatter = DateFormatter()
        frenchFormatter.dateStyle = .short
        frenchFormatter.timeStyle = .short
        frenchFormatter.locale = Locale(identifier: "FR-fr")
        let currentDate = frenchFormatter.string(from: date)

        sellerRemoteDataBaseRequest
        .uptadeWithFourTransactions(
            modelsA: (firstModel: article, secondModel: purse),
            modelsB: (thirdModel: seller, fourthModel: user),
            blocksA: (
                firstBlock: { (remoteArticle) -> [String: Any] in
                    remoteArticle.returned = true
                    return ["returned": remoteArticle.returned]
                    },
                secondBlock: { (remotePurse) -> [String: Any] in
                    remotePurse.numberOfArticleReturned += 1
                    return ["numberOfArticleReturned": remotePurse.numberOfArticleReturned]
                   }),
            blocksB: (
                thirdBlock: { (remoteSeller) -> [String: Any] in
                    remoteSeller.refundDate = currentDate
                    remoteSeller.refundDone = true
                    remoteSeller.refundBy = user.email

                    return ["refundDate": remoteSeller.refundDate,
                           "refundDone": remoteSeller.refundDone,
                           "refundBy": remoteSeller.refundBy]
                    },
                fourthBlock: { (_) -> [String: Any] in
                    return [:]
                    }),
            completionHandler: { (error) in
                 if let error = error {
                     completionHandler(error)
                     } else {
                         completionHandler(nil)
                         }
        })
    }

    // remove a saler without any implementation on other model in the database
    // For testing
    func removeHard(seller: Seller,
                    completionHandler: @escaping (Error?) -> Void) {
        sellerRemoteDataBaseRequest.remove(model: seller) { (error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }

    func stopListen() {
        sellerRemoteDataBaseRequest.stopListen()
    }

}

    extension SellerAPI {
        /**
         'SAPIError' is the error type returned by SellerAPI.
         It encompasses a few different types of errors, each with
         their own associated reasons.
         */
        enum SAPIError: String, Error {
            case other = "Sorry, there is an error !"
        }
}
