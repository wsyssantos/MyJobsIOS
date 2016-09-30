//
//  ServiceTests.swift
//  OffersLeadExample
//
//  Created by Wesley on 9/4/16.
//  Copyright © 2016 Wesley. All rights reserved.
//

import XCTest
@testable import OffersLeadExample

class ServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGetURLsFromEndPointNotNil() {
        let baseService:BaseService = BaseService()
        let expectation = self.expectation(description: "BaseService")
        baseService.getCustomURL("https://dl.dropboxusercontent.com/u/20501812/MyJobsService/index",
            callback: { (dict: NSDictionary) -> (Void) in
                XCTAssertNotNil(dict)
                expectation.fulfill()
            }, errorCallback:
            {(e:NSError) -> (Void) in
                print("\(e)")
            })
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testGetOffersNotNil() {
        let baseService:BaseService = BaseService()
        let expectation = self.expectation(description: "Offers")
        baseService.getCustomURL("https://dl.dropboxusercontent.com/u/20501812/MyJobsService/offers",
            callback: { (dict:NSDictionary) -> (Void) in
                XCTAssertNotNil(dict)
                expectation.fulfill()
            },
            errorCallback: { (e:NSError) -> (Void) in
                print("\(e)")
            })
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testGetLeadsNotNil() {
        let baseService:BaseService = BaseService()
        let expectation = self.expectation(description: "Offers")
        baseService.getCustomURL("https://dl.dropboxusercontent.com/u/20501812/MyJobsService/leads",
            callback: { (dict:NSDictionary) -> (Void) in
                XCTAssertNotNil(dict)
                expectation.fulfill()
            },
            errorCallback: { (e:NSError) -> (Void) in
                print("\(e)")
            })
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testGetOffers404Error() {
        let baseService:BaseService = BaseService()
        let expectation = self.expectation(description: "Offers")
        baseService.getCustomURL("https://dl.dropboxusercontent.com/u/20501812/MyJobsService/offers/1",
            callback: { (dict:NSDictionary) -> (Void) in
            },
            errorCallback: { (e:NSError) -> (Void) in
                XCTAssertNotNil(e)
                expectation.fulfill()
            })
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testGetLeadsDetailNotNil() {
        let baseService:BaseService = BaseService()
        let expectation = self.expectation(description: "Offers")
        baseService.getCustomURL("https://dl.dropboxusercontent.com/u/20501812/MyJobsService/lead-1",
            callback: { (dict:NSDictionary) -> (Void) in
                XCTAssertNotNil(dict)
                expectation.fulfill()
            },
                errorCallback: { (e:NSError) -> (Void) in
                print("\(e)")
            })
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testGetOfferDetailNotNil() {
        let baseService:BaseService = BaseService()
        let expectation = self.expectation(description: "Offers")
        baseService.getCustomURL("https://dl.dropboxusercontent.com/u/20501812/MyJobsService/offer-1",
            callback: { (dict:NSDictionary) -> (Void) in
                XCTAssertNotNil(dict)
                expectation.fulfill()
            },
            errorCallback: { (e:NSError) -> (Void) in
                print("\(e)")
            })
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
