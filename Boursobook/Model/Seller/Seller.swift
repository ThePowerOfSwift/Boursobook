//
//  Seller.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class Seller: Equatable {

    // MARK: - Properties
    let familyName: String
    let firstName: String
    let email: String
    let phoneNumber: String
    let code: String
    let createdBy: String
    let purseName: String

    var articleSolded = 0
    var articleRegistered = 0
    var orderNumber = 0
    var depositFeeAmount: Double = 0
    var salesAmount: Double = 0

    var refundDone = false
    var refundDate: String?
    var refundBy: String?

    // MARK: - Initialisation
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
        guard   let snapshotValue = snapshot.value as? [String: AnyObject],
                let familyNameValue = snapshotValue["familyName"] as? String,
                let firstNameValue = snapshotValue["firstName"] as? String,
                let emailValue = snapshotValue["email"] as? String,
                let phoneNumberValue = snapshotValue["phoneNumber"] as? String,
                let codeValue = snapshotValue["code"] as? String,
                let createdByValue = snapshotValue["createdBy"] as? String,
                let purseValue = snapshotValue["purseName"] as? String,
                let articleSoldedValue = snapshotValue["articleSolded"] as? Int,
                let articleRegisteredValue = snapshotValue["articleRegistered"] as? Int,
                let orderNumberValue = snapshotValue["orderNumber"] as? Int,
                let depositFeeAmountValue = snapshotValue["depositFeeAmount"] as? Double,
                let salesAmountValue = snapshotValue["salesAmount"] as? Double,
                let refundDoneValue = snapshotValue["refundDone"] as? Bool,
                let refundDateValue = snapshotValue["refundDate"] as? String,
                let refundByValue = snapshotValue["refundBy"] as? String else {
                return nil
        }

        familyName = familyNameValue
        firstName = firstNameValue
        email = emailValue
        phoneNumber = phoneNumberValue
        code = codeValue
        createdBy = createdByValue
        purseName = purseValue
        articleSolded = articleSoldedValue
        articleRegistered = articleRegisteredValue
        orderNumber = orderNumberValue
        depositFeeAmount = depositFeeAmountValue
        salesAmount = salesAmountValue
        refundDone = refundDoneValue
        refundDate = refundDateValue
        refundBy = refundByValue
    }

    // MARK: - Functions
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
//                  - probleme de la fonction nextnumber si on supprime des articles et qu'on en crée d'autre après
//                  - Mettre les zero dans le numero d'ordre
