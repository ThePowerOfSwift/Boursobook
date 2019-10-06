//
//  SaleAPITestCaseRealDB.swift
//  BoursobookTests
//
//  Created by David Dubez on 04/10/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import XCTest
@testable import Boursobook

class SaleAPITestCaseRealDB: XCTestCase {
    // Test with real remote DataBase FIREBASE (development)

    let purseAPI = PurseAPI()
    let userAPI = UserAuthAPI()
    let sellerAPI = SellerAPI()
    let articleAPI = ArticleAPI()
    let saleAPI = SaleAPI()

// MARK: - Test createNewSale function
    func testCreateRealSaleSouldSucceed() {

        let user = FakeData.user

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
                        // Create a new sale
                        self.saleAPI.createNewSale(purse: purseBeforeTesting, user: user) { (error, createdSale) in
                             if error != nil {  XCTFail("error in creating new sale")
                             } else {
                                guard let createdSale = createdSale else {
                                    XCTFail("error in creating new sale")
                                    return
                                }

                                //Then
                                XCTAssertEqual(createdSale.purseName, purseBeforeTesting.name)
                                XCTAssertEqual(createdSale.madeByUser, user.email)
                                // Get the final state of "Purse For Unit Testing"
                                self.purseAPI.getPurse(name: "Purse For Unit Testing") { (error, purseLoaded) in
                                    if error != nil { XCTFail("error in get the test purse")
                                    } else {
                                     guard let purseAfterTesting = purseLoaded else {
                                         XCTFail("error in get the test purse")
                                         return
                                     }
                                    XCTAssertEqual(purseAfterTesting.numberOfSales,
                                                   purseBeforeTesting.numberOfSales + 1)

                                     //Delete Sale Created
                                        self.saleAPI.removeHard(sale: createdSale) { (error) in
                                            if error != nil { XCTFail("error in deleting new sale")
                                            }
                                            self.saleAPI.stopListen()
                                            expectation.fulfill()
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

// MARK: - Test "updateDataforArticleSold" function

    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    func testUpdateRealSaleSouldSucceed() {

        let article = FakeData.firstArticleNotSold
        let sale = FakeData.sale
        let seller = FakeData.seller

        //Given
        // Login into FireBase
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        self.userAPI.signInUser(email: PrivateKey.userMail, password: PrivateKey.userPassword) { (error, _) in
            if error != nil { XCTFail("error whin login")
                } else {

                // Get the initial state of "Purse For Unit Testing"
                self.purseAPI.getPurse(name: "Purse For Unit Testing") { (error, purseLoaded) in
                    if error != nil { XCTFail("error in get the test purse")
                       } else {
                        guard let purseBeforeTesting = purseLoaded else {
                            XCTFail("error in get the test purse")
                            return
                        }

                        self.setInitialState(seller: seller, article: article, purse: purseBeforeTesting,
                                             sale: sale) { (error, sale) in

                        if error != nil { XCTFail("error in create seller")
                        } else if let sale = sale {

                            //When
                        // uptade data in database with the article sold
                        self.saleAPI.updateDataforArticleSold(
                            article: article, sale: sale,
                            purse: purseBeforeTesting) { (error) in
                                if error != nil { XCTFail("error in update article")
                                } else {

                                    //Then
                                    // Load updated data from data base
                                    // and test if the data had been correctly updated
                                    // Test purse update
                                    self.purseAPI.getPurse(name: "Purse For Unit Testing") { (error, purseLoaded) in
                                               if error != nil { XCTFail("error in test purse")
                                           } else {
                                               guard let purseAfterTesting = purseLoaded else {
                                                   XCTFail("error in test purse")
                                                   return
                                               }
                                               XCTAssertEqual(purseAfterTesting.numberOfArticlesold,
                                                              purseBeforeTesting.numberOfArticlesold + 1)
                                               XCTAssertEqual(purseAfterTesting.totalBenefitOnSalesAmount,
                                                              purseBeforeTesting.totalBenefitOnSalesAmount
                                                                + article.price
                                                                   * purseBeforeTesting.percentageOnSales * 0.01)
                                               XCTAssertEqual(purseAfterTesting.totalSalesAmount,
                                                              purseBeforeTesting.totalSalesAmount + article.price)

                                    // Test article update
                                    self.articleAPI.getArticle(uniqueID: article.uniqueID) { (error, updatedArticle) in
                                                                       if error != nil {
                                                                           XCTFail("error in test article")
                                                                       } else {
                                                                       guard let updatedArticle = updatedArticle else {
                                                                           XCTFail("error in test article")
                                                                           return
                                                                           }
                                                                           XCTAssertEqual(updatedArticle.sold, true)

                                    // Test seller update
                                    self.sellerAPI.getSeller(uniqueID: seller.uniqueID) { (error, updatedSeller) in
                                            if error != nil {
                                                XCTFail("error in test seller")
                                                } else {
                                            guard let updatedSeller = updatedSeller else {
                                                XCTFail("error in test seller")
                                                return
                                                }
                                                XCTAssertEqual(updatedSeller.articlesold, seller.articlesold + 1)
                                                XCTAssertEqual(updatedSeller.salesAmount, seller.salesAmount
                                                    + article.price - article.price
                                                    * purseBeforeTesting.percentageOnSales * 0.01)

                                    // Test sale update
                                    self.saleAPI.getSale(uniqueID: sale.uniqueID) { (error, updatedSale) in
                                            if error != nil {
                                                XCTFail("error in test sale")
                                                } else {
                                            guard let updatedSale = updatedSale else {
                                                XCTFail("error in test sale")
                                                return
                                                }
                                                XCTAssertEqual(updatedSale.amount, sale.amount + article.price)
                                                XCTAssertEqual(updatedSale.numberOfArticle, sale.numberOfArticle + 1)
                                                XCTAssert(updatedSale.articlesUniqueID.contains(article.uniqueID))

                                                // Clean all data created
                                                self.cleanDataCreatedForTestseller(seller: seller, article: article,
                                                                              sale: sale) { (error) in
                                                    if error != nil { XCTFail("error in remove data")
                                                    } else {
                                                    expectation.fulfill()
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
                                 sale: Sale,
                                 completionHandler: @escaping (Error?, Sale?) -> Void) {

        let user = FakeData.user

        //Create a seller
        sellerAPI.createSeller(newSeller: seller, in: purse) { (error) in
            if error != nil {
                completionHandler(FakeData.error, nil)
            } else {
                //Create a article
                self.articleAPI.createArticle(purse: purse, seller: seller, article: article) { (error) in
                    if error != nil {
                        completionHandler(FakeData.error, nil)
                    } else {
                        //Create a sale
                        self.saleAPI.createNewSale(purse: purse, user: user) { (error, sale) in
                            if error != nil {
                                completionHandler(FakeData.error, nil)
                        } else {
                                guard let sale = sale else {
                                    completionHandler(FakeData.error, nil)
                                    return
                                }
                                completionHandler(nil, sale)
                            }
                        }
                    }
                }
            }
        }
    }

    private func cleanDataCreatedForTestseller(seller: Seller,
                                               article: Article,
                                               sale: Sale,
                                               completionHandler: @escaping (Error?) -> Void) {
        self.sellerAPI.removeHard(seller: seller) { (error) in
            if error != nil {
                completionHandler(FakeData.error)
            } else {
                self.articleAPI.removeHard(article: article, completionHandler: { (error) in
                    if error != nil {
                         completionHandler(FakeData.error)
                    } else {
                        self.saleAPI.removeHard(sale: sale) { (error) in
                            if error != nil {
                                 completionHandler(FakeData.error)
                            } else {
                                completionHandler(nil)
                            }
                        }
                    }
                })
            }
        }

    }

}
