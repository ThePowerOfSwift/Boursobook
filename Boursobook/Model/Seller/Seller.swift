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
    let createdBy: String
    let purseName: String

    var articleSolded = 0
    var articleRegistered = 0
    var depositFeeAmount: Double = 0
    var salesAmount: Double = 0

    var refundDone = false
    var refundDate: Date?
    var refundBy: User?

    init(familyName: String, firstName: String, email: String, phoneNumber: String,
         code: String, createdBy: String, purseName: String) {
        self.familyName = familyName
        self.firstName = firstName
        self.email = email
        self.phoneNumber = phoneNumber
        self.code = code
        self.createdBy = createdBy
        self.purseName = purseName
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
        guard let createdByValue = snapshotValue["createdBy"] as? String else {
            return nil
        }
        guard let purseValue = snapshotValue["purse"] as? String else {
            return nil
        }
        familyName = familyNameValue
        firstName = firstNameValue
        email = emailValue
        phoneNumber = phoneNumberValue
        createdBy = createdByValue
        purseName = purseValue
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
