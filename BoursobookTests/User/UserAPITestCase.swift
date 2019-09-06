//
//  UserAPITestCase.swift
//  BoursobookTests
//
//  Created by David Dubez on 06/09/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class UserAPITestCase: XCTestCase {

    override func setUp() {
    }
    override func tearDown() {
    }

    // MARK: Test in local with mock
    func testSignInWithNoDataWithErrorSouldReturnError() {
    //Given
    let remoteAuthenticationRequestMock = RemoteAuthenticationRequestMock(error: FakeData.error, data: nil)
    let fakeUserAPI = UserAPI(userRemoteAuthenticationRequest: remoteAuthenticationRequestMock)

    //When
    let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeUserAPI.signInUser(email: "email", password: "password") { (error, signInUser) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            }
            XCTAssertNil(signInUser)
            expectation.fulfill()
        }
    wait(for: [expectation], timeout: 0.5)
    }

    func testSignInWithDataWithErrorSouldReturnError() {
        //Given
        let goodData = FakeData.user
        let remoteAuthenticationRequestMock = RemoteAuthenticationRequestMock(error: FakeData.error, data: goodData)
        let fakeUserAPI = UserAPI(userRemoteAuthenticationRequest: remoteAuthenticationRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeUserAPI.signInUser(email: "email", password: "password") { (error, signInUser) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            }
            XCTAssertNil(signInUser)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testSignInWithNoDataWithNoErrorSouldReturnError() {
        //Given
        let remoteAuthenticationRequestMock = RemoteAuthenticationRequestMock(error: nil, data: nil)
        let fakeUserAPI = UserAPI(userRemoteAuthenticationRequest: remoteAuthenticationRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeUserAPI.signInUser(email: "email", password: "password") { (error, signInUser) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            XCTAssertNil(signInUser)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testSignInWithDataWithNoErrorSouldReturnUser() {
        //Given
        let goodData = FakeData.user
        let remoteAuthenticationRequestMock = RemoteAuthenticationRequestMock(error: nil, data: goodData)
        let fakeUserAPI = UserAPI(userRemoteAuthenticationRequest: remoteAuthenticationRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeUserAPI.signInUser(email: "email", password: "password") { (error, signInUser) in

            //Then
            XCTAssertNil(error)
            guard let signInUser = signInUser else {
                XCTFail("error is nil")
                return
            }
            XCTAssertEqual(signInUser.email, goodData.email)
            XCTAssertEqual(signInUser.uniqueID, goodData.uniqueID)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testCreateUserWithNoDataWithErrorSouldReturnError() {
        //Given
        let remoteAuthenticationRequestMock = RemoteAuthenticationRequestMock(error: FakeData.error, data: nil)
        let fakeUserAPI = UserAPI(userRemoteAuthenticationRequest: remoteAuthenticationRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeUserAPI.createUser(email: "email", password: "password") { (error, createdUser) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            }
            XCTAssertNil(createdUser)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testCreateUserWithDataWithErrorSouldReturnError() {
        //Given
        let goodData = FakeData.user
        let remoteAuthenticationRequestMock = RemoteAuthenticationRequestMock(error: FakeData.error, data: goodData)
        let fakeUserAPI = UserAPI(userRemoteAuthenticationRequest: remoteAuthenticationRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeUserAPI.createUser(email: "email", password: "password") { (error, createdUser) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, """
                                                Error !
                                                BoursobookTests.FakeData.FakeError
                                                """)
            }
            XCTAssertNil(createdUser)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testCreateUserWithNoDataWithNoErrorSouldReturnError() {
        //Given
        let remoteAuthenticationRequestMock = RemoteAuthenticationRequestMock(error: nil, data: nil)
        let fakeUserAPI = UserAPI(userRemoteAuthenticationRequest: remoteAuthenticationRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeUserAPI.createUser(email: "email", password: "password") { (error, createdUser) in

            //Then
            if let error = error {
                XCTAssertEqual(error.message, "Sorry, there is an error !")
            }
            XCTAssertNil(createdUser)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testCreateUserWithDataWithNoErrorSouldReturnUser() {
        //Given
        let goodData = FakeData.user
        let remoteAuthenticationRequestMock = RemoteAuthenticationRequestMock(error: nil, data: goodData)
        let fakeUserAPI = UserAPI(userRemoteAuthenticationRequest: remoteAuthenticationRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeUserAPI.createUser(email: "email", password: "password") { (error, createdUser) in

            //Then
            XCTAssertNil(error)
            guard let createdUser = createdUser else {
                XCTFail("error is nil")
                return
            }
            XCTAssertEqual(createdUser.email, goodData.email)
            XCTAssertEqual(createdUser.uniqueID, goodData.uniqueID)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testSignOutWithErrorSouldReturnError() {
        //Given
        let remoteAuthenticationRequestMock = RemoteAuthenticationRequestMock(error: FakeData.error, data: nil)
        let fakeUserAPI = UserAPI(userRemoteAuthenticationRequest: remoteAuthenticationRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeUserAPI.signOut { (error) in

            //Then
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

    func testSignOutWithNoErrorSouldReturnNil() {
        //Given
        let remoteAuthenticationRequestMock = RemoteAuthenticationRequestMock(error: nil, data: nil)
        let fakeUserAPI = UserAPI(userRemoteAuthenticationRequest: remoteAuthenticationRequestMock)

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        fakeUserAPI.signOut { (error) in

            //Then
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: Test with real remote Authentication with FIREBASE
    func testSignIntWithGoodUserSouldReturnSuccess() {
        //Given
        let userAPI = UserAPI()

        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        userAPI.signInUser(email: PrivateKey.userMail, password: PrivateKey.userPassword) { (error, logInUser) in

            //Then
            if error != nil {
                XCTFail("error whin login")
            } else {
                guard let logInUser = logInUser else {
                    XCTFail("error there is no user")
                    return
                }
                XCTAssertEqual(logInUser.email, PrivateKey.userMail)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
