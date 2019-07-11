//
//  Purse.swift
//  Boursobook
//
//  Created by David Dubez on 04/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class Purse {
    var name: String

    var numberOfArticleRegistered = 0
    var numberOfSellers = 0
    var numberOfArticleSolded = 0
    var numberOfTransaction = 0

    var percentageOnSales: Double
    var depositFee: DepositFee

    struct DepositFee {
        var underFifty: Double
        var underOneHundred: Double
        var underOneHundredFifty: Double
        var underTwoHundred: Double
        var underTwoHundredFifty: Double
        var overTwoHundredFifty: Double
    }

    var totalSalesAmount: Double = 0
    var totalDepositFeeAmount: Double = 0
    var administrators: [String: Bool]
    var users: [String: Bool]

    init?(snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        guard let nameValue = snapshotValue["name"] as? String else {
            return nil
        }
        guard let percentageOnSalesValue = snapshotValue["percentageOnSales"] as? Double else {
            return nil
        }
        guard let depositFeeData = snapshotValue["depositFee"] as? [String: AnyObject] else {
            return nil
        }
        guard let underFiftyValue = depositFeeData["underFifty"] as? Double else {
            return nil
        }
        guard let underOneHundredValue = depositFeeData["underOneHundred"] as? Double else {
            return nil
        }
        guard let underOneHundredFiftyValue = depositFeeData["underOneHundredFifty"] as? Double else {
            return nil
        }
        guard let underTwoHundredValue = depositFeeData["underTwoHundred"] as? Double else {
            return nil
        }
        guard let underTwoHundredFiftyValue = depositFeeData["underTwoHundredFifty"] as? Double else {
            return nil
        }
        guard let overTwoHundredFiftyValue = depositFeeData["overTwoHundredFifty"] as? Double else {
            return nil
        }

        guard let administratorsValue = snapshotValue["administrators"] as? [String: Bool] else {
            return nil
        }
        guard let usersValue = snapshotValue["users"] as? [String: Bool] else {
            return nil
        }

        name = nameValue
        percentageOnSales = percentageOnSalesValue

        depositFee = DepositFee(underFifty: underFiftyValue,
                                underOneHundred: underOneHundredValue,
                                underOneHundredFifty: underOneHundredFiftyValue,
                                underTwoHundred: underTwoHundredValue,
                                underTwoHundredFifty: underTwoHundredFiftyValue,
                                overTwoHundredFifty: overTwoHundredFiftyValue)

        administrators = administratorsValue
        users = usersValue
    }

}
