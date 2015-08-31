//
//  Search.swift
//  Tappd
//
//  Created by Eli Perkins on 8/29/15.
//  Copyright © 2015 Eli Perkins. All rights reserved.
//

import Foundation
import Argo
import Curry

public struct SearchResults {
    public let beers: [QueriedBeer]
//    public let homebrewedBeers: [QueriedBeer]
//    public let breweries: [Brewery]
    public let parsedTerm: String
}

public struct QueriedBeer {
    public let item: Beer
    public let haveHad: Bool
    public let checkinCount: Int
    public let yourCount: Int
}

extension SearchResults: Decodable {
    public static func decode(json: JSON) -> Decoded<SearchResults> {
        return curry(self.init)
            <^> json <|| ["beers", "items"]
//            <*> json <|| "homebrew"
//            <*> json <|| "breweries"
            <*> json <| "parsed_term"
    }
}

extension QueriedBeer: Decodable {
    public static func decode(json: JSON) -> Decoded<QueriedBeer> {
        return curry(self.init)
            <^> json <| "beer"
            <*> json <| "have_had"
            <*> json <| "checkin_count"
            <*> json <| "your_count"
    }
}
