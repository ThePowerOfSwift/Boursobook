//
//  ArticleService.swift
//  Boursobook
//
//  Created by David Dubez on 25/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class ArticleService {
    static var shared = ArticleService()

    private(set) var articles: [Article] = []

    private init() {
    }

    func add(article: Article) {
        articles.append(article)
    }
    func remove(at index: Int) {
        articles.remove(at: index)
    }
    func remove(article articleToRemove: Article) {
        for (index, article) in articles.enumerated() where article.code == articleToRemove.code {
            articles.remove(at: index)
        }
    }
    func filtered(by seller: Seller) -> [Article] {
        var filteredList = [Article]()
        for article in articles where article.seller == seller {
            filteredList.append(article)
        }
        return filteredList
    }
}
// TODO:         - tests à faire
//           - verifier qu'on cree pas 2 fois la meme instance (meme purse ....)
