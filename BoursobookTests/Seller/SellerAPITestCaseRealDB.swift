//
//  SellerAPITestCaseRealDB.swift
//  BoursobookTests
//
//  Created by David Dubez on 06/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class SellerAPITestCaseRealDB: XCTestCase {
// MARK: Test with real remote DataBase

    let userAPI = UserAuthAPI()
    let purseAPI = PurseAPI()
    let sellerAPI = SellerAPI()
    let articleAPI = ArticleAPI()

    func testCreateAndRemoveSellerShouldSucceed() {

        let seller = FakeData.seller

        //Given
        // Login into FireBase
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        self.userAPI.signInUser(email: PrivateKey.userMail, password: PrivateKey.userPassword) { (error, _) in
           if error != nil {
               XCTFail("error whin login")
           } else {
               // Get the initial state of "Purse For Unit Testing"
               self.purseAPI.getPurse(name: "Purse For Unit Testing") { (error, purseLoaded) in
                   if error != nil { XCTFail("error in get the test purse")
                      } else {
                       guard let purseBeforeTesting = purseLoaded else {
                           XCTFail("error in get the test purse")
                           return
                       }
                    //When
                    // Create a seller to delete
                    self.sellerAPI.createSeller(newSeller: seller, in: purseBeforeTesting) { (error) in
                        if error != nil { XCTFail("error in create seller")
                        } else {

                            // Then
                            // Verify if the purse data have been updated
                            self.purseAPI.getPurse(name: "Purse For Unit Testing") { (error, purseLoaded) in
                                              if error != nil { XCTFail("error in get the test purse")
                                                 } else {
                                                  guard let purseAfterCreating = purseLoaded else {
                                                      XCTFail("error in get the test purse")
                                                      return
                                                  }
                                                XCTAssertEqual(purseAfterCreating.numberOfSellers,
                                                               purseBeforeTesting.numberOfSellers + 1)

                                                // When
                                                // Delete the screated seller
                                                self.sellerAPI.removeSeller(
                                                    seller: seller, in: purseBeforeTesting,
                                                    completionHandler: { (error) in
                                                        if error != nil { XCTFail("error in delete seller")
                                                        } else {

                                                        // Then
                                                        // Verify if the purse data have been updated

                                                        self.purseAPI.getPurse(
                                                        name: "Purse For Unit Testing") { (error, purseLoaded) in
                                                        if error != nil { XCTFail("error in get the test purse")
                                                           } else {
                                                            guard let purseAfterDeleting = purseLoaded else {
                                                                XCTFail("error in get the test purse")
                                                                return
                                                            }
                                                            XCTAssertEqual(purseAfterDeleting.numberOfSellers,
                                                                         purseAfterCreating.numberOfSellers - 1)
                                                            expectation.fulfill()
                                                            }
                                                        }
                                                    }
                                                })
                                }
                            }
                        }
                    }
                }
            }
            }
        }
       wait(for: [expectation], timeout: 10)
    }

    func testUpdateDataForArticleReturnedShouldSucceed() {
        let article = FakeData.firstArticleNotSold
        let seller = FakeData.seller

        //Given
        // Login into FireBase
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        self.userAPI.signInUser(email: PrivateKey.userMail, password: PrivateKey.userPassword) { (error, user) in
            if error != nil { XCTFail("error whin login")
            } else {
                guard let user = user else { XCTFail("error whin user")
                    return }

                // Get the initial state of "Purse For Unit Testing"
                self.purseAPI.getPurse(name: "Purse For Unit Testing") { (error, purseLoaded) in
                    if error != nil { XCTFail("error in get the test purse")
                    } else { guard let purseBeforeTesting = purseLoaded
                        else { XCTFail("error in get the test purse")
                            return
                        }

                        self.setInitialState(
                            seller: seller, article: article,
                            purse: purseBeforeTesting) { (error) in

                                if error != nil { XCTFail("error in initialing state")
                                } else {

                                    //When
                                    // uptade data in database with the article returned
                                    self.sellerAPI.updateDataForArticleReturned(
                                        article: article, seller: seller,
                                        purse: purseBeforeTesting, user: user) { (error) in
                                            if error != nil { XCTFail("error in update seller")
                                            } else {

        //Then
        // Load updated data from data base
        // and test if the data had been correctly updated

        self.getDataUpdate(seller: seller, purse: purseBeforeTesting,
                           article: article) { (error, loadedPurse, loadedSeller, loadedArticle) in
            if error != nil { XCTFail("error in get data update")
            } else { guard let purseAfterTesting = loadedPurse,
                let sellerAfterTesting = loadedSeller, let articleAfterTesting = loadedArticle else {
                    XCTFail("error in get data update")
                    return
            }

            // Test purse update
            XCTAssertEqual(purseAfterTesting.numberOfArticleReturned, purseBeforeTesting.numberOfArticleReturned + 1)

            // Test article update
            XCTAssertEqual(articleAfterTesting.returned, true)

            // Test seller update
            XCTAssertNotNil(sellerAfterTesting.refundDate)
            XCTAssertTrue(sellerAfterTesting.refundDone)
            XCTAssertEqual(sellerAfterTesting.refundBy, user.email)

            // Clean all data created
            self.cleanDataCreatedForTestseller(
                seller: seller, article: article) { (error) in
                    if error != nil { XCTFail("error in remove data")
                    } else { expectation.fulfill()
                    }
            }
            }
        }
                                            }
                                    }
                                }
                        }
                    }
                }

            }

        }
        wait(for: [expectation], timeout: 20)
    }

    private func setInitialState(seller: Seller,
                                 article: Article,
                                 purse: Purse,
                                 completionHandler: @escaping (Error?) -> Void) {

        //Create a seller
        sellerAPI.createSeller(newSeller: seller, in: purse) { (error) in
            if error != nil {
                completionHandler(FakeData.error)
            } else {
                //Create a article
                self.articleAPI.createArticle(purse: purse, seller: seller, article: article) { (error) in
                    if error != nil {
                        completionHandler(FakeData.error)
                    } else {
                        completionHandler(nil)
                    }
                }
            }
        }
    }

    private func cleanDataCreatedForTestseller(seller: Seller,
                                               article: Article,
                                               completionHandler: @escaping (Error?) -> Void) {
        self.sellerAPI.removeHard(seller: seller) { (error) in
            if error != nil {
                completionHandler(FakeData.error)
            } else {
                self.articleAPI.removeHard(article: article, completionHandler: { (error) in
                    if error != nil {
                        completionHandler(FakeData.error)
                    } else {
                        completionHandler(nil)
                    }
                })
            }
        }
    }

    private func getDataUpdate(
        seller: Seller, purse: Purse, article: Article,
        completionHandler: @escaping (Error?, Purse?, Seller?, Article?) -> Void) {

        self.purseAPI.getPurse(name: purse.name) { (error, purseLoaded) in
            if error != nil {  completionHandler(FakeData.error, nil, nil, nil)
            } else {
                guard let purseAfterTesting = purseLoaded else {
                    completionHandler(FakeData.error, nil, nil, nil)
                    return
                }
                self.sellerAPI.getSeller(uniqueID: seller.uniqueID) { (error, sellerLoaded) in
                    if error != nil { completionHandler(FakeData.error, nil, nil, nil)
                    } else {
                        guard let sellerAfterTesting = sellerLoaded else {
                            completionHandler(FakeData.error, nil, nil, nil)
                            return
                        }
                        self.articleAPI.getArticle(uniqueID: article.uniqueID) { (error, articlesList) in
                            if error != nil { completionHandler(FakeData.error, nil, nil, nil)
                            } else {
                                guard let articlesList = articlesList else {
                                    completionHandler(FakeData.error, nil, nil, nil)
                                    return
                                }
                                completionHandler(nil, purseAfterTesting, sellerAfterTesting, articlesList)
                            }
                        }
                    }
                }
            }
        }
    }
}
