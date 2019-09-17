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

    func createSeller(newSeller: Seller, completionHandler: @escaping (Error?, Seller?) -> Void) {

        sellerRemoteDataBaseRequest.create(model: newSeller) { (error) in
            if let error = error {
                completionHandler(error, nil)
            } else {
                completionHandler(nil, newSeller)
            }
        }
    }

    func removeSeller(seller: Seller, completionHandler: @escaping (Error?) -> Void) {

        sellerRemoteDataBaseRequest.remove(model: seller,
                                          completionHandler: { (error) in
                                            if let error = error {
                                                completionHandler(error)
                                            } else {
                                                completionHandler(nil)
                                            }
        })
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
