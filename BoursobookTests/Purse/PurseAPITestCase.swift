//
//  PurseAPITestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 03/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class PurseAPITestCase: XCTestCase {

    let testUser = FakeData.user

    override func setUp() {
    }

    override func tearDown() {
    }

    // MARK: Test in local with mock
    func testLoadNoUserWithDataWithNoErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.purse]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: nil, data: goodData)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.loadPursesFor(user: nil) { (error, loadedPurses) in

            //Then
            XCTAssertNil(loadedPurses)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadNoDataWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: nil, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.loadPursesFor(user: testUser) { (error, loadedPurses) in

            //Then
            XCTAssertNil(loadedPurses)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadDataWithErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.purse]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: FakeData.error,
                                                                  data: goodData)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.loadPursesFor(user: testUser) { (error, loadedPurses) in

            //Then
            XCTAssertNil(loadedPurses)
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testLoadDataWithNoErrorSouldReturnData() {
        //Given
        let goodData = [FakeData.purse]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: nil,
                                                                  data: goodData)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.loadPursesFor(user: testUser) { (error, loadedPurses) in

            //Then
            XCTAssertNil(error)
            guard let listOfPurses = loadedPurses else {
                XCTFail("error is nil")
                return
            }
            XCTAssertEqual(listOfPurses[0].uniqueID, goodData[0].uniqueID)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testCreateNoUserWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: nil, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.createPurse(name: "name", user: nil) { (error, createdPurse) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            XCTAssertNil(createdPurse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testCreateWithUserWithErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: FakeData.error, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.createPurse(name: "name", user: testUser) { (error, createdPurse) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            }
            XCTAssertNil(createdPurse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testCreateWithUserWithNoErrorSouldReturnSucceed() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: nil, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.createPurse(name: "name", user: testUser) { (error, createdPurse) in

            //Then
            XCTAssertNil(error)
            XCTAssertNotNil(createdPurse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetExistingWithNoDataWithErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: FakeData.error, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.getExistingPurseName { (error, loadedPurses) in

            //Then
            XCTAssertNil(loadedPurses)
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetExistingWithNoDataWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: nil, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.getExistingPurseName { (error, loadedPurses) in

            //Then
            XCTAssertNil(loadedPurses)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetExistingWithDataWithNoErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.purse]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: nil, data: goodData)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.getExistingPurseName { (error, listOfNames) in

            //Then
            XCTAssertNil(error)
            guard let listOfNames = listOfNames else {
                XCTFail("error is nil")
                return
            }
            XCTAssertEqual(listOfNames, [goodData[0].name])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testRemoveWithErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: FakeData.error, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.removePurse(purse: FakeData.purse, completionHandler: { (error) in
            //Then
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
    }

    func testRemoveWithNoErrorSouldReturnSucceed() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(error: nil, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.removePurse(purse: FakeData.purse, completionHandler: { (error) in

            //Then
            XCTAssertNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: Test with real remote DataBase FIREBASE
    func testCreateRealPurseSouldSucceed() {
        let userAPI = UserAPI()
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
