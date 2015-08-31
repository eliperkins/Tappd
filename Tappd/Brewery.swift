//
//  Brewery.swift
//  Tappd
//
//  Created by Eli Perkins on 8/29/15.
//  Copyright © 2015 Eli Perkins. All rights reserved.
//

import Foundation
import Argo
import Curry

public struct Brewery {
    public let id: Int
}

extension Brewery: Decodable {
    public static func decode(json: JSON) -> Decoded<Brewery> {
        return curry(self.init)
            <^> json <| "brewery_id"
    }
}