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
    static var shared = PurseService()

    private(set) var purses: [Purse] = []
    private(set) var currentPurse: Purse?

    private init() {
    }

    // Reference for FireBase
    let pursesReference = Database.database().reference(withPath: "purses")

    // MARK: Function
    func createNew(name: String, percentageOnSales: Double, depositFee: Purse.DepositFee ) {
        // create a new purse
        let purseRef = pursesReference.child(name)
        let purseValues: [String: Any] = [
            "name": name,
            "percentageOnSales": 0,
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

    func downloadData(completionHandler: @escaping (Bool) -> Void) {
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
            self.purses = newPurse
            self.setCurrentPurse()
            completionHandler(true)
        }
    }

    func setCurrentPurse() {
        // choose the purse corresponding to the user
        guard let userLogIn = UserService.shared.userLogIn else {
            return
        }
        for purse in purses where purse.users[userLogIn.uid] != nil {
            self.currentPurse = purse
        }
    }
}

// TODO:    - Voir si on crée 2 purse avec le meme nom
//          - voir ce qui se passe si pas de reseau et pas d'acces ???
//          - Problème du total si plusierus acces en meme temps ????
//          - Gerer l'erreur si aucun purse est retenue? 
