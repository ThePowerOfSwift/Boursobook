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

    // MARK: Properties
    let pursesReference = Database.database().reference(withPath: "purses")

    // MARK: Function
    func createNew(name: String, percentageOnSales: Double, depositFee: Purse.DepositFee ) {
        // create a new purse
        let purseRef = pursesReference.child(name)
        let purseValues: [String: Any] = [
            "name": name,
            "percentageOnSales": 0,
            "numberOfArticleRegistered": 0,
            "numberOfSellers": 0,
            "numberOfArticleSolded": 0,
            "numberOfTransaction": 0,
            "totalSalesAmount": 0,
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
        pursesReference.observe(.value) { snapshot in
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
        pursesReference.child(purseName).updateChildValues(newValues)
        pursesReference.child(purseName).child("depositFee").updateChildValues(newChildValues)
    }
}

// TODO:    - Voir si on crée 2 purse avec le meme nom
//          - voir ce qui se passe si pas de reseau et pas d'acces ???
//          - Gerer l'erreur si aucun purse est retenue? 
