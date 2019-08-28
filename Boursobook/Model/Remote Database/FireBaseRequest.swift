//
//  FireBaseRequest.swift
//  Boursobook
//
//  Created by David Dubez on 21/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

struct FireBaseRequest: RemoteDatabaseRequest {

    // Create objects "Model" in FireBase
    func create<Model>(dataNode: RemoteDataBaseReference.Node, model: Model) where Model: RemoteDataBaseModel {
        let reference = Database.database().reference(withPath: dataNode.rawValue)
        let transactionRef = reference.child(model.uniqueID)
        let values = model.setValuesForRemoteDataBase()

        transactionRef.setValue(values)
    }

    // Query objects "Model" from FireBase
    func readAndListenData<Model: RemoteDataBaseModel>(dataNode: RemoteDataBaseReference.Node,
                                                       completionHandler: @escaping (Bool, [Model]) -> Void) {

        let reference = Database.database().reference(withPath: dataNode.rawValue)

        reference.observe(.value) { snapshot in
            var newModel: [Model] = []

            for child in snapshot.children {
                if let childValue = child as? DataSnapshot {
                    if let model = Model(snapshot: childValue) {
                        newModel.append(model)
                    }
                }
            }
            completionHandler(true, newModel)
        }
    }

    // Query objects "Model" from FireBase for a Purse
    func readAndListenData<Model: RemoteDataBaseModel>(dataNode: RemoteDataBaseReference.Node,
                                                       for purse: Purse,
                                                       completionHandler: @escaping (Bool, [Model]) -> Void) {

        let reference = Database.database().reference(withPath: dataNode.rawValue)

        reference.queryOrdered(byChild: "purseName").queryEqual(toValue: purse.name).observe(.value) { snapshot in
            var newModel: [Model] = []

            for child in snapshot.children {
                if let childValue = child as? DataSnapshot {
                    if let model = Model(snapshot: childValue) {
                        newModel.append(model)
                    }
                }
            }
            completionHandler(true, newModel)
        }
    }

    //Stop the listening of the transactions
    func stopListen(dataNode: RemoteDataBaseReference.Node) {
        let reference = Database.database().reference(withPath: dataNode.rawValue)
        reference.removeAllObservers()
    }

    // Delete object "Model" from FireBase for a Purse
    func remove<Model: RemoteDataBaseModel>(dataNode: RemoteDataBaseReference.Node, model: Model) {
        let reference = Database.database().reference(withPath: dataNode.rawValue)
        reference.child(model.uniqueID).removeValue()
    }

    // Update differents childValue of object on FireBase
    func updateChildValues(dataNode: RemoteDataBaseReference.Node, childUpdates: [String: Any]) {
        let reference = Database.database().reference(withPath: dataNode.rawValue)
        reference.updateChildValues(childUpdates)
    }

}
