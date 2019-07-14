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
    // MARK: - Properties
    let reference = Database.database().reference(withPath: "sellers")

    // MARK: - Functions
    func create(seller: Seller) {
        let sellerRef = reference.child(seller.code)
        let values: [String: Any] = ["firstName": seller.firstName, "familyName": seller.familyName,
                                     "code": seller.code,
                                     "email": seller.email, "phoneNumber": seller.phoneNumber,
                                     "createdBy": seller.createdBy, "purse": seller.purseName,
                                     "articleSolded": 0, "articleRegistered": 0,
                                     "depositFeeAmount": 0, "salesAmount": 0, "orderNumber": 0,
                                     "refundDone": false, "refundDate": "", "refundBy": ""]
        sellerRef.setValue(values)
    }

    func remove(seller: Seller) {
        reference.child(seller.code).removeValue()
    }

    func readAndListenData(for purse: Purse, completionHandler: @escaping (Bool, [Seller]) -> Void) {
        // Query sellers from FireBase for one Purse
        reference.queryOrdered(byChild: "purse").queryEqual(toValue: purse.name).observe(.value) { snapshot in
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

    func increaseNumberOfArtilceRegistered(for codeOfSeller: String) {
        // add 1 to the number of article registered of the seller
        reference.child(codeOfSeller).runTransactionBlock ({ (currentData) -> TransactionResult in

            if var seller = currentData.value as? [String: AnyObject] {
                var articleRegistered = seller["articleRegistered"] as? Int ?? 0
                articleRegistered += 1
                seller["articleRegistered"] = articleRegistered as AnyObject?

                // Set value and report transaction success
                currentData.value = seller

                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) {(error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func increaseOrderNumber(for codeOfSeller: String) {
        // add 1 to the number of article registered of the seller
        reference.child(codeOfSeller).runTransactionBlock ({ (currentData) -> TransactionResult in

            if var seller = currentData.value as? [String: AnyObject] {
                var orderNumber = seller["orderNumber"] as? Int ?? 0
                orderNumber += 1
                seller["orderNumber"] = orderNumber as AnyObject?

                // Set value and report transaction success
                currentData.value = seller

                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) {(error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
// TODO:          - tests à faire
//                  - gestion erreur dans increase number of article et number of order
