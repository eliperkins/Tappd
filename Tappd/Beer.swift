//
//  Beer.swift
//  Tappd
//
//  Created by Eli Perkins on 8/29/15.
//  Copyright © 2015 Eli Perkins. All rights reserved.
//

import Foundation
import Argo
import Curry

// Making these all all-caps freaks out the Swift compiler
public typealias ABVs = Float
public typealias IBUs = Int

public struct Beer {
    public let id: Int

    public let name: String
    public let style: String
    public let ABV: ABVs
    public let IBU: IBUs
    
    public let inProduction: Bool?
    
    public let brewery: Brewery?
    
    public let labelURL: NSURL
    public let slug: String?
}

extension Beer: Decodable {
    public static func decode(json: JSON) -> Decoded<Beer> {
        return curry(self.init)
            <^> json <| "bid"
            <*> json <| "beer_name"
            <*> json <| "beer_style"
            <*> json <| "beer_abv"
            <*> json <| "beer_ibu"
            <*> json <|? "is_in_production"
            <*> json <|? "brewery"
            <*> json <| "beer_label"
            <*> json <|? "beer_slug"
    }
}

struct Stats {
    let totalCheckins: UInt
    let monthlyCheckins: UInt
    let totalUniqueUsers: UInt
}