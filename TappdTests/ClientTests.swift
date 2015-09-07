//
//  TappdTests.swift
//  TappdTests
//
//  Created by Eli Perkins on 8/29/15.
//  Copyright © 2015 Eli Perkins. All rights reserved.
//

import XCTest
@testable import Tappd

class ClientTests: XCTestCase {
    
    let testKey = "FEF84A78A8E8D81871064E2A12D397B04E95CD42"
    let testSecret = "0BD9416CD8D1FC63C1931D352F6B4C72D73FAB9C"
    
    func testBeer() {
        let expectation = expectationWithDescription("test-beer")
        let client = Client(clientKey: testKey, clientSecret: testSecret)

        client.fetchBeer(4691) { result in
            switch result {
            case .Success(let beer):
                XCTAssertEqual(beer.name, "Heady Topper")
            case .Failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error) -> Void in

        }
    }
    
//    func testSearch() {
//        let expectation = expectationWithDescription("test-beer")
//        let client = Client(clientKey: testKey, clientSecret: testSecret)
//        
//        client.searchBeer("Pliny") { result in
//            switch result {
//            case .Success(let searchResults):
//                XCTAssertEqual(searchResults.beers.count, 3)
//            case .Failure(_):
//                XCTFail()
//            }
//            expectation.fulfill()
//        }
//        
//        waitForExpectationsWithTimeout(10) { (error) -> Void in
//            request.cancel()
//        }
//    }
//    
}
