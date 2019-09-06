//
//  RemoteAuthenticationRequest.swift
//  Boursobook
//
//  Created by David Dubez on 05/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

// Protocol for manage remote Authentication requests
protocol RemoteAuthenticationRequest {
    
    /**
     Request to sign in user with an email and a password
     */
    func signInUser<Model: RemoteAuthenticationModel>(email: String,
                                                      password: String,
                                                      callBack: @escaping (Error?, Model?) -> Void)

    /**
     Request to create an user with an email and a password
     */
    func createUser<Model: RemoteAuthenticationModel>(email: String,
                                                      password: String,
                                                      callBack: @escaping (Error?, Model?) -> Void)

    /**
     Request to sign out the user log in
     */
    func signOut(callBack: @escaping (Error?) -> Void)

}
