//
//  RemoteDataBaseModel.swift
//  BoursobookProduction
//
//  Created by David Dubez on 19/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

protocol RemoteDataBaseModel {
    // MARK: - Properties
    var uniqueID: String {get}

    // MARK: - Initialisation
    init?(snapshot: DataSnapshot)

    func setValuesForRemoteDataBase() -> [String: Any]
}
