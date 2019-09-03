//
//  Seller.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class Seller: RemoteDataBaseModel {

    // MARK: - Properties
    let familyName: String
    let firstName: String
    let email: String
    let phoneNumber: String
    let code: String
    let createdBy: String
    let purseName: String
    var uniqueID: String

    var articlesold = 0
    var articleRegistered = 0
    var orderNumber = 0
    var depositFeeAmount: Double = 0
    var salesAmount: Double = 0

    var refundDone = false
    var refundDate: String
    var refundBy: String

    var dictionary: [String: Any] {
        let values: [String: Any] = ["familyName": familyName,
                                     "firstName": firstName,
                                     "email": email,
                                     "phoneNumber": phoneNumber,
                                     "code": code,
                                     "createdBy": createdBy,
                                     "purseName": purseName,
                                     "uniqueID": uniqueID,
                                     "articlesold": articlesold,
                                     "articleRegistered": articleRegistered,
                                     "orderNumber": orderNumber,
                                     "depositFeeAmount": depositFeeAmount,
                                     "salesAmount": salesAmount,
                                     "refundDone": refundDone,
                                     "refundDate": refundDate,
                                     "refundBy": refundBy]
        return values
    }

    // MARK: - Initialisation
    init(familyName: String, firstName: String, email: String, phoneNumber: String,
         code: String, createdBy: String, purseName: String, uniqueID: String, refundDate: String, refundBy: String) {
        self.familyName = familyName
        self.firstName = firstName
        self.email = email
        self.phoneNumber = phoneNumber
        self.code = code
        self.createdBy = createdBy
        self.purseName = purseName
        self.uniqueID = uniqueID
        self.refundDate = refundDate
        self.refundBy = refundBy
    }

    required init?(dictionary: [String: Any]) {
        guard
            let familyName = dictionary["familyName"] as? String,
            let firstName = dictionary["firstName"] as? String,
            let email = dictionary["email"] as? String,
            let phoneNumber = dictionary["phoneNumber"] as? String,
            let code = dictionary["code"] as? String,
            let createdBy = dictionary["createdBy"] as? String,
            let purseName = dictionary["purseName"] as? String,
            let uniqueID = dictionary["uniqueID"] as? String,
            let articlesold = dictionary["articlesold"] as? Int,
            let articleRegistered = dictionary["articleRegistered"] as? Int,
            let orderNumber = dictionary["orderNumber"] as? Int,
            let depositFeeAmount = dictionary["depositFeeAmount"] as? Double,
            let salesAmount = dictionary["salesAmount"] as? Double,
            let refundDone = dictionary["refundDone"] as? Bool,
            let refundDate = dictionary["refundDate"] as? String,
            let refundBy = dictionary["refundBy"] as? String else {
                return nil
        }
        self.familyName = familyName
        self.firstName = firstName
        self.email = email
        self.phoneNumber = phoneNumber
        self.code = code
        self.createdBy = createdBy
        self.purseName = purseName
        self.uniqueID = uniqueID
        self.articlesold = articlesold
        self.articleRegistered = articleRegistered
        self.orderNumber = orderNumber
        self.depositFeeAmount = depositFeeAmount
        self.salesAmount = salesAmount
        self.refundDone = refundDone
        self.refundDate = refundDate
        self.refundBy = refundBy
    }
}

extension Seller: Equatable {
    // To conform to equatable protocol
    static func == (lhs: Seller, rhs: Seller) -> Bool {
        if lhs.code == rhs.code && lhs.email == rhs.email
            && lhs.familyName == rhs.familyName && lhs.firstName == rhs.firstName
            && lhs.uniqueID == rhs.uniqueID {
            return true
        }
        return false
    }
}
