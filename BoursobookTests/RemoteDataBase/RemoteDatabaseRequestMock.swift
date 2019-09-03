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
    func get<Model>(collection: RemoteDataBase.Collection,
                    completionHandler: @escaping (Error?, [Model]?) -> Void)
                        where Model: RemoteDataBaseModel {
        // Write the code
    }

    func readAndListenData<Model>(collection: RemoteDataBase.Collection,
                                  condition: RemoteDataBase.Condition,
                                  completionHandler: @escaping (Error?, [Model]?) -> Void)
                                    where Model: RemoteDataBaseModel {
        // Write the code
    }

    func readAndListenData<Model>(collection: RemoteDataBase.Collection,
                                  completionHandler: @escaping (Error?, [Model]?) -> Void)
                                    where Model: RemoteDataBaseModel {
        // Write the code
    }

    func create<Model>(collection: RemoteDataBase.Collection,
                       model: Model,
                       completionHandler: @escaping (Error?) -> Void)
                            where Model: RemoteDataBaseModel {
        // Write the code
    }

}
