//
//  RemoteDatabaseReference.swift
//  BoursobookProduction
//
//  Created by David Dubez on 19/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

struct RemoteDataBase {
    // Elements for acces to remote database

    enum Collection: String {
        case transaction = "transactions"
        case article = "articles"
        case purse = "purses"
        case seller = "sellers"
    }

    // Elements for performing query
    struct Condition {
        var key: String
        var value: Any
    }

    /**
     'RDBError' is the error type returned by RemoteDataBase.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     */
    enum RDBError: String, Error {
        case other = "Sorry, there is an error !"
        case cantInitModel = "Unable to intialize type !"
    }

}
