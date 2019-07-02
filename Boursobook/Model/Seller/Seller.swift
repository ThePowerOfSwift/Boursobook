//
//  Seller.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

struct Seller: Equatable {
   
    let familyName: String
    let firstName: String
    let email: String
    let phoneNumber: String
    let code: String
    var soldedItem = 0
    var itemsToSold = 0
    let addedByUser: String
    let ref: DatabaseReference?

    init(familyName: String, firstName: String, email: String, phoneNumber: String, code: String, addedByUser: String) {
        self.familyName = familyName
        self.firstName = firstName
        self.email = email
        self.phoneNumber = phoneNumber
        self.code = code
        self.addedByUser = addedByUser
        self.ref = nil
    }

   init?(snapshot: DataSnapshot) {
        code = snapshot.key
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        guard let familyNameValue = snapshotValue["familyName"] as? String else {
            return nil
        }
        guard let firstNameValue = snapshotValue["firstName"] as? String else {
            return nil
        }
        guard let emailValue = snapshotValue["email"] as? String else {
            return nil
        }
        guard let phoneNumberValue = snapshotValue["phoneNumber"] as? String else {
            return nil
        }
        guard let addedByUserValue = snapshotValue["addedByUser"] as? String else {
            return nil
        }
        familyName = familyNameValue
        firstName = firstNameValue
        email = emailValue
        phoneNumber = phoneNumberValue
        addedByUser = addedByUserValue
        ref = snapshot.ref
    }
    
    // To conform to equatable protocol
    static func == (lhs: Seller, rhs: Seller) -> Bool {
        if lhs.code == rhs.code && lhs.email == rhs.email
            && lhs.familyName == rhs.familyName && lhs.firstName == rhs.firstName {
            return true
        }
        return false
    }

}
// TODO:          - tests à faire
//                 - calcul des articles à vendre et vendus
