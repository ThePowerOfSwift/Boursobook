//
//  Error+extension.swift
//  Boursobook
//
//  Created by David Dubez on 28/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

/**
 extension to add a mesage to display depending of the error
 */
extension Error {
    var message: String {
        if let errorType = self as? UserService.USError {
            return NSLocalizedString(errorType.rawValue, comment: "")
        } else if let errorType = self as? BookService.BSError {
            return NSLocalizedString(errorType.rawValue, comment: "")
        } else if let errorType = self as? PurseAPI.PAPIError {
            return NSLocalizedString(errorType.rawValue, comment: "")
        } else if let errorType = self as? InMemoryStorage.IMSError {
            return NSLocalizedString(errorType.rawValue, comment: "")
        } else if let errorType = self as? RemoteDataBase.RDBError {
            return NSLocalizedString(errorType.rawValue, comment: "")
        } else {
            return "\(NSLocalizedString("Error !", comment: ""))" + "\n" + String(describing: self)
        }
    }
}
