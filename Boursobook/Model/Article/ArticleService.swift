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
    private let locationInRemoteDataBase: RemoteDataBase.Collection = .article
    private var articleRemoteDataBaseRequest: RemoteDatabaseRequest = FireBaseDataRequest()

    // MARK: Initialisation
    init() {}
    init(articleRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.articleRemoteDataBaseRequest = articleRemoteDataBaseRequest
    }

    // MARK: - Functions
    func create(article: Article) {
        // Create a article in the remote database

        //FIXME: a implementer
//        articleRemoteDataBaseRequest.create(dataNode: locationInRemoteDataBase, model: article)
    }

    func remove(article: Article) {
        // Delete an article in the remote database

        //FIXME: a implementer
//        articleRemoteDataBaseRequest.remove(dataNode: locationInRemoteDataBase, model: article)
    }

    func readAndListenData(for purse: Purse, completionHandler: @escaping (Bool, [Article]) -> Void) {
        // Query articles from remote database for one Purse

       //FIXME: a implementer
//        articleRemoteDataBaseRequest.readAndListenData(dataNode: locationInRemoteDataBase,
//                                                       for: purse) { (done, articlesReaded) in
//                                                        completionHandler(done, articlesReaded)
//        }
    }

    func stopListen() {
        //Stop the listening of the articles

        //FIXME: a implementer
//        articleRemoteDataBaseRequest.stopListen(dataNode: locationInRemoteDataBase)
    }

    func updatesoldList(list: [String: Bool] ) {
        // Update the field "sold" to true for the list of articles
        var childUpdate = [String: Bool]()

        for (articleCode, _) in list {
            childUpdate.updateValue(true, forKey: "/\(articleCode)/sold/")
        }

        //FIXME: a implementer
//        articleRemoteDataBaseRequest.updateChildValues(dataNode: locationInRemoteDataBase, childUpdates: childUpdate)
    }
}
