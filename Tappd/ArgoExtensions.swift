//
//  ArgoExtensions.swift
//  Tappd
//
//  Created by Eli Perkins on 8/29/15.
//  Copyright © 2015 Eli Perkins. All rights reserved.
//

import Foundation
import Argo

extension NSURL : Decodable {
    public static func decode(j: JSON) -> Decoded<NSURL> {
        switch j {
        case let .String(n):
            guard let URL = NSURL(string: n) else { return typeMismatch("NSURL", forObject: j) }
            return pure(URL)
        default: return typeMismatch("NSURL", forObject: j)
        }
    }
}


private func typeMismatch<T>(expectedType: String, forObject object: JSON) -> Decoded<T> {
    return .TypeMismatch("\(object) is not a \(expectedType)")
}

private func guardNull(key: String, j: JSON) -> Decoded<JSON> {
    switch j {
    case .Null: return .MissingKey(key)
    default: return pure(j)
    }
}