//
//  FireBaseRequest.swift
//  Boursobook
//
//  Created by David Dubez on 21/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class FireBaseDataRequest: RemoteDatabaseRequest {

    var collection: String

    init(collection: String) {
        self.collection = collection
    }

    // Initialise a query for the collection in FireStone
    var firestoneCollectionReference: CollectionReference {
        return  Firestore.firestore().collection(collection)
    }

    let firestoneDatabase = Firestore.firestore()

    var listeners = [ListenerRegistration]()

    // Query and listen objects "Model" from FireBase in a collection
    func readAndListenData<Model>(completionHandler: @escaping (Error?, [Model]?) -> Void)
                                    where Model: RemoteDataBaseModel {
        let globalListener = firestoneCollectionReference.addSnapshotListener { (modelSnapshot, error) in

            let response: (Error?, [Model]?) = self.manageResponse(querySnapshot: modelSnapshot, queryError: error)
            completionHandler(response.0, response.1)
        }
        listeners.append(globalListener)
    }

    // Query and listen objects "Model" from FireBase in a collection
    // with a query for Model that meet a certain condition present in a array of a field
    func readAndListenData<Model>(conditionInArray: RemoteDataBase.Condition,
                                  completionHandler: @escaping (Error?, [Model]?) -> Void)
                                    where Model: RemoteDataBaseModel {
        let conditionListener = firestoneCollectionReference.whereField(conditionInArray.key,
                                                                        arrayContains: conditionInArray.value)
                    .addSnapshotListener { (modelSnapshot, error) in

                        let response: (Error?, [Model]?) = self.manageResponse(querySnapshot: modelSnapshot,
                                                                               queryError: error)
                        completionHandler(response.0, response.1)
        }
        listeners.append(conditionListener)
    }

    // Query and listen objects "Model" from FireBase in a collection
    // with a query for Model that meet a certain condition
    func readAndListenData<Model>(conditionInField: RemoteDataBase.Condition,
                                  completionHandler: @escaping (Error?, [Model]?) -> Void)
                                    where Model: RemoteDataBaseModel {
            let conditionListener = firestoneCollectionReference.whereField(conditionInField.key,
                                                                            isEqualTo: conditionInField.value)
                .addSnapshotListener { (modelSnapshot, error) in

                    let response: (Error?, [Model]?) = self.manageResponse(querySnapshot: modelSnapshot,
                                                                           queryError: error)
                    completionHandler(response.0, response.1)
            }
            listeners.append(conditionListener)
    }

    // Create objects "Model" in FireBase
    func create<Model>(model: Model,
                       completionHandler: @escaping (Error?) -> Void)
                        where Model: RemoteDataBaseModel {
        firestoneCollectionReference.document(model.uniqueID)
            .setData(model.dictionary) { (error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }

    // Get only Once objects "Model" from FireBase in a collection
    func get<Model>(completionHandler: @escaping (Error?, [Model]?) -> Void)
                        where Model: RemoteDataBaseModel {

        firestoneCollectionReference.getDocuments { (modelSnapshot, error) in

            let response: (Error?, [Model]?) = self.manageResponse(querySnapshot: modelSnapshot, queryError: error)
            completionHandler(response.0, response.1)
        }
    }

    // Run a transaction on two different object "Model" from FireBase in a collection and create one
    func runTransactionForCreate<FirstModel, SecondModel, ResultModel>(
        models: (firstModel: FirstModel, secondModel: SecondModel),
        blocks: (firstBlock: (_ firstModelBlock: FirstModel) -> [String: Any],
                secondBlock: (_ secondModelBlock: SecondModel) -> [String: Any]),
        resultBlock: @escaping () -> ResultModel,
        completionHandler: @escaping (Error?) -> Void)
            where FirstModel: RemoteDataBaseModel, SecondModel: RemoteDataBaseModel, ResultModel: RemoteDataBaseModel {

            let firstModel = models.firstModel
            let secondModel = models.secondModel
            let firstBlock = blocks.firstBlock
            let secondBlock = blocks.secondBlock

            let firstReference = firestoneDatabase.collection(FirstModel.collection).document(firstModel.uniqueID)
            let secondReference = firestoneDatabase.collection(SecondModel.collection).document(secondModel.uniqueID)

            firestoneDatabase.runTransaction({ (transaction, errorPointer) -> Any? in
                let firstDocument: DocumentSnapshot
                let secondDocument: DocumentSnapshot

                do {
                    try firstDocument = transaction.getDocument(firstReference)
                    try secondDocument = transaction.getDocument(secondReference)

                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                guard let firstDocumentModel: FirstModel = firstDocument.data()?.toModel() else {
                    return nil
                }
                guard let secondDocumentModel: SecondModel = secondDocument.data()?.toModel() else {
                    return nil
                }

                let firstData: [String: Any] = firstBlock(firstDocumentModel)
                let secondData: [String: Any] = secondBlock(secondDocumentModel)

                let resultModel = resultBlock()
                let resultReference = self.firestoneDatabase.collection(ResultModel.collection)
                    .document(resultModel.uniqueID)

                let resultData: [String: Any] = resultModel.dictionary

                transaction.updateData(firstData, forDocument: firstReference)
                transaction.updateData(secondData, forDocument: secondReference)
                transaction.setData(resultData, forDocument: resultReference)

                return nil
            }, completion: { (_, error) in
                if let error = error {
                    completionHandler(error)
                } else {
                    completionHandler(nil)
                }
            })
    }

    // Run a transaction for delete an object "Model" from FireBase in a collection
    func runTransactionForRemove<FirstModel, SecondModel, ResultModel>(
        firstModel: FirstModel,
        secondModel: SecondModel,
        firstBlock: @escaping (_ firstModelBlock: FirstModel) -> [String: Any],
        secondBlock: @escaping (_ secondModelBlock: SecondModel) -> [String: Any],
        modelToRemove: ResultModel,
        completionHandler: @escaping (Error?) -> Void)
        where FirstModel: RemoteDataBaseModel, SecondModel: RemoteDataBaseModel, ResultModel: RemoteDataBaseModel {

            let firstReference = firestoneDatabase.collection(FirstModel.collection).document(firstModel.uniqueID)
            let secondReference = firestoneDatabase.collection(SecondModel.collection).document(secondModel.uniqueID)

            firestoneDatabase.runTransaction({ (transaction, errorPointer) -> Any? in
                let firstDocument: DocumentSnapshot
                let secondDocument: DocumentSnapshot

                do {
                    try firstDocument = transaction.getDocument(firstReference)
                    try secondDocument = transaction.getDocument(secondReference)

                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                guard let firstDocumentModel: FirstModel = firstDocument.data()?.toModel() else {
                    return nil
                }
                guard let secondDocumentModel: SecondModel = secondDocument.data()?.toModel() else {
                    return nil
                }

                let firstData: [String: Any] = firstBlock(firstDocumentModel)
                let secondData: [String: Any] = secondBlock(secondDocumentModel)

                let removeReference = self.firestoneDatabase.collection(ResultModel.collection)
                    .document(modelToRemove.uniqueID)

                transaction.updateData(firstData, forDocument: firstReference)
                transaction.updateData(secondData, forDocument: secondReference)
                transaction.deleteDocument(removeReference)

                return nil
            }, completion: { (_, error) in
                if let error = error {
                    completionHandler(error)
                } else {
                    completionHandler(nil)
                }
            })

    }

    // Get only Once objects "Model" from FireBase in a collection
    // with a query for Model that meet a certain condition
    func get<Model>(conditionInField: RemoteDataBase.Condition,
                    completionHandler: @escaping (Error?, [Model]?) -> Void)
                        where Model: RemoteDataBaseModel {
                            firestoneCollectionReference
                                .whereField(conditionInField.key,
                                            isEqualTo: conditionInField.value)
                            .getDocuments { (modelSnapshot, error) in

                                let response: (Error?, [Model]?) = self.manageResponse(querySnapshot: modelSnapshot,
                                                                                       queryError: error)
                                completionHandler(response.0, response.1)
                            }

    }

    // Remove objects "Model" in FireBase
    func remove<Model>(model: Model,
                       completionHandler: @escaping (Error?) -> Void)
                            where Model: RemoteDataBaseModel {
        firestoneCollectionReference.document(model.uniqueID)
            .delete { (error) in
                if let error = error {
                    completionHandler(error)
                } else {
                    completionHandler(nil)
                }
        }
    }

    // Stop listening values changing
    func stopListen() {
        for listener in listeners {
            listener.remove()
        }
    }

    // Update differents childValue of object on FireBase
    func updateValues<Model>(model: Model,
                             updates: [String: Any],
                             completionHandler: @escaping (Error?) -> Void)
                                where Model: RemoteDataBaseModel {
                                    firestoneCollectionReference.document(model.uniqueID)
                                        .updateData(updates) { (error) in
                                            if let error = error {
                                                completionHandler(error)
                                            } else {
                                                completionHandler(nil)
                                            }
                                    }

    }

    // Set differents childValue of object on FireBase
    func setValues<Model>(model: Model,
                          values: [String: Any],
                          completionHandler: @escaping (Error?) -> Void)
                            where Model: RemoteDataBaseModel {

                                firestoneCollectionReference.document(model.uniqueID)
                                    .setData(values) { (error) in
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
}

extension Dictionary where Key == String, Value == Any {
    func toModel<Model: RemoteDataBaseModel>() -> Model? {
        return Model(dictionary: self)
    }
}
