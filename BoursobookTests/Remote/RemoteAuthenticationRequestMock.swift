//
//  RemoteAuthenticationRequestMock.swift
//  BoursobookTests
//
//  Created by David Dubez on 06/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
@testable import Boursobook

struct RemoteAuthenticationRequestMock: RemoteAuthenticationRequest {

    var error: Error?
    var data: RemoteAuthenticationModel?

    func signInUser<Model>(email: String, password: String,
                           callBack: @escaping (Error?, Model?) -> Void)
                                where Model: RemoteAuthenticationModel {
        if let error = error {
            callBack(error, nil)
        } else {
            guard let dataModel = data else {
                callBack(nil, nil)
                return
            }
            callBack(nil, dataModel as? Model)
        }
    }

    func createUser<Model>(email: String, password: String,
                           callBack: @escaping (Error?, Model?) -> Void)
                                where Model: RemoteAuthenticationModel {
        if let error = error {
            callBack(error, nil)
        } else {
            guard let dataModel = data else {
                callBack(nil, nil)
                return
            }
            callBack(nil, dataModel as? Model)
        }
    }

    func signOut(callBack: @escaping (Error?) -> Void) {
        if let error = error {
            callBack(error)
        } else {
            callBack(nil)
        }
    }
}
