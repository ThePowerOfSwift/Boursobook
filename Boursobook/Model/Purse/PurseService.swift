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
    // Manage the "purses" database on FireBase

    // MARK: Properties
    let reference = Database.database().reference(withPath: "purses")

    // MARK: Function
    func createNew(name: String, percentageOnSales: Double, depositFee: Purse.DepositFee ) {
        // create a new purse
        let purseRef = reference.child(name)
        let purseValues: [String: Any] = [
            "name": name,
            "percentageOnSales": 0,
            "numberOfArticleRegistered": 0,
            "numberOfSellers": 0,
            "numberOfArticleSolded": 0,
            "numberOfTransaction": 0,
            "totalSalesAmount": 0,
            "totalBenefitOnSalesAmount": 0,
            "totalDepositFeeAmount": 0
            ]
        purseRef.setValue(purseValues)
        let depositRef = purseRef.child("depositFee")
        let depositValues: [String: Any] = [
            "underFifty": depositFee.underFifty,
            "underOneHundred": depositFee.underOneHundred,
            "underOneHundredFifty": depositFee.underOneHundredFifty,
            "underTwoHundred": depositFee.underTwoHundred,
            "underTwoHundredFifty": depositFee.underTwoHundredFifty,
            "overTwoHundredFifty": depositFee.overTwoHundredFifty
        ]
        depositRef.setValue(depositValues)
    }

    func readAndListenData(completionHandler: @escaping (Bool, [Purse]) -> Void) {
        //download value from FireBase
        reference.observe(.value) { snapshot in
            var newPurse: [Purse] = []

            for child in snapshot.children {
                if let childValue = child as? DataSnapshot {
                    if let purse = Purse(snapshot: childValue) {
                        newPurse.append(purse)
                    }
                }
            }
            completionHandler(true, newPurse)
        }
    }

    func setupRates(purseName: String, percentage: Double, depositFee: Purse.DepositFee) {
        let newValues = ["percentageOnSales": percentage]
        let newChildValues = ["underFifty": depositFee.underFifty,
                              "underOneHundred": depositFee.underOneHundred,
                              "underOneHundredFifty": depositFee.underOneHundredFifty,
                              "underTwoHundred": depositFee.underTwoHundred,
                              "underTwoHundredFifty": depositFee.underTwoHundredFifty,
                              "overTwoHundredFifty": depositFee.overTwoHundredFifty]
        reference.child(purseName).updateChildValues(newValues)
        reference.child(purseName).child("depositFee").updateChildValues(newChildValues)
    }

    func updateNumberOfSeller(with number: Int, for purseName: String) {
        // add a number to the number of seller for the purse
        reference.child(purseName).runTransactionBlock ({ (currentData) -> TransactionResult in

            if var purse = currentData.value as? [String: AnyObject] {
                var numberOfSeller = purse["numberOfSellers"] as? Int ?? 0
                numberOfSeller += number
                purse["numberOfSellers"] = numberOfSeller as AnyObject?

                // Set value and report transaction success
                currentData.value = purse

                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }, andCompletionBlock: {(error, _, _) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }

    func updateNumberOfArticleRegistered(with number: Int, for purseName: String) {
        // add a number to the number of article registered for the purse
        reference.child(purseName).runTransactionBlock ({ (currentData) -> TransactionResult in

            if var purse = currentData.value as? [String: AnyObject] {
                var numberOfArticleRegistered = purse["numberOfArticleRegistered"] as? Int ?? 0
                numberOfArticleRegistered += number
                purse["numberOfArticleRegistered"] = numberOfArticleRegistered as AnyObject?

                // Set value and report transaction success
                currentData.value = purse

                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }, andCompletionBlock: {(error, _, _) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }

    func updateValuesAfterTransactionWith(for purseName: String, benefit: Double,
                                          salesAmount: Double, articleSolded: Int,
                                          numberTransaction: Int) {
        // Update liste of values of seller after the validation of a transaction

            reference.child(purseName).runTransactionBlock ({ (currentData) -> TransactionResult in

                if var purse = currentData.value as? [String: AnyObject] {
                    var totalBenefitOnSalesAmount = purse["totalBenefitOnSalesAmount"] as? Double ?? 0
                    var totalSalesAmount = purse["totalSalesAmount"] as? Double ?? 0
                    var numberOfArticleSolded = purse["numberOfArticleSolded"] as? Int ?? 0
                    var numberOfTransaction = purse["numberOfTransaction"] as? Int ?? 0

                    totalBenefitOnSalesAmount += benefit
                    totalSalesAmount += salesAmount
                    numberOfArticleSolded += articleSolded
                    numberOfTransaction += numberTransaction

                    purse["totalBenefitOnSalesAmount"] = totalBenefitOnSalesAmount as AnyObject?
                    purse["totalSalesAmount"] = totalSalesAmount as AnyObject?
                    purse["numberOfArticleSolded"] = numberOfArticleSolded as AnyObject?
                    purse["numberOfTransaction"] = numberOfTransaction as AnyObject?

                    // Set value and report transaction success
                    currentData.value = purse

                    return TransactionResult.success(withValue: currentData)
                }
                return TransactionResult.success(withValue: currentData)
            }, andCompletionBlock: {(error, _, _) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
    }
}

// TODO:    - Voir si on crée 2 purse avec le meme nom
//          - voir ce qui se passe si pas de reseau et pas d'acces ???
//          - Gerer l'erreur si aucun purse est retenue? 
