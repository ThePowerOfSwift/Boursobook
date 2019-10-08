//
//  ArticleAPITestCaseRealDB.swift
//  BoursobookTests
//
//  Created by David Dubez on 07/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class ArticleAPITestCaseRealDB: XCTestCase {
    // MARK: Test in real db

    let userAPI = UserAuthAPI()
    let purseAPI = PurseAPI()
    let sellerAPI = SellerAPI()
    let articleAPI = ArticleAPI()
    let article = FakeData.firstArticleNotSold
    let seller = FakeData.seller

    func testCreateArticleShouldSucceed() {

        seller.articleRegistered = 49

        //Given
        // Login into FireBase
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        self.userAPI.signInUser(email: PrivateKey.userMail, password: PrivateKey.userPassword) { (error, _) in
            if error != nil { XCTFail("error whin login")
            } else {
                // Get the initial state of "Purse For Unit Testing"
                self.purseAPI.getPurse(name: "Purse For Unit Testing") { (error, purseLoaded) in
                    if error != nil { XCTFail("error in get the test purse")
                    } else { guard let purseBeforeTesting = purseLoaded else {
                                XCTFail("error in get the test purse")
                                return
                        }

                        // Set the initial state of data
                        self.setInitialStateForCreateTest(seller: self.seller, purse: purseBeforeTesting) { (error) in
                                if error != nil { XCTFail("error in initialing state")
                                } else {

                                    // When
                                    // Create an article in database
                                self.articleAPI.createArticle(
                                purse: purseBeforeTesting, seller: self.seller, article: self.article) { (error) in
                                        if error != nil { XCTFail("error in create article")
                                        } else {

                                           //Then
                                           // Load updated data from data base

                                    self.getDataUpdate(
                                        seller: self.seller,
                                        purse: purseBeforeTesting) {(error, loadedPurse, loadedSeller) in
                                                if error != nil { XCTFail("error in get data update")
                                                } else { guard let purseAfterTesting = loadedPurse,
                                                            let sellerAfterTesting = loadedSeller else {
                                                    XCTFail("error in get data update")
                                                    return
                                                    }

                                                    // and test if the data had been correctly updated
                                                    // Test Purse
                                                    XCTAssertEqual(purseAfterTesting.numberOfArticleRegistered,
                                                                   purseBeforeTesting.numberOfArticleRegistered + 1)
                                                    XCTAssertEqual(purseAfterTesting.totalDepositFeeAmount,
                                                                   purseBeforeTesting.totalDepositFeeAmount
                                                                    + (sellerAfterTesting.depositFeeAmount
                                                                        - self.seller.depositFeeAmount))

                                                    // Test Seller
                                                    XCTAssertEqual(sellerAfterTesting.articleRegistered,
                                                                   self.seller.articleRegistered + 1)
                                                    XCTAssertEqual(sellerAfterTesting.orderNumber,
                                                                   self.seller.orderNumber + 1)

                                                    // Clean all data created
                                                    self.cleanDataForCreateTest(
                                                    seller: self.seller, article: self.article) { (error) in
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

    func testRemoteArticleShouldSucceed() {

        seller.articleRegistered = 49

        //Given
        // Login into FireBase
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        self.userAPI.signInUser(email: PrivateKey.userMail, password: PrivateKey.userPassword) { (error, _) in
            if error != nil { XCTFail("error whin login")
            } else {
                // Get the purse "Purse For Unit Testing"
                self.purseAPI.getPurse(name: "Purse For Unit Testing") { (error, purseLoaded) in
                    if error != nil { XCTFail("error in get the test purse")
                    } else { guard let purseForTesting = purseLoaded else {
                        XCTFail("error in get the test purse")
                        return
                        }

        // Set the initial state of data and get the state
        self.setAndGetInitialStateForRemoveTest(seller: self.seller, purse: purseForTesting,
                                                article: self.article) { (error, loadedPurse, loadedSeller) in
                if error != nil { XCTFail("error in set and get initial state")
                } else { guard let purseBeforeTesting = loadedPurse,
                    let sellerBeforeTesting = loadedSeller else { XCTFail("error in set and get initial state")
                        return
                    }

                    // When
                    // Remove an article in database
                    self.articleAPI.removeArticle(
                        purse: purseForTesting, seller: sellerBeforeTesting,
                        article: self.article) { (error) in
                            if error != nil { XCTFail("error in delete article")
                            } else {

                                //Then
                                // Load updated data from data base

        self.getDataUpdateWithListOfArticle(
            seller: self.seller,
            purse: purseBeforeTesting) {(error, loadedPurse, loadedSeller, articleList) in
                if error != nil { XCTFail("error in get data update")
                } else { guard let purseAfterTesting = loadedPurse,
                    let sellerAfterTesting = loadedSeller, let articleList = articleList else {
                        XCTFail("error in get data update")
                        return
                    }

                    // and test if the data had been correctly updated
                    // Test Purse
        XCTAssertEqual(purseAfterTesting.numberOfArticleRegistered, purseBeforeTesting.numberOfArticleRegistered - 1)
        XCTAssertEqual(purseAfterTesting.totalDepositFeeAmount, purseBeforeTesting.totalDepositFeeAmount
                        - (sellerBeforeTesting.depositFeeAmount - sellerAfterTesting.depositFeeAmount))

                    // Test Seller
        XCTAssertEqual(sellerAfterTesting.articleRegistered, sellerBeforeTesting.articleRegistered - 1)
        XCTAssertEqual(sellerAfterTesting.orderNumber, sellerBeforeTesting.orderNumber)

                    // Test if article is not existing
                    for existingArticle in articleList where existingArticle.uniqueID == self.article.uniqueID {
                            XCTFail("error the article exist")
                    }
                    // Clean all data created
                    self.cleanDataForRemoveTest(seller: self.seller) { (error) in
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

        wait(for: [expectation], timeout: 10)
    }

    func testRemoteArticleForDeletSellerShouldSucceed() {

        seller.articleRegistered = 49

        //Given
        // Login into FireBase
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        self.userAPI.signInUser(email: PrivateKey.userMail, password: PrivateKey.userPassword) { (error, _) in
            if error != nil { XCTFail("error whin login")
            } else {
                // Get the purse "Purse For Unit Testing"
                self.purseAPI.getPurse(name: "Purse For Unit Testing") { (error, purseLoaded) in
                    if error != nil { XCTFail("error in get the test purse")
                    } else { guard let purseForTesting = purseLoaded else {
                        XCTFail("error in get the test purse")
                        return
                        }

        // Set the initial state of data and get the state
        self.setAndGetInitialStateForRemoveTest(seller: self.seller, purse: purseForTesting,
                                                article: self.article) { (error, loadedPurse, _) in
                if error != nil { XCTFail("error in set and get initial state")
                } else { guard let purseBeforeTesting = loadedPurse
                        else { XCTFail("error in set and get initial state")
                        return
                    }

                    // When
                    // Remove an article in database
                    self.articleAPI.removeArticleForDeleteSeller(
                        purse: purseForTesting, article: self.article) { (error) in
                            if error != nil { XCTFail("error in delete article")
                            } else {

                                //Then
                                // Load updated data from data base

        self.getDataUpdateWithListOfArticle(
            seller: self.seller,
            purse: purseBeforeTesting) {(error, loadedPurse, _, articleList) in
                if error != nil { XCTFail("error in get data update")
                } else { guard let purseAfterTesting = loadedPurse, let articleList = articleList else {
                        XCTFail("error in get data update")
                        return
                    }

                    // and test if the data had been correctly updated
                    // Test Purse
        XCTAssertEqual(purseAfterTesting.numberOfArticleRegistered, purseBeforeTesting.numberOfArticleRegistered - 1)
        XCTAssertEqual(purseAfterTesting.totalDepositFeeAmount, purseBeforeTesting.totalDepositFeeAmount)

                    // Test if article is not existing
                    for existingArticle in articleList where existingArticle.uniqueID == self.article.uniqueID {
                            XCTFail("error the article exist")
                    }
                    // Clean all data created
                    self.cleanDataForRemoveTest(seller: self.seller) { (error) in
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

        wait(for: [expectation], timeout: 10)
    }

    private func setInitialStateForCreateTest(
        seller: Seller, purse: Purse, completionHandler: @escaping (Error?) -> Void) {

       //Create a seller
       sellerAPI.createSeller(newSeller: seller, in: purse) { (error) in
           if error != nil { completionHandler(FakeData.error)
           } else { completionHandler(nil)
           }
       }
    }

    private func setAndGetInitialStateForRemoveTest(
        seller: Seller, purse: Purse, article: Article,
        completionHandler: @escaping (Error?, Purse?, Seller?) -> Void) {

          //Create a seller
          sellerAPI.createSeller(newSeller: seller, in: purse) { (error) in
              if error != nil {  completionHandler(FakeData.error, nil, nil)
              } else {
                //Create an article
                self.articleAPI.createArticle(purse: purse, seller: seller, article: article) { (error) in
                    if error != nil { completionHandler(FakeData.error, nil, nil)
                    } else {
                        self.getDataUpdate(seller: seller, purse: purse) { (error, purse, seller) in
                            if error != nil {  completionHandler(FakeData.error, nil, nil)
                            } else { completionHandler(nil, purse, seller)
                            }
                        }
                    }
                }
              }
          }
       }

    private func cleanDataForCreateTest(seller: Seller, article: Article,
                                        completionHandler: @escaping (Error?) -> Void) {
       self.sellerAPI.removeHard(seller: seller) { (error) in
           if error != nil { completionHandler(FakeData.error)
           } else {
               self.articleAPI.removeHard(article: article, completionHandler: { (error) in
                   if error != nil { completionHandler(FakeData.error)
                   } else { completionHandler(nil)
                   }
               })
           }
       }

   }

    private func cleanDataForRemoveTest(seller: Seller,
                                        completionHandler: @escaping (Error?) -> Void) {
        self.sellerAPI.removeHard(seller: seller) { (error) in
            if error != nil { completionHandler(FakeData.error)
            } else { completionHandler(nil)
            }
        }

    }

    private func getDataUpdate(seller: Seller, purse: Purse,
                               completionHandler: @escaping (Error?, Purse?, Seller?) -> Void) {

        self.purseAPI.getPurse(name: purse.name) { (error, purseLoaded) in
            if error != nil { completionHandler(FakeData.error, nil, nil)
            } else {
                guard let purseAfterTesting = purseLoaded else {
                completionHandler(FakeData.error, nil, nil)
                return
            }
                self.sellerAPI.getSeller(uniqueID: seller.uniqueID) { (error, sellerLoaded) in
                    if error != nil { completionHandler(FakeData.error, nil, nil)
                    } else {
                        guard let sellerAfterTesting = sellerLoaded else {
                        completionHandler(FakeData.error, nil, nil)
                        return
                        }
                        completionHandler(nil, purseAfterTesting, sellerAfterTesting)
                    }
                }
            }
        }
    }

    private func getDataUpdateWithListOfArticle(
        seller: Seller, purse: Purse,
        completionHandler: @escaping (Error?, Purse?, Seller?, [Article]?) -> Void) {

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
                        self.articleAPI.getArticlesFor(seller: seller) { (error, articlesList) in
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
