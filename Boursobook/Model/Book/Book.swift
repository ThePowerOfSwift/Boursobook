//
//  Book.swift
//  Boursobook
//
//  Created by David Dubez on 28/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class Book: Decodable {
    // creation of structure like JSON model response

    var totalItems: Int?
    var items: [Item]?
    var error: Error?

    struct Item: Decodable {
        var volumeInfo: VolumeInfo
    }

    struct VolumeInfo: Decodable {
        var title: String
        var authors: [String]
        var description: String
        var pageCount: Int
    }

    struct Error: Decodable {
        var code: Int
        var message: String
        var errors: [Errors]
        var status: String
    }

    struct Errors: Decodable {
        var message: String
        var domain: String
        var reason: String
    }
}
