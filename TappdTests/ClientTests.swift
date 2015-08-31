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
    
    let testKey = "xxx"
    let testSecret = "yyy"
    
    func testBeer() {
        let expectation = expectationWithDescription("test-beer")
        let client = Client(clientKey: testKey, clientSecret: testSecret)

        let request = client.fetchBeer(4691) { result in
            switch result {
            case .Success(let beer):
                XCTAssertEqual(beer.name, "Heady Topper")
            case .Failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error) -> Void in
            request.cancel()
        }
    }
    
    func testSearch() {
        let expectation = expectationWithDescription("test-beer")
        let client = Client(clientKey: testKey, clientSecret: testSecret)
        
        let request = client.searchBeer("Pliny") { result in
            switch result {
            case .Success(let searchResults):
                XCTAssertEqual(searchResults.beers.count, 3)
            case .Failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10) { (error) -> Void in
            request.cancel()
        }
    }
    
}
