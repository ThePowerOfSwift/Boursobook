//
//  Seller.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class Seller: Equatable {
    static func == (lhs: Seller, rhs: Seller) -> Bool {
        if lhs.code == rhs.code && lhs.email == rhs.email
            && lhs.familyName == rhs.familyName && lhs.firstName == rhs.firstName {
            return true
        }
        return false
    }
    
    var familyName: String
    var firstName: String
    var email: String
    var phoneNumber: String
    var code: String
    var soldedItem = 0
    var itemsToSold = 0

    init(familyName: String, firstName: String, email: String, phoneNumber: String, code: String) {
        self.familyName = familyName
        self.firstName = firstName
        self.email = email
        self.phoneNumber = phoneNumber
        self.code = code
    }
}
// TODO:          - tests à faire
//                 - calcul des articles à vendre et vendus
