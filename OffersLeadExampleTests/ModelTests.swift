//
//  ModelTests.swift
//  OffersLeadExample
//
//  Created by Wesley on 9/4/16.
//  Copyright © 2016 Wesley. All rights reserved.
//

import XCTest
@testable import OffersLeadExample

class ModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testLoadOfferListFromServiceAndWrap() {
        let baseService:BaseService = BaseService()
        let expectation = self.expectation(description: "Offers")
        baseService.getCustomURL("https://dl.dropboxusercontent.com/u/20501812/MyJobsService/offers",
            callback: { (dict: NSDictionary) -> (Void) in
                let offers = dict["offers"]! as? NSArray
                var offerList = [Offer]()
                
                for offDict in offers! {
                    let offer = Offer(dict: offDict as! NSDictionary, detail: false)
                    XCTAssertNotNil(offer)
                    offerList.append(offer)
                }
                XCTAssert(offerList.count > 0, "")
                expectation.fulfill()
            },
            errorCallback: { (e:NSError) -> (Void) in
                print("\(e)")
            })
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testLoadOfferDetailFromServiceAndWrap() {
        let baseService:BaseService = BaseService()
        let expectation = self.expectation(description: "Offers")
        baseService.getCustomURL("https://dl.dropboxusercontent.com/u/20501812/MyJobsService/offer-1",
            callback: { (dict: NSDictionary) -> (Void) in
                let offer = Offer(dict: dict, detail: true)
                XCTAssertNotNil(offer)
                expectation.fulfill()
            },
            errorCallback: { (e:NSError) -> (Void) in
                print("\(e)")
            })
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testLoadLeadListFromServiceAndWrap() {
        let baseService:BaseService = BaseService()
        let expectation = self.expectation(description: "Offers")
        baseService.getCustomURL("https://dl.dropboxusercontent.com/u/20501812/MyJobsService/leads",
            callback: { (dict: NSDictionary) -> (Void) in
                let leads = dict["leads"]! as? NSArray
                var leadList = [Lead]()
                                    
                for offDict in leads! {
                    let offer = Lead(dict: offDict as! NSDictionary, detail: false)
                    XCTAssertNotNil(offer)
                    leadList.append(offer)
                }
                XCTAssert(leadList.count > 0, "")
                expectation.fulfill()
            },
            errorCallback: { (e:NSError) -> (Void) in
                print("\(e)")
            })
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testLoadLeadDetailFromServiceAndWrap() {
        let baseService:BaseService = BaseService()
        let expectation = self.expectation(description: "Offers")
        baseService.getCustomURL("https://dl.dropboxusercontent.com/u/20501812/MyJobsService/lead-1",
            callback: { (dict: NSDictionary) -> (Void) in
                let lead = Lead(dict: dict, detail: true)
                XCTAssertNotNil(lead)
                expectation.fulfill()
            },
            errorCallback: { (e:NSError) -> (Void) in
                print("\(e)")
            })
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
