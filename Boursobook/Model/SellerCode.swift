//
//  SellerCode.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class SellerCode {

    static var caractersList: [String] {
        var list = [String]()
        for index in 0...25 {
            let character = String(UnicodeScalar(UInt8(65 + index)))
            list.append(character)
        }
        return list
    }
}
