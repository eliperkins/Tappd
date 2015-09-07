//
//  Requests.swift
//  Tappd
//
//  Created by Eli Perkins on 9/7/15.
//  Copyright © 2015 Eli Perkins. All rights reserved.
//

import Result
import Argo
import Swish

struct FindBeerRequest: Request {
    typealias ResponseType = Beer
    
    let id: Int
    
    func build() -> NSURLRequest {
        let components = NSURLComponents(string: "https://api.untappd.com/v4/beer/info/\(id)")
        components?.queryItems = [NSURLQueryItem(name: "client_id", value: "FEF84A78A8E8D81871064E2A12D397B04E95CD42"), NSURLQueryItem(name: "client_secret", value: "0BD9416CD8D1FC63C1931D352F6B4C72D73FAB9C")]
        return NSURLRequest(URL: components!.URL!)
    }
    
    func parse(j: JSON) -> Result<ResponseType, NSError> {
        return .fromDecoded(j <| ["response", "beer"])
    }
}

extension Client {
    public func fetchBeer(id: Int, completion: (Result<Beer, NSError> -> Void)) {
        let request = FindBeerRequest(id: id)
        return client.performRequest(request, completionHandler: completion)
    }
}