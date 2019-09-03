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

    var articlesold = 0
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
