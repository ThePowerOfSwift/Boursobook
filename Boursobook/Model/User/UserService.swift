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

    private(set) var userLogIn: User?

    private init() {
    }

    private var handle: AuthStateDidChangeListenerHandle?

    func listenAuthentication(callBack: @escaping (Bool) -> Void) {
        handle = Auth.auth().addStateDidChangeListener({ (_, user) in
            if user == nil {
                self.userLogIn = nil
                callBack(false)
            }
            if let user = user {
                if let userEmail = user.email {
                    self.userLogIn = User(uid: user.uid, email: userEmail)
                }
                callBack(true)
            }
        })
    }

    func stopListenAuthentification() {
        if let handle = handle {
              Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func signInUser(email: String, password: String, callBack: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .invalidEmail:
                        callBack(USError.wrongEmail)
                    case .wrongPassword:
                        callBack(USError.wrongPassword)
                    default:
                        callBack(USError.other)
                    }
                }
            } else {
                callBack(nil)
            }
        }
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
        case wrongPassword = "It's not the good password ! "
        case other = "Sorry, there is an error !"
    }
}
