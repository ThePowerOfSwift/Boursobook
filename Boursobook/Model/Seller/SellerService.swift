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
                                     "depositFeeAmount": 0, "salesAmount": 0,
                                     "refundDone": false, "refundDate": "", "refundBy": ""]
        sellerRef.setValue(values)
    }

    func remove(seller: Seller) {
        reference.child(seller.code).removeValue()
    }

    func readAndListenData(completionHandler: @escaping (Bool, [Seller]) -> Void) {
        // Query sellers from FireBase and order by name
        reference.queryOrdered(byChild: "familyName").observe(.value) { snapshot in
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
}
// TODO:          - tests à faire
