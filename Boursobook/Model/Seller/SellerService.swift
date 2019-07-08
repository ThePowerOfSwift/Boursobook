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
    static var shared = SellerService()

    private(set) var sellers: [Seller] = []
    let reference = Database.database().reference(withPath: "sellers")

    private init() {
    }

    func createNew(seller: Seller) {
        sellers.append(seller)
        guard let userLogIn = UserService.shared.userLogIn, let currentPurse = PurseService.shared.currentPurse else {
            return
        }

        let sellerRef = reference.child(seller.code)
        let values: [String: Any] = ["firstName": seller.firstName, "familyName": seller.familyName,
                                     "code": seller.code,
                                     "email": seller.email, "phoneNumber": seller.phoneNumber,
                                     "createdBy": userLogIn.uid, "purse": currentPurse.name,
                                     "articleSolded": 0, "articleRegistered": 0,
                                     "depositFeeAmount": 0, "salesAmount": 0,
                                     "refundDone": false, "refundDate": "", "refundBy": ""]
        sellerRef.setValue(values)

    }
    func removeSeller(at index: Int) {
        let seller = sellers[index]
        reference.child(seller.code).removeValue()

        sellers.remove(at: index)
    }

    func familyNameOrderedQuery(completionHandler: @escaping (Bool) -> Void) {
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
            self.sellers = newSellers
            completionHandler(true)
        }
    }

    func downloadData(completionHandler: @escaping (Bool) -> Void) {
        //download value from FireBase
        reference.observe(.value) { snapshot in
            var newSellers: [Seller] = []

            for child in snapshot.children {
                if let childValue = child as? DataSnapshot {
                    if let seller = Seller(snapshot: childValue) {
                        newSellers.append(seller)
                    }
                }
            }
            self.sellers = newSellers
            completionHandler(true)
        }
    }
}
// TODO:          - tests à faire
