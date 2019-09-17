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
    private var transactionRemoteDataBaseRequest: RemoteDatabaseRequest = FireBaseDataRequest(collection: Transaction.collection)

    // MARK: Initialisation
    init() {}
    init(transactionRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.transactionRemoteDataBaseRequest = transactionRemoteDataBaseRequest
   }

    // MARK: Function
    func create(transaction: Transaction) {
        // Create a transaction in the remote database
        //FIXME: a implementer
    }

    func readAndListenData(for purse: Purse, completionHandler: @escaping (Bool, [Transaction]) -> Void) {
        // Query transactions from remote database for one Purse

    //FIXME: a implementer
    }

    func stopListen() {
        //Stop the listening of the transactions
        //FIXME: a implementer
    }

    func remove(transaction: Transaction) {
        // Delete a transaction in the remote database
        //FIXME: a implementer
    }
}
