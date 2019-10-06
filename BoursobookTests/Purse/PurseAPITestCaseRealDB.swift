//
//  PurseAPITestCaseRealDB.swift
//  BoursobookTests
//
//  Created by David Dubez on 06/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class PurseAPITestCaseRealDB: XCTestCase {

    // MARK: Test with real remote DataBase FIREBASE
    func testCreateRealPurseSouldSucceed() {
        let userAPI = UserAuthAPI()
        let purseAPI = PurseAPI()

        // Login into FireBase
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        userAPI.signInUser(email: PrivateKey.userMail, password: PrivateKey.userPassword) { (error, _) in
            if error != nil {
                XCTFail("error whin login")
            } else {

                // Confirm if purse we want to create is not exist
                purseAPI.getExistingPurseName(completionHandler: { (error, purseNames) in
                    if error != nil {
                        XCTFail("error in get existing")
                    } else {
                        guard let listOfPurses = purseNames else {
                            XCTFail("error in get existing")
                            return
                        }
                        if listOfPurses.contains("new Purse for Test") {
                            XCTFail("error purse exist")
                        }

                        // Create a new Purse
                        purseAPI.createPurse(name: "new Purse for Test",
                                             user: FakeData.user,
                                             completionHandler: { (error, createdPurse) in
                            if error != nil {
                                XCTFail("error in creating purse")
                            }
                                                guard let createdPurse = createdPurse else {
                                                    XCTFail("error in creating purse")
                                                    return
                                                }

                            // Confirm if the purse exist now
                            purseAPI.getExistingPurseName(completionHandler: { (error, purseNames) in
                                if error != nil {
                                    XCTFail("error in get existing")
                                } else {
                                    guard let listOfPurses = purseNames else {
                                        XCTFail("error in get existing")
                                        return
                                    }
                                    XCTAssert(listOfPurses.contains("new Purse for Test"))

                                    // Delete the new purse that was created
                                    purseAPI.removePurse(purse: createdPurse, completionHandler: { (error) in
                                        if error != nil {
                                            XCTFail("error in delete")
                                        }
                                        expectation.fulfill()
                                    })
                                }
                            })
                        })
                    }
                })
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }

}
