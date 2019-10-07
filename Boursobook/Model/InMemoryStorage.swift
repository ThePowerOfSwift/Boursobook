//
//  InMemoryStorage.swift
//  Boursobook
//
//  Created by David Dubez on 09/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class InMemoryStorage {
// manage the active user, purse and the articles selected in the current sale in the app memory

    // MARK: - Properties
    static var shared = InMemoryStorage()
    var userLogIn: User?
    var inWorkingPurse: Purse?
    var codeOfArticlesInCurrentSales = [String]()

    private init() {
    }
}
