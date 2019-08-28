//
//  SellerService.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class SellerService {
    // Manage the "sellers" database on FireBase

    // MARK: - Properties
    let reference = Database.database().reference(withPath: "sellers")

    // MARK: - Functions
    func create(seller: Seller) {
        let sellerRef = reference.child(seller.code)
        let values: [String: Any] = ["firstName": seller.firstName, "familyName": seller.familyName,
                                     "code": seller.code,
                                     "email": seller.email, "phoneNumber": seller.phoneNumber,
                                     "createdBy": seller.createdBy, "purseName": seller.purseName,
                                     "articlesold": 0, "articleRegistered": 0,
                                     "depositFeeAmount": 0, "salesAmount": 0, "orderNumber": 0,
                                     "refundDone": false, "refundDate": "", "refundBy": ""]
        sellerRef.setValue(values)
    }

    func remove(seller: Seller) {
        reference.child(seller.code).removeValue()
    }

    func readAndListenData(for purse: Purse, completionHandler: @escaping (Bool, [Seller]) -> Void) {
        // Query sellers from FireBase for one Purse
        reference.queryOrdered(byChild: "purseName").queryEqual(toValue: purse.name).observe(.value) { snapshot in
            var newSellers: [Seller] = []

            for child in snapshot.children {
                if let childValue = child as? DataSnapshot {
                    if let seller = Seller(snapshot: childValue) {
                        newSellers.append(seller)
                    }
                }
            }
            completionHandler(true, newSellers)
        }
    }

    func updateArticlesCounters(for codeOfSeller: String,
                                numberArticleRegistered: Int,
                                numberOrder: Int) {
        // update the counters of articles for a seller
        reference.child(codeOfSeller).runTransactionBlock ({ (currentData) -> TransactionResult in

            if var seller = currentData.value as? [String: AnyObject] {
                var articleRegistered = seller["articleRegistered"] as? Int ?? 0
                var orderNumber = seller["orderNumber"] as? Int ?? 0

                articleRegistered += numberArticleRegistered
                orderNumber += numberOrder

                seller["articleRegistered"] = articleRegistered as AnyObject?
                seller["orderNumber"] = orderNumber as AnyObject?

                // Set value and report transaction success
                currentData.value = seller

                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }, andCompletionBlock: {(error, _, _) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }

    func updateDepositFee(for seller: Seller, with value: Double) {
        let newValue = ["depositFeeAmount": value]
        reference.child(seller.code).updateChildValues(newValue)
    }

    func updateValuesAfterTransaction(for list: [String: TransactionValues]) {
        // Update liste of values of seller after the validation of a transaction
        for (sellerCode, values) in list {
            reference.child(sellerCode).runTransactionBlock ({ (currentData) -> TransactionResult in

                if var seller = currentData.value as? [String: AnyObject] {
                    var salesAmount = seller["salesAmount"] as? Double ?? 0
                    var articlesold = seller["articlesold"] as? Int ?? 0

                    salesAmount += values.amount
                    articlesold += values.number

                    seller["salesAmount"] = salesAmount as AnyObject?
                    seller["articlesold"] = articlesold as AnyObject?

                    // Set value and report transaction success
                    currentData.value = seller

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
}
// TODO:          - tests à faire
//                - gestion erreur dans increase number of article et number of order
