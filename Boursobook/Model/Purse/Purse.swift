//
//  Purse.swift
//  Boursobook
//
//  Created by David Dubez on 04/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class Purse: RemoteDataBaseModel {
    // MARK: - Properties
    static let collection = "purses"

    var name: String
    var uniqueID: String

    var numberOfArticleRegistered = 0
    var numberOfSellers = 0
    var numberOfArticlesold = 0
    var numberOfTransaction = 0
    var percentageOnSales: Double
    var depositFee: DepositFee
    var totalSalesAmount: Double = 0
    var totalBenefitOnSalesAmount: Double = 0
    var totalDepositFeeAmount: Double = 0
    var administrators: [String: Bool]
    var users: [String]

    struct DepositFee {
        var underFifty: Double
        var underOneHundred: Double
        var underOneHundredFifty: Double
        var underTwoHundred: Double
        var underTwoHundredFifty: Double
        var overTwoHundredFifty: Double
    }

    // MARK: - Initialisation
    init(name: String, uniqueID: String, numberOfArticleRegistered: Int, numberOfSellers: Int,
         numberOfArticlesold: Int, numberOfTransaction: Int,
         percentageOnSales: Double, depositFee: DepositFee,
         totalSalesAmount: Double, totalBenefitOnSalesAmount: Double,
         totalDepositFeeAmount: Double, administrators: [String: Bool],
         users: [String]) {
        self.name = name
        self.uniqueID = uniqueID
        self.numberOfArticleRegistered = numberOfArticleRegistered
        self.numberOfSellers = numberOfSellers
        self.numberOfArticlesold = numberOfArticlesold
        self.numberOfTransaction = numberOfTransaction
        self.percentageOnSales = percentageOnSales
        self.depositFee = depositFee
        self.totalSalesAmount = totalSalesAmount
        self.totalBenefitOnSalesAmount = totalBenefitOnSalesAmount
        self.totalDepositFeeAmount = totalDepositFeeAmount
        self.administrators = administrators
        self.users = users
    }

    init(name: String, uniqueID: String, administrators: [String: Bool], users: [String]) {
        self.name = name
        self.uniqueID = uniqueID
        self.administrators = administrators
        self.users = users
        let depositFee = DepositFee(underFifty: 0, underOneHundred: 2,
                                    underOneHundredFifty: 4, underTwoHundred: 6,
                                    underTwoHundredFifty: 8, overTwoHundredFifty: 10)
        self.depositFee = depositFee
        self.percentageOnSales = 10
    }

    required init?(dictionary: [String: Any]) {
        guard
            let nameValue = dictionary["name"] as? String,
            let uniqueIDValue = dictionary["uniqueID"] as? String,
            let percentageOnSalesValue = dictionary["percentageOnSales"] as? Double,
            let depositFeeData = dictionary["depositFee"] as? [String: AnyObject],
            let administratorsValue = dictionary["administrators"] as? [String: Bool],
            let usersValue = dictionary["users"] as? [String],
            let numberOfArticleRegisteredValue = dictionary["numberOfArticleRegistered"] as? Int,
            let numberOfSellersValue = dictionary["numberOfSellers"] as? Int,
            let numberOfArticlesoldValue = dictionary["numberOfArticlesold"] as? Int,
            let numberOfTransactionValue = dictionary["numberOfTransaction"] as? Int,
            let totalSalesAmountValue = dictionary["totalSalesAmount"] as? Double,
            let totalBenefitOnSalesAmountValue = dictionary["totalBenefitOnSalesAmount"] as? Double,
            let totalDepositFeeAmountValue = dictionary["totalDepositFeeAmount"] as? Double else {
                return nil
        }

        guard   let underFiftyValue = depositFeeData["underFifty"] as? Double,
            let underOneHundredValue = depositFeeData["underOneHundred"] as? Double,
            let underOneHundredFiftyValue = depositFeeData["underOneHundredFifty"] as? Double,
            let underTwoHundredValue = depositFeeData["underTwoHundred"] as? Double,
            let underTwoHundredFiftyValue = depositFeeData["underTwoHundredFifty"] as? Double,
            let overTwoHundredFiftyValue = depositFeeData["overTwoHundredFifty"] as? Double else {
                return nil
        }

        name = nameValue
        uniqueID = uniqueIDValue
        percentageOnSales = percentageOnSalesValue
        numberOfArticleRegistered = numberOfArticleRegisteredValue
        numberOfSellers = numberOfSellersValue
        numberOfArticlesold = numberOfArticlesoldValue
        numberOfTransaction = numberOfTransactionValue
        totalBenefitOnSalesAmount = totalBenefitOnSalesAmountValue
        totalSalesAmount = totalSalesAmountValue
        totalDepositFeeAmount = totalDepositFeeAmountValue

        depositFee = DepositFee(underFifty: underFiftyValue,
                                underOneHundred: underOneHundredValue,
                                underOneHundredFifty: underOneHundredFiftyValue,
                                underTwoHundred: underTwoHundredValue,
                                underTwoHundredFifty: underTwoHundredFiftyValue,
                                overTwoHundredFifty: overTwoHundredFiftyValue)

        administrators = administratorsValue
        users = usersValue
    }

    var dictionary: [String: Any] {
        let depositFeeValues: [String: Any] = ["underFifty": depositFee.underFifty,
                                               "underOneHundred": depositFee.underOneHundred,
                                               "underOneHundredFifty": depositFee.underOneHundredFifty,
                                               "underTwoHundred": depositFee.underTwoHundred,
                                               "underTwoHundredFifty": depositFee.underTwoHundredFifty,
                                               "overTwoHundredFifty": depositFee.overTwoHundredFifty]
        let values: [String: Any] = ["name": name,
                                     "uniqueID": uniqueID,
                                     "percentageOnSales": percentageOnSales,
                                     "administrators": administrators,
                                     "users": users,
                                     "numberOfArticleRegistered": numberOfArticleRegistered,
                                     "numberOfSellers": numberOfSellers,
                                     "numberOfArticlesold": numberOfArticlesold,
                                     "numberOfTransaction": numberOfTransaction,
                                     "totalSalesAmount": totalSalesAmount,
                                     "totalBenefitOnSalesAmount": totalBenefitOnSalesAmount,
                                     "totalDepositFeeAmount": totalDepositFeeAmount,
                                     "depositFee": depositFeeValues]
        return values
    }
}
