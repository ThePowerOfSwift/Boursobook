//
//  User.swift
//  Boursobook
//
//  Created by David Dubez on 28/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

struct User: RemoteAuthenticationModel, RemoteDataBaseModel {

    var uniqueID: String
    var email: String

    init(email: String, uniqueID: String) {
        self.email = email
        self.uniqueID = uniqueID
    }

    init?(dictionary: [String: Any]) {
        guard let uniqueIDValue = dictionary["uniqueID"] as? String,
            let emailValue = dictionary["email"] as? String else {
        return nil
        }

        uniqueID = uniqueIDValue
        email = emailValue
    }

    var dictionary: [String: Any] {
        let values: [String: Any] = ["uniqueID": uniqueID,
                                     "email": email]
        return values
    }
}
