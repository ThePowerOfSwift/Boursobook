//
//  PurseAPITestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 03/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class PurseAPITestCaseWithMockCR: XCTestCase {
// MARK: Test in local with mock

    let testUser = FakeData.user

// MARK: - Test "getPurse" function
     func testGetPurseWithDataWithErrorSouldReturnError() {
        let goodData = [FakeData.purse]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection,
                                                                  error: FakeData.error, data: goodData)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.getPurse(name: "purseName") { (error, loadedPurses) in

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

    func testGetPurseWithNoDataWithNoErrorSouldReturnError() {
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection,
                                                                  error: nil, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.getPurse(name: "purseName") { (error, loadedPurses) in

            //Then
            XCTAssertNil(loadedPurses)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetPurseWithDataWithNoErrorSouldReturnData() {
        let goodData = [FakeData.purse]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection,
                                                                  error: nil, data: goodData)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.getPurse(name: "purseName") { (error, loadedPurses) in

            //Then
            XCTAssertNil(error)
            if let loadedPurses = loadedPurses {
                XCTAssertEqual(loadedPurses.name, goodData.first?.name)
                XCTAssertEqual(loadedPurses.uniqueID, goodData.first?.uniqueID)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

// MARK: - Test "loadPursesFor" function
    func testLoadForNoUserWithDataWithNoErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.purse]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection,
                                                                  error: nil, data: goodData)
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

    func testLoadForNoDataWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection, error: nil, data: nil)
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

    func testLoadForDataWithErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.purse]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection, error: FakeData.error,
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

    func testLoadForDataWithNoErrorSouldReturnData() {
        //Given
        let goodData = [FakeData.purse]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection, error: nil,
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

    // MARK: - Test "createPurse" function
    func testCreateNoUserWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection, error: nil, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.createPurse(name: "name", user: nil) { (error, createdPurse) in

            //Then
            if let error = error { XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            XCTAssertNil(createdPurse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testCreateWithUserWithErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection,
                                                                  error: FakeData.error, data: nil)
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
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection, error: nil, data: nil)
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

    // MARK: - Test "GetExisting" function
    func testGetExistingWithNoDataWithErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection,
                                                                  error: FakeData.error, data: nil)
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
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection,
                                                                  error: nil, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.getExistingPurseName { (error, loadedPurses) in

            //Then
            XCTAssertNil(loadedPurses)
            if let error = error { XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testGetExistingWithDataWithNoErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.purse]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection,
                                                                  error: nil, data: goodData)
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

   // MARK: - Test "Load" function
    func testLoadPusreNoDataWithNoErrorSouldReturnError() {
        //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection, error: nil, data: nil)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.loadPurse(name: "name") { (error, loadedPurse) in

            //Then
            XCTAssertNil(loadedPurse)
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "loadPurse" function
    func testLoadDataWithErrorSouldReturnError() {
        //Given
        let goodData = [FakeData.purse]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection, error: FakeData.error,
                                                                  data: goodData)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.loadPurse(name: "name") { (error, loadedPurse) in

            //Then
            XCTAssertNil(loadedPurse)
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
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(collection: Purse.collection, error: nil,
                                                                  data: goodData)
        let fakePurseAPI = PurseAPI(purseRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakePurseAPI.loadPurse(name: "name") { (error, loadedPurse) in

            //Then
            XCTAssertNil(error)
            guard let purse = loadedPurse else {
                XCTFail("error is nil")
                return
            }
            XCTAssertEqual(purse.uniqueID, goodData[0].uniqueID)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
}
