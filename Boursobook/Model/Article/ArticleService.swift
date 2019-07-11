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

    // MARK: - Properties
    let reference = Database.database().reference(withPath: "articles")

    // MARK: - Functions
    func create(article: Article) {

        let articleRef = reference.child(article.code)
        let values: [String: Any] = ["title": article.title,
                                     "sort": article.sort, "author": article.author,
                                     "description": article.description, "purseName": article.purseName,
                                     "isbn": article.isbn, "price": article.price, "solded": article.solded,
                                     "sellerCode": article.sellerCode]

        articleRef.setValue(values)
    }

    func remove(article: Article) {
        reference.child(article.code).removeValue()
    }

    func readAndListenData(completionHandler: @escaping (Bool, [Article]) -> Void) {
        // Query articles from FireBase and order by title
        reference.queryOrdered(byChild: "title").observe(.value) { snapshot in
            var newArticles: [Article] = []

            for child in snapshot.children {
                if let childValue = child as? DataSnapshot {
                    if let article = Article(snapshot: childValue) {
                        newArticles.append(article)
                    }
                }
            }
            completionHandler(true, newArticles)
        }
    }
}
// TODO:         - tests à faire
//           - verifier qu'on cree pas 2 fois la meme instance (meme purse ....)
