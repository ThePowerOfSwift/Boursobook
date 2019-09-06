//
//  RemoteAuthentication.swift
//  Boursobook
//
//  Created by David Dubez on 06/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

struct RemoteAuthentication {

    /**
     'RAError' is the error type returned by RemoteAuthentication.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     */
    enum RAError: String, Error {
        case weakPassword = "Please enter a stronger password !"
        case wrongEmail = "Please enter a good email !"
        case emailAlreadyExist = "The email already exist !"
        case wrongPassword = "It's not the good password ! "
        case problemSendEmail = "There was a problem in sending email ! "
        case other = "Sorry, there is an error !"
    }

}
