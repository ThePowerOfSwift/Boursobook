//
//  DatabaseRequest.swift
//  Boursobook
//
//  Created by David Dubez on 15/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

// Protocol for manage remote database requests for data
protocol RemoteDatabaseRequest {

    /**
    The collection where seaching documents "Model"
     */
    var collection: RemoteDataBase.Collection { get }

    /**
     Request to read and listen changes of "Model" data from remote database
     with a query for Model that meet a certain condition present in a array of a field
     */
    func readAndListenData<Model: RemoteDataBaseModel>(conditionInArray: RemoteDataBase.Condition,
                                                       completionHandler: @escaping (Error?, [Model]?) -> Void)

    /**
     Request to read and listen changes of "Model" data from remote database
     with a query for Model that meet a certain condition present in one field
     */
    func readAndListenData<Model: RemoteDataBaseModel>(conditionInField: RemoteDataBase.Condition,
                                                       completionHandler: @escaping (Error?, [Model]?) -> Void)

    /**
     Request to read and listen changes of "Model" data from remote databasen
     */
    func readAndListenData<Model: RemoteDataBaseModel>(completionHandler: @escaping (Error?, [Model]?) -> Void)

    /**
     Request to create an "Model" objet in the remote database
     */
    func create<Model: RemoteDataBaseModel>(model: Model,
                                            completionHandler: @escaping (Error?) -> Void)

    /**
     Request to get "Model" data from remote database  only once
     */
    func get<Model: RemoteDataBaseModel>(completionHandler: @escaping (Error?, [Model]?) -> Void)

    /**
     Request to get "Model" data from remote database  only once
     with a query for Model that meet a certain condition present in one field
     */
    func get<Model: RemoteDataBaseModel>(conditionInField: RemoteDataBase.Condition,
                                         completionHandler: @escaping (Error?, [Model]?) -> Void)

    /**
     Request to delete an "Model" objet in the remote database
     */
    func remove<Model: RemoteDataBaseModel>(model: Model,
                                            completionHandler: @escaping (Error?) -> Void)

    /**
     Request to stop listening "Model" objet in the remote database
     */
    func stopListen()

    /**
     Request to update differents values of objets in the remote database
     */
    func updateValues<Model: RemoteDataBaseModel>(model: Model,
                                                  updates: [String: Any],
                                                  completionHandler: @escaping (Error?) -> Void)

    /**
     Request to set differents values of objets in the remote database
     */
    func setValues<Model: RemoteDataBaseModel>(model: Model,
                                               values: [String: Any],
                                               completionHandler: @escaping (Error?) -> Void)

}
