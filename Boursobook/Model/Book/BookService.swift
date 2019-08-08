//
//  BookService.swift
//  Boursobook
//
//  Created by David Dubez on 29/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class BookService {
    // network request for retrieve Book data

    // MARK: - PROPERTIES
    private var session = URLSession(configuration: .default)

    init(session: URLSession) {
        self.session = session
    }
    init() {
    }

    private static let urlString = "https://www.googleapis.com/books/v1/volumes"

    private var task: URLSessionDataTask?

    // MARK: - FUNCTIONS
    func getBook(isbn: String,
                 callBack: @escaping (Bool, Book.VolumeInfo?, BSError?) -> Void) {
        let request = createBookRequest(isbn: isbn)

        task?.cancel()

        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callBack(false, nil, .errorInData)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callBack(false, nil, .errorInStatusCode)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(Book.self, from: data) else {
                    callBack(false, nil, .errorInJSONDecoder)
                    return
                }
                guard responseJSON.error == nil else {
                    callBack(false, nil, .errorInAPIResponse)
                    return
                }
                let book = responseJSON

                guard let items = book.items else {
                    callBack(false, nil, .errorNoMatch)
                    return
                }

                callBack(true, items[0].volumeInfo, nil)
            }
        }
        task?.resume()
    }

    private func createBookRequest(isbn: String) -> URLRequest {

        let urlWithParams = BookService.urlString + "?q=+isbn:" + isbn
        let bookServiceUrl = URL(string: urlWithParams)!
        var request = URLRequest(url: bookServiceUrl)
        request.httpMethod = "GET"

        return request
    }
}

extension BookService {
    /**
     'BSError' is the error type returned by BookService.
     It encompasses a few different types of errors, each with
     their own associated reasons.
     */
    enum BSError: String, Error {
        case errorInData = "error in data !"
        case errorInStatusCode = "error in statusCode !"
        case errorInJSONDecoder = "error in JSONDecoder !"
        case errorInAPIResponse = "error in API response !"
        case errorNoMatch = "Sorry, there is no match !"
    }
}
