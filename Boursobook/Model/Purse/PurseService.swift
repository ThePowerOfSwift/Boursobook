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
    private var purseRemoteDataBaseRequest: RemoteDatabaseRequest = FireBaseRequest()

    // MARK: Initialisation
    init() {}
    init(purseRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.purseRemoteDataBaseRequest = purseRemoteDataBaseRequest
    }

    // MARK: Function
    func create(purse: Purse) {
        // Create a purse in the remote database
//        purseRemoteDataBaseRequest.create(dataNode: locationInRemoteDataBase, model: purse)
        //FIXME: a implementer
    }

    func remove(purse: Purse) {
        // Delete an purse in the remote database
//        purseRemoteDataBaseRequest.remove(dataNode: locationInRemoteDataBase, model: purse)
        //FIXME: a implementer
    }

    func readAndListenData(completionHandler: @escaping (Bool, [Purse]) -> Void) {
        // Query purses from remote database

//        purseRemoteDataBaseRequest.readAndListenData(dataNode: locationInRemoteDataBase) { (done, pursesReaded) in
//                                                        completionHandler(done, pursesReaded)
//        }
        //FIXME: a implementer
    }

    func stopListen() {
        //Stop the listening of the purses
//        purseRemoteDataBaseRequest.stopListen(dataNode: locationInRemoteDataBase)
//FIXME: a implementer
    }

    func setupRates(purse: Purse, percentage: Double, depositFee: Purse.DepositFee) {
        // set the rates for the purse
//        purse.percentageOnSales = percentage
//        purse.depositFee = depositFee
//        let purseNewValues = purse.setValuesForRemoteDataBase()
//
//        var childUpdate = [String: Any]()
//        for (key, value) in purseNewValues {
//            childUpdate.updateValue(value, forKey: "/\(purse.uniqueID)/\(key)/")
//        }

//        purseRemoteDataBaseRequest.updateChildValues(dataNode: locationInRemoteDataBase, childUpdates: childUpdate)
        //FIXME: a implementer
    }

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
