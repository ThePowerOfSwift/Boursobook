//
//  UserAPI.swift
//  Boursobook
//
//  Created by David Dubez on 09/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class UserAPI {
    // Manage the acces of "users" data

    // MARK: Properties
    private var userRemoteDataBaseRequest: RemoteDatabaseRequest = FireBaseDataRequest(collection: .user)

    // MARK: Initialisation
    init() {}
    init(userRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.userRemoteDataBaseRequest = userRemoteDataBaseRequest
    }

    // MARK: Functions
    func readUsers(completionHandler: @escaping (Error?, [User]?) -> Void) {
        // Query all the users

        userRemoteDataBaseRequest.get { (error, loadedUsers: [User]?) in
            if let error = error {
                completionHandler(error, nil)
            } else {
                guard let list = loadedUsers else {
                    completionHandler(UAPIError.other, nil)
                    return
                }
                completionHandler(nil, list)
            }
        }
    }

    func save(user: User?, completionHandler: @escaping (Error?) -> Void) {
        guard let user = user else {
            completionHandler(UAPIError.other)
            return
        }
        userRemoteDataBaseRequest.create(model: user) { (error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }

}

extension UserAPI {
    /**
     'UAPIError' is the error type returned by UserAPI.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     */
    enum UAPIError: String, Error {
        case other = "Sorry, there is an error !"
    }
}

