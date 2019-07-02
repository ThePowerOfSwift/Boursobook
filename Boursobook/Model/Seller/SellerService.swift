//
//  SellerService.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//


//  JSON Configuration for FireBase
//  {
//    "sellers": {
//      "DUPP" : {
//          "firstName": "Pierre",
//          "familyName": "Dupond",
//          "code": "DUPP",
//          "email": "jean@dd.fr",
//          "phoneNumber": "3333333",
//          "addedByUser": "ddddd",
//          "numberRegisteredArticles": 23,
//          "numberSoldedArticles": 22,
//          "depositAmount": 10,
//          "salesAmount": 13,30
//          "purse": {
//              "APE2019": True
//          }
//          "
//      }
//    }
//  }


import Foundation
import Firebase

class SellerService {
    static var shared = SellerService()

    private(set) var sellers: [Seller] = []
    let reference = Database.database().reference(withPath: "sellers")

    private init() {
    }

    func add(seller: Seller) {
        sellers.append(seller)
    }
    func removeSeller(at index: Int) {
        let seller = sellers[index]
        seller.ref?.removeValue()
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
