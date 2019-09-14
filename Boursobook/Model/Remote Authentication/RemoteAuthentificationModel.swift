//
//  RemoteAuthenticationModel.swift
//  Boursobook
//
//  Created by David Dubez on 05/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

protocol RemoteAuthenticationModel {

    // MARK: - Properties
    var uniqueID: String {get}
    var email: String {get}

}
