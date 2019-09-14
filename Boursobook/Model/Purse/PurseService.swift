//
//  PurseService.swift
//  Boursobook
//
//  Created by David Dubez on 05/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class PurseService {
    // Manage the "purses" database on a remote database

    // MARK: Properties
    private let locationInRemoteDataBase: RemoteDataBase.Collection = .purse
    private var purseRemoteDataBaseRequest: RemoteDatabaseRequest = FireBaseDataRequest(collection: .purse)

    // MARK: Initialisation
    init() {}
    init(purseRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.purseRemoteDataBaseRequest = purseRemoteDataBaseRequest
    }

    // MARK: Function

    func updateNumberOfSeller(with number: Int, for purse: Purse) {
        // add number to the number of seller for the purse
        // FIXME: injection dependance à faire

//        let reference = Database.database().reference(withPath: locationInRemoteDataBase.rawValue)
//        reference.child(purse.uniqueID).runTransactionBlock ({ (currentData) -> TransactionResult in
//
//            if var purse = currentData.value as? [String: AnyObject] {
//                var numberOfSeller = purse["numberOfSellers"] as? Int ?? 0
//                numberOfSeller += number
//                purse["numberOfSellers"] = numberOfSeller as AnyObject?
//
//                // Set value and report transaction success
//                currentData.value = purse
//
//                return TransactionResult.success(withValue: currentData)
//            }
//            return TransactionResult.success(withValue: currentData)
//        }, andCompletionBlock: {(error, _, _) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        })
    }

    func updateNumberOfArticleRegistered(with number: Int, for purse: Purse) {
        // add a number to the number of article registered for the purse
        // FIXME: injection dependance à faire

//        let reference = Database.database().reference(withPath: locationInRemoteDataBase.rawValue)
//        reference.child(purse.uniqueID).runTransactionBlock ({ (currentData) -> TransactionResult in
//
//            if var purse = currentData.value as? [String: AnyObject] {
//                var numberOfArticleRegistered = purse["numberOfArticleRegistered"] as? Int ?? 0
//                numberOfArticleRegistered += number
//                purse["numberOfArticleRegistered"] = numberOfArticleRegistered as AnyObject?
//
//                // Set value and report transaction success
//                currentData.value = purse
//
//                return TransactionResult.success(withValue: currentData)
//            }
//            return TransactionResult.success(withValue: currentData)
//        }, andCompletionBlock: {(error, _, _) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        })
    }

    func updateValuesAfterTransactionWith(for purse: Purse, benefit: Double,
                                          salesAmount: Double, articlesold: Int,
                                          numberTransaction: Int) {
        // Update liste of values of seller after the validation of a transaction
        // FIXME: injection dependance à faire

//        let reference = Database.database().reference(withPath: locationInRemoteDataBase.rawValue)
//        reference.child(purse.uniqueID).runTransactionBlock ({ (currentData) -> TransactionResult in
//
//                if var purse = currentData.value as? [String: AnyObject] {
//                    var totalBenefitOnSalesAmount = purse["totalBenefitOnSalesAmount"] as? Double ?? 0
//                    var totalSalesAmount = purse["totalSalesAmount"] as? Double ?? 0
//                    var numberOfArticlesold = purse["numberOfArticlesold"] as? Int ?? 0
//                    var numberOfTransaction = purse["numberOfTransaction"] as? Int ?? 0
//
//                    totalBenefitOnSalesAmount += benefit
//                    totalSalesAmount += salesAmount
//                    numberOfArticlesold += articlesold
//                    numberOfTransaction += numberTransaction
//
//                    purse["totalBenefitOnSalesAmount"] = totalBenefitOnSalesAmount as AnyObject?
//                    purse["totalSalesAmount"] = totalSalesAmount as AnyObject?
//                    purse["numberOfArticlesold"] = numberOfArticlesold as AnyObject?
//                    purse["numberOfTransaction"] = numberOfTransaction as AnyObject?
//
//                    // Set value and report transaction success
//                    currentData.value = purse
//
//                    return TransactionResult.success(withValue: currentData)
//                }
//                return TransactionResult.success(withValue: currentData)
//            }, andCompletionBlock: {(error, _, _) in
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//            })
    }
}
