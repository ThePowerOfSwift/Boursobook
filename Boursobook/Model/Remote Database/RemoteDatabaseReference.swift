//
//  RemoteDatabaseReference.swift
//  BoursobookProduction
//
//  Created by David Dubez on 19/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

struct RemoteDataBaseReference {
    /// the node where elements are store
    enum Node: String {
        case transaction = "transactions"
        case article = "articles"
        case purse = "purses"
    }
}
