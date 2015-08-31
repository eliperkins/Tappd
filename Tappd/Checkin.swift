//
//  Checkin.swift
//  Tappd
//
//  Created by Eli Perkins on 8/29/15.
//  Copyright © 2015 Eli Perkins. All rights reserved.
//

import Foundation

struct Checkin {
    let user: User
    let beer: Beer
    let venue: Venue?
    let rating: Float
    let note: String
    let createdOn: NSDate
}