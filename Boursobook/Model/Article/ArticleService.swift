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
    static var shared = ArticleService()
    private(set) var articles: [Article] = []
    let reference = Database.database().reference(withPath: "articles")

    // MARK: - Initialisation
    private init() {
    }

    // MARK: - Functions
    func add(article: Article) {

        articles.append(article)

        let articleRef = reference.child(article.code)
        let values: [String: Any] = ["title": article.title,
                                     "sort": article.sort, "author": article.author,
                                     "description": article.description, "purseName": article.purseName,
                                     "isbn": article.isbn, "price": article.price, "solded": article.solded,
                                     "sellerCode": article.sellerCode]

        articleRef.setValue(values)
        for seller in SellerService.shared.sellers where seller.code == article.sellerCode {
            seller.articleRegistered += 1
        }
        //FIXME: maj le nombre d'article du seller
        
    }
    func remove(at index: Int) {
        let article = articles[index]
        reference.child(article.code).removeValue()
        articles.remove(at: index)
        //FIXME: maj le nombre d'article du seller
    }

    func filtered(by seller: Seller) -> [Article] {
        var filteredList = [Article]()
        for article in articles where article.sellerCode == seller.code {
            filteredList.append(article)
        }
        return filteredList
    }

    func titleOrderedQuery(completionHandler: @escaping (Bool) -> Void) {
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
            self.articles = newArticles
            completionHandler(true)
        }
    }
}
// TODO:         - tests à faire
//           - verifier qu'on cree pas 2 fois la meme instance (meme purse ....)
