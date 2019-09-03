//
//  FakeResponseData.swift
//  BoursobookTests
//
//  Created by David Dubez on 07/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class FakeResponseData {

    // MARK: - Data
    static var CorrectBookData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "CorrectBook", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var CorrectDataWithNoBook: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "NoBook", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static var CorrectDataWithError: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "WrongBook", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static let incorrectData = "erreur".data(using: .utf8)!

    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "http://goodResponse")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "http://badResponse")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!

    // MARK: - Error
    class FakeError: Error {}
    static let error = FakeError()
}
