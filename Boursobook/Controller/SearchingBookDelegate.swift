//
//  SearchingBookDelegate.swift
//  Boursobook
//
//  Created by David Dubez on 03/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import UIKit

protocol SearchingBookDelegate: class {
    func didFindExistingBook(info: Book.VolumeInfo, isbn: String)
}
