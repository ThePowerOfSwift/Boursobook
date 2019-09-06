//
//  FireBaseAuthenticationRequest.swift
//  Boursobook
//
//  Created by David Dubez on 05/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

struct FireBaseAuthenticationRequest: RemoteAuthenticationRequest {

    // Sign in an user with FireBase authentication
    func signInUser<Model>(email: String,
                           password: String,
                           callBack: @escaping (Error?, Model?) -> Void) where Model: RemoteAuthenticationModel {

        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .invalidEmail:
                        callBack(RemoteAuthentication.RAError.wrongEmail, nil)
                    case .wrongPassword:
                        callBack(RemoteAuthentication.RAError.wrongPassword, nil)
                    default:
                        callBack(RemoteAuthentication.RAError.other, nil)
                    }
                }
            } else if let authDataResultValue = authDataResult {
                guard let userEmailValue = authDataResultValue.user.email else {
                    return
                }
                let userLogIn = Model(email: userEmailValue, uniqueID: authDataResultValue.user.uid)

                callBack(nil, userLogIn)
            }
        }
    }
    
    // Create an user with FireBase authentication and send an email
    func createUser<Model>(email: String, password: String, callBack: @escaping (Error?, Model?) -> Void) where Model : RemoteAuthenticationModel {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .weakPassword:
                        callBack (RemoteAuthentication.RAError.weakPassword, nil)
                    case .emailAlreadyInUse:
                        callBack (RemoteAuthentication.RAError.emailAlreadyExist, nil)
                    case .invalidEmail:
                        callBack (RemoteAuthentication.RAError.wrongEmail, nil)
                    default:
                        callBack (RemoteAuthentication.RAError.other, nil)
                    }
                }
            }
            if let authDataResultValue = authDataResult {
                authDataResultValue.user.sendEmailVerification(completion: { (error) in
                    if error != nil {
                        callBack (RemoteAuthentication.RAError.problemSendEmail, nil)
                    }
                    guard let userEmailValue = authDataResultValue.user.email else {
                        return
                    }
                    let userLogIn = Model(email: userEmailValue, uniqueID: authDataResultValue.user.uid)

                    callBack(nil, userLogIn)
                })
            }
        }
    }

    // Log out the user with FireBase authentication
    func signOut(callBack: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            callBack(signOutError)
        }
        callBack(nil)
    }
}
