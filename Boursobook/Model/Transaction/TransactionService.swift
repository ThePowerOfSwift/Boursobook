//
//  TransactionService.swift
//  Boursobook
//
//  Created by David Dubez on 10/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class TransactionService {
    // Manage the "transactions" database on a remote database

    // MARK: Properties
    private let locationInRemoteDataBase: RemoteDataBaseReference.Node = .transaction
    private var transactionRemoteDataBaseRequest: RemoteDatabaseRequest = FireBaseRequest()

    // MARK: Initialisation
    init() {}
    init(transactionRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.transactionRemoteDataBaseRequest = transactionRemoteDataBaseRequest
   }

    // MARK: Function
    func create(transaction: Transaction) {
        // Create a transaction in the remote database
        transactionRemoteDataBaseRequest.create(dataNode: locationInRemoteDataBase, model: transaction)
    }

    func readAndListenData(for purse: Purse, completionHandler: @escaping (Bool, [Transaction]) -> Void) {
        // Query transactions from remote database for one Purse

    transactionRemoteDataBaseRequest.readAndListenData(dataNode: locationInRemoteDataBase,
                                                           for: purse) { (done, transactionReaded) in
            completionHandler(done, transactionReaded)
        }
    }

    func stopListen() {
        //Stop the listening of the transactions
        transactionRemoteDataBaseRequest.stopListen(dataNode: locationInRemoteDataBase)
    }

    func remove(transaction: Transaction) {
        // Delete a transaction in the remote database
        transactionRemoteDataBaseRequest.remove(dataNode: locationInRemoteDataBase, model: transaction)
    }
}
