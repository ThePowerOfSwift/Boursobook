//
//  SellerService.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

class SellerService {
    static var shared = SellerService()

    private(set) var sellers: [Seller] = []

    private init() {
    }

    func add(seller: Seller) {
        sellers.append(seller)
    }
    func removeSeller(at index: Int) {
        sellers.remove(at: index)
    }
}
// TODO:          - tests à faire
