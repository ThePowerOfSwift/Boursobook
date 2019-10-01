//
//  FireBaseDataRequest+extensionUD.swift
//  Boursobook
//
//  Created by David Dubez on 30/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

// MARK: - UPDATE
extension FireBaseDataRequest {
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

    // Run a transaction for update four objects "Model" from FireBase in a collection
    // with performing action on four differents objet "Model"
     func uptadeWithFourTransactions<FirstModel, SecondModel, ThirdModel, FourthtModel>(
        modelsA: (firstModel: FirstModel, secondModel: SecondModel),
        modelsB: (thirdModel: ThirdModel, fourthModel: FourthtModel),
        blocksA: (firstBlock: (_ firstModelBlock: FirstModel) -> [String: Any],
                secondBlock: (_ secondModelBlock: SecondModel) -> [String: Any]),
        blocksB: (thirdBlock: (_ thirdModelBlock: ThirdModel) -> [String: Any],
                fourthBlock: (_ fourthModelBlock: FourthtModel) -> [String: Any]),
        completionHandler: @escaping (Error?) -> Void)
        where FirstModel: RemoteDataBaseModel, SecondModel: RemoteDataBaseModel,
                ThirdModel: RemoteDataBaseModel, FourthtModel: RemoteDataBaseModel {

            let firstModel = modelsA.firstModel, secondModel = modelsA.secondModel
            let thirdModel = modelsB.thirdModel, fourthModel = modelsB.fourthModel

            let firstBlock = blocksA.firstBlock, secondBlock = blocksA.secondBlock
            let thirdBlock = blocksB.thirdBlock, fourthBlock = blocksB.fourthBlock

            let firstReference = firestoneDatabase.collection(FirstModel.collection).document(firstModel.uniqueID)
            let secondReference = firestoneDatabase.collection(SecondModel.collection).document(secondModel.uniqueID)
            let thirdReference = firestoneDatabase.collection(ThirdModel.collection).document(thirdModel.uniqueID)
            let fourthReference = firestoneDatabase.collection(FourthtModel.collection).document(fourthModel.uniqueID)

            firestoneDatabase.runTransaction({ (transaction, errorPointer) -> Any? in
                let firstDocument: DocumentSnapshot, secondDocument: DocumentSnapshot
                let thirdDocument: DocumentSnapshot, fourthDocument: DocumentSnapshot

                do {
                    try firstDocument = transaction.getDocument(firstReference)
                    try secondDocument = transaction.getDocument(secondReference)
                    try thirdDocument = transaction.getDocument(thirdReference)
                    try fourthDocument = transaction.getDocument(fourthReference)

                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                guard
                    let firstDocumentModel: FirstModel = firstDocument.data()?.toModel(),
                    let secondDocumentModel: SecondModel = secondDocument.data()?.toModel(),
                    let thirdDocumentModel: ThirdModel = thirdDocument.data()?.toModel(),
                    let fourthDocumentModel: FourthtModel = fourthDocument.data()?.toModel()
                else { return nil }

                let firstData: [String: Any] = firstBlock(firstDocumentModel)
                let secondData: [String: Any] = secondBlock(secondDocumentModel)
                let thirdData: [String: Any] = thirdBlock(thirdDocumentModel)
                let fourthData: [String: Any] = fourthBlock(fourthDocumentModel)

                transaction.updateData(firstData, forDocument: firstReference)
                transaction.updateData(secondData, forDocument: secondReference)
                transaction.updateData(thirdData, forDocument: thirdReference)
                transaction.updateData(fourthData, forDocument: fourthReference)

                return nil

            }, completion: { (_, error) in
                if let error = error {
                    completionHandler(error)
                } else {
                    completionHandler(nil)
                }
            })

    }
}

// MARK: - DELETE
extension FireBaseDataRequest {
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

    // Run a transaction for create an object "Model" from FireBase in a collection
    // with performing action on one objet "Model"
    func removeWithOneTransaction<FirstModel, ResultModel>(
       model: FirstModel,
       block: @escaping (FirstModel) -> [String: Any],
       modelToRemove: ResultModel,
       completionHandler: @escaping (Error?) -> Void)
               where FirstModel: RemoteDataBaseModel, ResultModel: RemoteDataBaseModel {

          let reference = firestoneDatabase.collection(FirstModel.collection).document(model.uniqueID)

          firestoneDatabase.runTransaction({ (transaction, errorPointer) -> Any? in
              let firstDocument: DocumentSnapshot

              do {
                  try firstDocument = transaction.getDocument(reference)

              } catch let fetchError as NSError {
                  errorPointer?.pointee = fetchError
                  return nil
              }
              guard let firstDocumentModel: FirstModel = firstDocument.data()?.toModel() else {
                  return nil
              }

              let firstData: [String: Any] = block(firstDocumentModel)

              let removeReference = self.firestoneDatabase.collection(ResultModel.collection)
                  .document(modelToRemove.uniqueID)

              transaction.updateData(firstData, forDocument: reference)
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

    // Run a transaction for delete an object "Model" from FireBase in a collection
       // with performing action on two differents objet "Model"
       func removeWithTwoTransactions<FirstModel, SecondModel, ResultModel>(
           models: (firstModel: FirstModel, secondModel: SecondModel),
           blocks: (firstBlock: (_ firstModelBlock: FirstModel) -> [String: Any],
                   secondBlock: (_ secondModelBlock: SecondModel) -> [String: Any]),
           modelToRemove: ResultModel,
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

}
