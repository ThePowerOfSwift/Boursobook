//
//  FireBaseRequest.swift
//  Boursobook
//
//  Created by David Dubez on 21/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

struct FireBaseDataRequest: RemoteDatabaseRequest {

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
            let models: [Model] = modelSnapshot.documents.compactMap { $0.data().toModel() }
            return(nil, models)
        }
    }

    func stopListen(collection: RemoteDataBase.Collection) {
        let reference = firestoneDatabase.collection(collection.rawValue).addSnapshotListener { (_, _) in
        }
        reference.remove()
    }

    //FIXME: supprimer code en dessous
/*
 
    // Update differents childValue of object on FireBase
    func updateChildValues(dataNode: RemoteDataBase.collection, childUpdates: [String: Any]) {
        let reference = Database.database().reference(withPath: dataNode.rawValue)
        reference.updateChildValues(childUpdates)
    }
 */

}

extension Dictionary where Key == String, Value == Any {
    func toModel<Model: RemoteDataBaseModel>() -> Model? {
        return Model(dictionary: self)
    }
}
