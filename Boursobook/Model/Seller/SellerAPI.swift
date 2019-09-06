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
    private let remoteDataBaseCollection: RemoteDataBase.Collection = .seller
    private var sellerRemoteDataBaseRequest: RemoteDatabaseRequest = FireBaseDataRequest()

    // MARK: Initialisation
    init() {}
    init(sellerRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.sellerRemoteDataBaseRequest = sellerRemoteDataBaseRequest
    }

    // MARK: Functions
    func loadSellersFor(purse: Purse?, completionHandler: @escaping (Error?, [Seller]?) -> Void) {
        // Query sellers from database for a purse

        guard let purse = purse else {
            completionHandler(SAPIError.other, nil)
            return
        }
        let condition = RemoteDataBase.Condition(key: "purseName", value: purse.name)

        sellerRemoteDataBaseRequest.readAndListenData(collection: remoteDataBaseCollection,
                                                     condition: condition) { (error, loadedSellers: [Seller]? ) in
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
