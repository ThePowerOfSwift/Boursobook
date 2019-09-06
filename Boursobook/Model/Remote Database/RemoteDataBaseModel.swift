//
//  RemoteDataBaseModel.swift
//  BoursobookProduction
//
//  Created by David Dubez on 19/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

protocol RemoteDataBaseModel {

    // MARK: - Properties
    var uniqueID: String {get}
    var dictionary: [String: Any] {get}

    // MARK: - Initialisation
    init?(dictionary: [String: Any])
}
