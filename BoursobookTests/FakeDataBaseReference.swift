//
//  FakeDataBaseReference.swift
//  BoursobookTests
//
//  Created by David Dubez on 12/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class MockDatabaseReference: DatabaseReference {
// Override Firebae Realtime Database

    override func child(_ pathString: String) -> DatabaseReference {
        return self
    }

//    override func observe(_ eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) -> UInt {
//        let snapshot = FakeTransactionDataSnapshot()
//        DispatchQueue.global().async {
//            block(snapshot)
//        }
//        return 1
//    }
//
//    override func observeSingleEvent(of eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) {
//        let snapshot = FakeTransactionDataSnapshot()
//        DispatchQueue.global().async {
//            block(snapshot)
//        }
//    }
}
