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

    // Initialise instance for FireStone
    let firestoneDatabase = Firestore.firestore()

    // Query and listen objects "Model" from FireBase in a collection
    func readAndListenData<Model>(collection: RemoteDataBase.Collection,
                                  completionHandler: @escaping (Error?, [Model]?) -> Void)
                                    where Model: RemoteDataBaseModel {
        firestoneDatabase.collection(collection.rawValue).addSnapshotListener { (modelSnapshot, error) in

            let response: (Error?, [Model]?) = self.manageResponse(querySnapshot: modelSnapshot, queryError: error)
            completionHandler(response.0, response.1)
        }
    }

    // Query and listen objects "Model" from FireBase in a collection
    // with a query for Model that meet a certain condition
    func readAndListenData<Model>(collection: RemoteDataBase.Collection,
                                  condition: RemoteDataBase.Condition,
                                  completionHandler: @escaping (Error?, [Model]?) -> Void)
                                    where Model: RemoteDataBaseModel {
        firestoneDatabase.collection(collection.rawValue)
                    .whereField(condition.key, isEqualTo: condition.value)
                    .addSnapshotListener { (modelSnapshot, error) in

                        let response: (Error?, [Model]?) = self.manageResponse(querySnapshot: modelSnapshot,
                                                                               queryError: error)
                        completionHandler(response.0, response.1)
        }
    }

    // Create objects "Model" in FireBase
    func create<Model>(collection: RemoteDataBase.Collection,
                       model: Model,
                       completionHandler: @escaping (Error?) -> Void)
                        where Model: RemoteDataBaseModel {
        firestoneDatabase.collection(collection.rawValue).document(model.uniqueID)
            .setData(model.dictionary) { (error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }

    // Get only Once objects "Model" from FireBase in a collection
    func get<Model>(collection: RemoteDataBase.Collection,
                    completionHandler: @escaping (Error?, [Model]?) -> Void)
                        where Model: RemoteDataBaseModel {
        firestoneDatabase.collection(collection.rawValue).getDocuments { (modelSnapshot, error) in

            let response: (Error?, [Model]?) = self.manageResponse(querySnapshot: modelSnapshot, queryError: error)
            completionHandler(response.0, response.1)
        }
    }

    // Create objects "Model" in FireBase
    func remove<Model>(collection: RemoteDataBase.Collection,
                       model: Model,
                       completionHandler: @escaping (Error?) -> Void)
                            where Model: RemoteDataBaseModel {
        firestoneDatabase.collection(collection.rawValue).document(model.uniqueID)
            .delete { (error) in
                if let error = error {
                    completionHandler(error)
                } else {
                    completionHandler(nil)
                }
        }
    }

    // manage the response of firebase with a query of array of document
    private func manageResponse<Model: RemoteDataBaseModel>(querySnapshot: QuerySnapshot?,
                                                            queryError: Error?) -> (Error?, [Model]?) {
        if let error = queryError {
            return(error, nil)
        } else {
            guard let modelSnapshot = querySnapshot else {
                return(RemoteDataBase.RDBError.other, nil)
            }
            let modelValues = modelSnapshot.documents.map({ (document) -> Model? in
                if let model = Model(dictionary: document.data()) {
                    return model
                } else {
                    return nil
                }
            })
            let models = modelValues.compactMap { $0 }
            return(nil, models)
        }
    }

    //FIXME: supprimer code en dessous
/*
 

    // Query objects "Model" from FireBase
    func readAndListenData<Model: RemoteDataBaseModel>(dataNode: RemoteDataBase.collection,
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
    func readAndListenData<Model: RemoteDataBaseModel>(dataNode: RemoteDataBase.collection,
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
    func stopListen(dataNode: RemoteDataBase.collection) {
        let reference = Database.database().reference(withPath: dataNode.rawValue)
        reference.removeAllObservers()
    }

    // Delete object "Model" from FireBase for a Purse
    func remove<Model: RemoteDataBaseModel>(dataNode: RemoteDataBase.collection, model: Model) {
        let reference = Database.database().reference(withPath: dataNode.rawValue)
        reference.child(model.uniqueID).removeValue()
    }

    // Update differents childValue of object on FireBase
    func updateChildValues(dataNode: RemoteDataBase.collection, childUpdates: [String: Any]) {
        let reference = Database.database().reference(withPath: dataNode.rawValue)
        reference.updateChildValues(childUpdates)
    }
 */

}
