//
//  ArticleService.swift
//  Boursobook
//
//  Created by David Dubez on 25/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class ArticleService {
    // Manage the "articles" database on a remote database

    // MARK: - Properties
    private let locationInRemoteDataBase: RemoteDataBaseReference.Node = .article
    private var articleRemoteDataBaseRequest: RemoteDatabaseRequest = FireBaseRequest()

    // MARK: Initialisation
    init() {}
    init(articleRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.articleRemoteDataBaseRequest = articleRemoteDataBaseRequest
    }

    // MARK: - Functions
    func create(article: Article) {
        // Create a article in the remote database
        articleRemoteDataBaseRequest.create(dataNode: locationInRemoteDataBase, model: article)
    }

    func remove(article: Article) {
        // Delete an article in the remote database
        articleRemoteDataBaseRequest.remove(dataNode: locationInRemoteDataBase, model: article)
    }

    func readAndListenData(for purse: Purse, completionHandler: @escaping (Bool, [Article]) -> Void) {
        // Query articles from remote database for one Purse

        articleRemoteDataBaseRequest.readAndListenData(dataNode: locationInRemoteDataBase,
                                                       for: purse) { (done, articlesReaded) in
                                                        completionHandler(done, articlesReaded)
        }
    }

    func stopListen() {
        //Stop the listening of the articles
        articleRemoteDataBaseRequest.stopListen(dataNode: locationInRemoteDataBase)
    }

    func updateSoldedList(list: [String: Bool] ) {
        // Update the field "solded" to true for the list of articles
        var childUpdate = [String: Bool]()

        for (articleCode, _) in list {
            childUpdate.updateValue(true, forKey: "/\(articleCode)/solded/")
        }

        articleRemoteDataBaseRequest.updateChildValues(dataNode: locationInRemoteDataBase, childUpdates: childUpdate)
    }
}
