//
//  RemoteDatabaseRequestMock.swift
//  BoursobookTests
//
//  Created by David Dubez on 21/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
@testable import Boursobook

struct RemoteDatabaseRequestMock: RemoteDatabaseRequest {
    var collection: RemoteDataBase.Collection

    var error: Error?
    var data: [RemoteDataBaseModel]?

    func get<Model>(completionHandler: @escaping (Error?, [Model]?) -> Void)
                        where Model: RemoteDataBaseModel {

                            if let error = error {
                                completionHandler(error, nil)
                            } else {
                                guard let dataModel = data else {
                                    completionHandler(RemoteDataBase.RDBError.other, nil)
                                    return
                                }
                                completionHandler(nil, dataModel as? [Model])
                            }
    }

    func readAndListenData<Model>(condition: RemoteDataBase.Condition,
                                  completionHandler: @escaping (Error?, [Model]?) -> Void)
                                    where Model: RemoteDataBaseModel {

                                        if let error = error {
                                            completionHandler(error, nil)
                                        } else {
                                            guard let dataModel = data else {
                                                completionHandler(RemoteDataBase.RDBError.other, nil)
                                                return
                                            }
                                            completionHandler(nil, dataModel as? [Model])
                                        }
    }

    func readAndListenData<Model>(completionHandler: @escaping (Error?, [Model]?) -> Void)
                                    where Model: RemoteDataBaseModel {

                                        if let error = error {
                                            completionHandler(error, nil)
                                        } else {
                                            guard let dataModel = data else {
                                                completionHandler(RemoteDataBase.RDBError.other, nil)
                                                return
                                            }
                                            completionHandler(nil, dataModel as? [Model])
                                        }
    }

    func create<Model>(model: Model,
                       completionHandler: @escaping (Error?) -> Void)
                            where Model: RemoteDataBaseModel {
                                if let error = error {
                                    completionHandler(error)
                                } else {
                                    completionHandler(nil)
                                }
    }

    func remove<Model>(model: Model,
                       completionHandler: @escaping (Error?) -> Void)
                            where Model: RemoteDataBaseModel {
                                if let error = error {
                                    completionHandler(error)
                                } else {
                                    completionHandler(nil)
                                }
    }

    func stopListen() {

    }
}
