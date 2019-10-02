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
    var collection: String

    func createWithOneTransaction<FirstModel, ResultModel>(
        model: FirstModel,
        block: @escaping (FirstModel) -> [String: Any],
        resultBlock: @escaping () -> ResultModel,
        completionHandler: @escaping (Error?) -> Void)
            where FirstModel: RemoteDataBaseModel, ResultModel: RemoteDataBaseModel {
        //FIXME: A implementer
    }

    func createWithTwoTransactions<FirstModel, SecondModel, ResultModel>(
        models: (firstModel: FirstModel, secondModel: SecondModel),
        blocks: (firstBlock: (FirstModel) -> [String: Any], secondBlock: (SecondModel) -> [String: Any]),
        resultBlock: @escaping () -> ResultModel,
        completionHandler: @escaping (Error?) -> Void)
            where FirstModel: RemoteDataBaseModel, SecondModel: RemoteDataBaseModel,
            ResultModel: RemoteDataBaseModel {
        //FIXME: A implementer
    }

    func uptadeWithFourTransactions<FirstModel, SecondModel, ThirdModel, FourthtModel>(
        modelsA: (firstModel: FirstModel, secondModel: SecondModel),
        modelsB: (thirdModel: ThirdModel, fourthModel: FourthtModel),
        blocksA: (firstBlock: (FirstModel) -> [String: Any], secondBlock: (SecondModel) -> [String: Any]),
        blocksB: (thirdBlock: (ThirdModel) -> [String: Any], fourthBlock: (FourthtModel) -> [String: Any]),
        completionHandler: @escaping (Error?) -> Void)
            where FirstModel: RemoteDataBaseModel, SecondModel: RemoteDataBaseModel,
            ThirdModel: RemoteDataBaseModel, FourthtModel: RemoteDataBaseModel {
        //FIXME: A implementer
    }

    func removeWithOneTransaction<FirstModel, ResultModel>(
        model: FirstModel,
        block: @escaping (FirstModel) -> [String: Any],
        modelToRemove: ResultModel, completionHandler: @escaping (Error?) -> Void)
            where FirstModel: RemoteDataBaseModel, ResultModel: RemoteDataBaseModel {
        //FIXME: A implementer
    }

    func removeWithTwoTransactions<FirstModel, SecondModel, ResultModel>(
        models: (firstModel: FirstModel, secondModel: SecondModel),
        blocks: (firstBlock: (FirstModel) -> [String: Any], secondBlock: (SecondModel) -> [String: Any]),
        modelToRemove: ResultModel,
        completionHandler: @escaping (Error?) -> Void)
            where FirstModel: RemoteDataBaseModel, SecondModel: RemoteDataBaseModel,
            ResultModel: RemoteDataBaseModel {
        //FIXME: A implementer
    }

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

    func get<Model>(conditionInField: RemoteDataBase.Condition,
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

    func readAndListenData<Model>(conditionInArray condition: RemoteDataBase.Condition,
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

    func readAndListenData<Model>(conditionInField condition: RemoteDataBase.Condition,
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

    func updateValues<Model>(model: Model,
                             updates: [String: Any],
                             completionHandler: @escaping (Error?) -> Void)
                                where Model: RemoteDataBaseModel {
                                    if let error = error {
                                        completionHandler(error)
                                    } else {
                                        completionHandler(nil)
                                    }
    }

    func setValues<Model>(model: Model,
                          values: [String: Any],
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
