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
    var name: String
    var uniqueID: String

    var numberOfArticleRegistered = 0
    var numberOfSellers = 0
    var numberOfArticleSolded = 0
    var numberOfTransaction = 0
    var percentageOnSales: Double
    var depositFee: DepositFee
    var totalSalesAmount: Double = 0
    var totalBenefitOnSalesAmount: Double = 0
    var totalDepositFeeAmount: Double = 0
    var administrators: [String: Bool]
    var users: [String: String]

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
         numberOfArticleSolded: Int, numberOfTransaction: Int,
         percentageOnSales: Double, depositFee: DepositFee,
         totalSalesAmount: Double, totalBenefitOnSalesAmount: Double,
         totalDepositFeeAmount: Double, administrators: [String: Bool],
         users: [String: String]) {
        self.name = name
        self.uniqueID = uniqueID
        self.numberOfArticleRegistered = numberOfArticleRegistered
        self.numberOfSellers = numberOfSellers
        self.numberOfArticleSolded = numberOfArticleSolded
        self.numberOfTransaction = numberOfTransaction
        self.percentageOnSales = percentageOnSales
        self.depositFee = depositFee
        self.totalSalesAmount = totalSalesAmount
        self.totalBenefitOnSalesAmount = totalBenefitOnSalesAmount
        self.totalDepositFeeAmount = totalDepositFeeAmount
        self.administrators = administrators
        self.users = users
    }

    required init?(snapshot: DataSnapshot) {
        guard   let snapshotValue = snapshot.value as? [String: AnyObject],
                let nameValue = snapshotValue["name"] as? String,
                let uniqueIDValue = snapshotValue["uniqueID"] as? String,
                let percentageOnSalesValue = snapshotValue["percentageOnSales"] as? Double,
                let depositFeeData = snapshotValue["depositFee"] as? [String: AnyObject],
                let administratorsValue = snapshotValue["administrators"] as? [String: Bool],
                let usersValue = snapshotValue["users"] as? [String: String],
                let numberOfArticleRegisteredValue = snapshotValue["numberOfArticleRegistered"] as? Int,
                let numberOfSellersValue = snapshotValue["numberOfSellers"] as? Int,
                let numberOfArticleSoldedValue = snapshotValue["numberOfArticleSolded"] as? Int,
                let numberOfTransactionValue = snapshotValue["numberOfTransaction"] as? Int,
                let totalSalesAmountValue = snapshotValue["totalSalesAmount"] as? Double,
            let totalBenefitOnSalesAmountValue = snapshotValue["totalBenefitOnSalesAmount"] as? Double,
                let totalDepositFeeAmountValue = snapshotValue["totalDepositFeeAmount"] as? Double else {
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
        numberOfArticleSolded = numberOfArticleSoldedValue
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

    func setValuesForRemoteDataBase() -> [String: Any] {
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
                                     "numberOfArticleSolded": numberOfArticleSolded,
                                     "numberOfTransaction": numberOfTransaction,
                                     "totalSalesAmount": totalSalesAmount,
                                     "totalBenefitOnSalesAmount": totalBenefitOnSalesAmount,
                                     "totalDepositFeeAmount": totalDepositFeeAmount,
                                     "depositFee": depositFeeValues]
        return values
    }
}
