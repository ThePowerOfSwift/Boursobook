//
//  DatabaseRequest.swift
//  Boursobook
//
//  Created by David Dubez on 15/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

// Protocol for manage remote database requests
protocol RemoteDatabaseRequest {

    /**
     Request to read and listen changes of "Model" data from remote database in a collection
     with a query for Model that meet a certain condition
     */
    func readAndListenData<Model: RemoteDataBaseModel>(collection: RemoteDataBase.Collection,
                                                       condition: RemoteDataBase.Condition,
                                                       completionHandler: @escaping (Error?, [Model]?) -> Void)

    /**
     Request to read and listen changes of "Model" data from remote database in a collection
     */
    func readAndListenData<Model: RemoteDataBaseModel>(collection: RemoteDataBase.Collection,
                                                       completionHandler: @escaping (Error?, [Model]?) -> Void)

    /**
     Request to create an "Model" objet in the remote database
     */
    func create<Model: RemoteDataBaseModel>(collection: RemoteDataBase.Collection,
                                            model: Model,
                                            completionHandler: @escaping (Error?) -> Void)

    /**
     Request to get "Model" data from remote database in a collection only once
     */
    func get<Model: RemoteDataBaseModel>(collection: RemoteDataBase.Collection,
                                         completionHandler: @escaping (Error?, [Model]?) -> Void)

/*
    
    /**
    Request to read and listen "Model" data from remote filtered by purse
     */
    func readAndListenData<Model: RemoteDataBaseModel>(dataNode: RemoteDataBaseReference.Node,
                                                       for purse: Purse,
                                                       completionHandler: @escaping (Bool, [Model]) -> Void)

    /**
     Request to stop listening "Model" objet in the remote database
     */
    func stopListen(dataNode: RemoteDataBaseReference.Node)

   
    /**
     Request to delete an "Model" objet in the remote database
     */
    func remove<Model: RemoteDataBaseModel>(dataNode: RemoteDataBaseReference.Node, model: Model)

    /**
     Request to update differents child Value of objets in the remote database
     */
    func updateChildValues(dataNode: RemoteDataBaseReference.Node, childUpdates: [String: Any])

 */
}
