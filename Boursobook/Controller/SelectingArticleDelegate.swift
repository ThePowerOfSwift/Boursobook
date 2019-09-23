//
//  SelectingArticleDelegate.swift
//  Boursobook
//
//  Created by David Dubez on 23/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

protocol SelectingArticleDelegate: class {
    func didSelectArticle(articleUniqueID: String)
}
