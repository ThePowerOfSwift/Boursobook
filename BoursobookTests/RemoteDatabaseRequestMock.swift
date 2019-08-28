//
//  RemoteDatabaseRequestMock.swift
//  BoursobookTests
//
//  Created by David Dubez on 21/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase
@testable import Boursobook

struct RemoteDatabaseRequestMock: RemoteDatabaseRequest {
    func readAndListenData<Model>(dataNode: RemoteDataBaseReference.Node,
                                  completionHandler: @escaping (Bool, [Model]) -> Void)
        where Model: RemoteDataBaseModel {
        //FIXME: a implementer
    }
    func updateChildValues(dataNode: RemoteDataBaseReference.Node, childUpdates: [String: Any]) {
        //FIXME: a implementer
    }

    func updateChildValues(dataNode: RemoteDataBaseReference.Node, childUpdates: [String: Bool]) {
        //FIXME: a implementer - pourquoi doublon ?
    }

    var snapshot: DataSnapshot

    // Create objects "Model" in FireBase
    func create<Model>(dataNode: RemoteDataBaseReference.Node, model: Model) where Model: RemoteDataBaseModel {
    }

    // Query objects "Model" from FireBase for a Purse
    func readAndListenData<Model: RemoteDataBaseModel>(dataNode: RemoteDataBaseReference.Node,
                                                       for purse: Purse,
                                                       completionHandler: @escaping (Bool, [Model]) -> Void) {
        var returnedModels: [Model] = []

        if let model = Model(snapshot: snapshot) {
            returnedModels.append(model)
        }

        completionHandler(true, returnedModels)
    }

    //Stop the listening
    func stopListen(dataNode: RemoteDataBaseReference.Node) {
    }

    // Delete object "Model" from FireBase for a Purse
    func remove<Model>(dataNode: RemoteDataBaseReference.Node, model: Model) where Model: RemoteDataBaseModel {
    }

}
