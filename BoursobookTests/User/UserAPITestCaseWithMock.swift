//
//  UserAPITestCaseWithMock.swift
//  BoursobookTests
//
//  Created by David Dubez on 06/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class UserAPITestCaseWithMock: XCTestCase {
    // MARK: Test in local with mock

    // MARK: - Test "readUsers" function
       func testReadUsersWithNoDataWithErrorSouldReturnError() {
       //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(
            collection: User.collection,
            error: FakeData.error, data: nil)
       let fakeUserAPI = UserAPI(userRemoteDataBaseRequest: remoteDatabaseRequestMock)

       //When
       let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeUserAPI.readUsers { (error, readedUsers) in

               //Then
               if let error = error {
                   XCTAssertEqual(error.message, """
                                                   Error !
                                                   BoursobookTests.FakeData.FakeError
                                                   """)
               }
               XCTAssertNil(readedUsers)
               expectation.fulfill()
           }
       wait(for: [expectation], timeout: 0.5)
       }

    func testReadUsersWithDataWithErrorSouldReturnError() {
    //Given
        let goodData = [FakeData.user]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(
            collection: User.collection,
            error: FakeData.error, data: goodData)
        let fakeUserAPI = UserAPI(userRemoteDataBaseRequest: remoteDatabaseRequestMock)

    //When
    let expectation = XCTestExpectation(description: "Wait for queue change.")
     fakeUserAPI.readUsers { (error, readedUsers) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            }
            XCTAssertNil(readedUsers)
            expectation.fulfill()
        }
    wait(for: [expectation], timeout: 0.5)
    }

    func testReadUsersWithNoDataWithNoErrorSouldReturnError() {
    //Given
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(
            collection: User.collection,
            error: nil, data: nil)
        let fakeUserAPI = UserAPI(userRemoteDataBaseRequest: remoteDatabaseRequestMock)

    //When
    let expectation = XCTestExpectation(description: "Wait for queue change.")
     fakeUserAPI.readUsers { (error, readedUsers) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            XCTAssertNil(readedUsers)
            expectation.fulfill()
        }
    wait(for: [expectation], timeout: 0.5)
    }

    func testReadUsersWithDataWithNoErrorSouldReturnUser() {
    //Given
        let goodData = [FakeData.user]
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(
            collection: User.collection,
            error: nil, data: goodData)
        let fakeUserAPI = UserAPI(userRemoteDataBaseRequest: remoteDatabaseRequestMock)

    //When
    let expectation = XCTestExpectation(description: "Wait for queue change.")
     fakeUserAPI.readUsers { (error, readedUsers) in

            //Then
            XCTAssertNil(error)
            if let readedUsers = readedUsers {
                XCTAssertEqual(readedUsers.first?.email, goodData.first?.email)
                XCTAssertEqual(readedUsers.first?.uniqueID, goodData.first?.uniqueID)
            }
            expectation.fulfill()
        }
    wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Test "save" function
    func testSaveUsersWithNoUserWithErrorSouldReturnError() {
    //Given
     let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(
         collection: User.collection,
         error: FakeData.error, data: nil)
    let fakeUserAPI = UserAPI(userRemoteDataBaseRequest: remoteDatabaseRequestMock)

    //When
    let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeUserAPI.save(user: nil, completionHandler: { (error) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            expectation.fulfill()
        })
    wait(for: [expectation], timeout: 0.5)
    }

    func testSaveUsersWithUserWithErrorSouldReturnError() {
    //Given
        let user = FakeData.user
        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(
            collection: User.collection,
            error: FakeData.error, data: nil)
        let fakeUserAPI = UserAPI(userRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
            fakeUserAPI.save(user: user, completionHandler: { (error) in

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

    func testSaveUsersWithUserWithNoErrorSouldReturnNil() {
    //Given
        let user = FakeData.user

        let remoteDatabaseRequestMock = RemoteDatabaseRequestMock(
            collection: User.collection,
            error: nil, data: nil)
        let fakeUserAPI = UserAPI(userRemoteDataBaseRequest: remoteDatabaseRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
            fakeUserAPI.save(user: user, completionHandler: { (error) in

                //Then
                XCTAssertNil(error)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 0.5)
        }
    }
