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
    Request to create an "Model" objet in the remote database
     */
    func create<Model: RemoteDataBaseModel>(dataNode: RemoteDataBaseReference.Node, model: Model)
    
    /**
     Request to delete an "Model" objet in the remote database
     */
    func remove<Model: RemoteDataBaseModel>(dataNode: RemoteDataBaseReference.Node, model: Model)
}
