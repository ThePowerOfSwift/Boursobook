//
//  User.swift
//  Boursobook
//
//  Created by David Dubez on 28/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

struct User: RemoteAuthenticationModel {

    var uniqueID: String
    var email: String

    init(email: String, uniqueID: String) {
        self.email = email
        self.uniqueID = uniqueID
    }
}
