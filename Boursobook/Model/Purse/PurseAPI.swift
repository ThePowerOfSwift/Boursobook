//
//  PurseAPI.swift
//  Boursobook
//
//  Created by David Dubez on 31/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class PurseAPI {
    // Manage the acces of "purses" data

    // MARK: Properties
    private let remoteDataBaseCollection: RemoteDataBase.Collection = .purse
    private var purseRemoteDataBaseRequest: RemoteDatabaseRequest = FireBaseRequest()

    // MARK: Initialisation
    init() {}
    init(purseRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.purseRemoteDataBaseRequest = purseRemoteDataBaseRequest
    }

    // MARK: Functions
    func loadPursesFor(user: User?, completionHandler: @escaping (Error?, [Purse]?) -> Void) {
        // Query purses from database for a user

        guard let user = user else {
            completionHandler(PAPIError.other, nil)
            return
        }
             let condition = RemoteDataBase.Condition(key: "users", value: [user.email: user.uid])

        purseRemoteDataBaseRequest.readAndListenData(collection: remoteDataBaseCollection,
                                                     condition: condition) { (error, loadedPurses: [Purse]? ) in
            if let error = error {
                completionHandler(error, nil)
            } else {
                guard let loadedPurses = loadedPurses else {
                    completionHandler(PAPIError.other, nil)
                    return
                }
                completionHandler(nil, loadedPurses)
            }
        }
    }

    func getExistingPurseName(completionHandler: @escaping (Error?, [String]?) -> Void) {
        purseRemoteDataBaseRequest.get(collection: remoteDataBaseCollection) { (error, loadedPurses: [Purse]?) in
            var purseNameList = [String]()

            if let error = error {
                completionHandler(error, nil)
            } else {
                guard let loadedPurses = loadedPurses else {
                    completionHandler(PAPIError.other, nil)
                    return
                }
                for purse in loadedPurses {
                    purseNameList.append(purse.name)
                }
                completionHandler(nil, purseNameList)
            }
        }
    }

    func createPurse(name: String, user: User?, completionHandler: @escaping (Error?, Purse?) -> Void) {
        guard let user = user else {
            completionHandler(PAPIError.other, nil)
            return
        }
        let uniqueID = name + " " + UUID().description
        let newPurse = Purse(name: name, uniqueID: uniqueID,
                             administrators: [user.email: true], users: [user.email: user.uid])
        purseRemoteDataBaseRequest.create(collection: remoteDataBaseCollection, model: newPurse) { (error) in
            if let error = error {
                completionHandler(error, nil)
            } else {
                completionHandler(nil, newPurse)
            }
        }
    }

    func removePurse(purse: Purse, completionHandler: @escaping (Error?) -> Void) {

        purseRemoteDataBaseRequest.remove(collection: remoteDataBaseCollection,
                                          model: purse,
                                          completionHandler: { (error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        })
    }

    func stopListen() {
        purseRemoteDataBaseRequest.stopListen(collection: remoteDataBaseCollection)
    }
}

extension PurseAPI {
    /**
     'PAPIError' is the error type returned by PurseAPI.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     */
    enum PAPIError: String, Error {
        case other = "Sorry, there is an error !"
    }
}
