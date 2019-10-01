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
    var collection: String { get }

    /**
     Request to stop listening "Model" objet in the remote database
     */
    func stopListen()

    // MARK: - READ
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
     Request to get "Model" data from remote database  only once
     */
    func get<Model: RemoteDataBaseModel>(completionHandler: @escaping (Error?, [Model]?) -> Void)

    /**
     Request to get "Model" data from remote database  only once
     with a query for Model that meet a certain condition present in one field
     */
    func get<Model: RemoteDataBaseModel>(conditionInField: RemoteDataBase.Condition,
                                         completionHandler: @escaping (Error?, [Model]?) -> Void)

    // MARK: - CREATE
    /**
     Request to create an "Model" objet in the remote database
     */
    func create<Model: RemoteDataBaseModel>(model: Model,
                                            completionHandler: @escaping (Error?) -> Void)

    /**
        Request to run a transaction for create an object "Model" in the remote database
        with performing action on one objet "Model"
        */
       func createWithOneTransaction<
           FirstModel: RemoteDataBaseModel,
           ResultModel: RemoteDataBaseModel>(model: FirstModel,
                                             block: @escaping (_ firstModelBlock: FirstModel) -> [String: Any],
                                             resultBlock: @escaping () -> ResultModel,
                                             completionHandler: @escaping (Error?) -> Void)

    /**
     Request to run a transaction for create an object "Model" in the remote database
     with performing action on two differents objet "Model"
     */
    func createWithTwoTransactions<
        FirstModel: RemoteDataBaseModel,
        SecondModel: RemoteDataBaseModel,
        ResultModel: RemoteDataBaseModel>(models: (firstModel: FirstModel, secondModel: SecondModel),
                                          blocks: (firstBlock: (_ firstModelBlock: FirstModel) -> [String: Any],
                                                    secondBlock: (_ secondModelBlock: SecondModel) -> [String: Any]),
                                          resultBlock: @escaping () -> ResultModel,
                                          completionHandler: @escaping (Error?) -> Void)

    // MARK: - UPDATE
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

    /**
    Request to run a transaction for update four objects "Model" in the remote database
    with performing action on four differents objet "Model"
    */
     func uptadeWithFourTransactions<
        FirstModel: RemoteDataBaseModel, SecondModel: RemoteDataBaseModel,
        ThirdModel: RemoteDataBaseModel, FourthtModel: RemoteDataBaseModel>(
        modelsA: (firstModel: FirstModel, secondModel: SecondModel),
        modelsB: (thirdModel: ThirdModel, fourthModel: FourthtModel),
        blocksA: (firstBlock: (_ firstModelBlock: FirstModel) -> [String: Any],
                secondBlock: (_ secondModelBlock: SecondModel) -> [String: Any]),
        blocksB: (thirdBlock: (_ thirdModelBlock: ThirdModel) -> [String: Any],
                fourthBlock: (_ fourthModelBlock: FourthtModel) -> [String: Any]),
        completionHandler: @escaping (Error?) -> Void)

    // MARK: - DELETE

    /**
     Request to delete an "Model" objet in the remote database
     */
    func remove<Model: RemoteDataBaseModel>(model: Model,
                                            completionHandler: @escaping (Error?) -> Void)

    /**
     Request to run a transaction for delete an object "Model" in the remote database
     with performing action on one objet "Model"
     */
    func removeWithOneTransaction<
        FirstModel: RemoteDataBaseModel,
        ResultModel: RemoteDataBaseModel>(model: FirstModel,
                                          block: @escaping (_ firstModelBlock: FirstModel) -> [String: Any],
                                          modelToRemove: ResultModel,
                                          completionHandler: @escaping (Error?) -> Void)

    /**
     Request to run a transaction for delete an object "Model" in the remote database
     with performing action on two differents objet "Model"
     */
    func removeWithTwoTransactions<
        FirstModel: RemoteDataBaseModel,
        SecondModel: RemoteDataBaseModel,
        ResultModel: RemoteDataBaseModel>(models: (firstModel: FirstModel, secondModel: SecondModel),
                                          blocks: (firstBlock: (_ firstModelBlock: FirstModel) -> [String: Any],
                                                    secondBlock: (_ secondModelBlock: SecondModel) -> [String: Any]),
                                          modelToRemove: ResultModel,
                                          completionHandler: @escaping (Error?) -> Void)

}
