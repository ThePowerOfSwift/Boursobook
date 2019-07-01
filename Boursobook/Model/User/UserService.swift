//
//  UserService.swift
//  Boursobook
//
//  Created by David Dubez on 28/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    static var shared = UserService()

    private(set) var users: [User] = []

    private init() {
    }

    func createUser(email: String, password: String, callBack: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .weakPassword:
                        callBack (USError.weakPassword)
                    case .emailAlreadyInUse:
                        callBack (USError.emailAlreadyExist)
                    case .invalidEmail:
                        callBack (USError.wrongEmail)
                    default:
                        callBack (USError.other)
                    }
                }
            }
            if let dataResult = dataResult {
                dataResult.user.sendEmailVerification(completion: { (error) in
                    if let error = error {
                        callBack (error)
                    }
                    callBack(nil)
                })
            }
        }
    }

}

extension UserService {
    /**
    'USError' is the error type returned by UserService.
    It encompasses a few different types of errors, each with
    their own associated reasons.
    
    - weakPassword: return when the password is too weak
     - wrongEmail: return when the email is badly formatted
    */
    enum USError: String, Error {
        case weakPassword = "Please enter a stronger password !"
        case wrongEmail = "Please enter a good email !"
        case emailAlreadyExist = "The email already exist !"
        case other = "Sorry, there is an error !"
    }
}
