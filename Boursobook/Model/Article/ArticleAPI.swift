//
//  ArticleAPI.swift
//  Boursobook
//
//  Created by David Dubez on 05/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class ArticleAPI {
    // Manage the acces of "article" data

    // MARK: Properties
    private let remoteDataBaseCollection: RemoteDataBase.Collection = .article
    private var articleRemoteDataBaseRequest: RemoteDatabaseRequest = FireBaseDataRequest(collection: .article)

    // MARK: Initialisation
    init() {}
    init(articleRemoteDataBaseRequest: RemoteDatabaseRequest) {
        self.articleRemoteDataBaseRequest = articleRemoteDataBaseRequest
    }

    // MARK: Functions
    func loadArticlesFor(purse: Purse?, completionHandler: @escaping (Error?, [Article]?) -> Void) {
        // Query Articles from database for a purse

        guard let purse = purse else {
            completionHandler(AAPIError.other, nil)
            return
        }
        let condition = RemoteDataBase.Condition(key: "purseName", value: purse.name)

        articleRemoteDataBaseRequest
            .readAndListenData(conditionInField: condition) { (error, loadedArticles: [Article]? ) in
                                                        if let error = error {
                                                            completionHandler(error, nil)
                                                        } else {
                                                            guard let loadedArticles = loadedArticles else {
                                                                completionHandler(AAPIError.other, nil)
                                                                return
                                                            }
                                                            completionHandler(nil, loadedArticles)
                                                        }
        }
    }
}

extension ArticleAPI {
    /**
     'AAPIError' is the error type returned by ArticleAPI.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     */
    enum AAPIError: String, Error {
        case other = "Sorry, there is an error !"
    }
}
