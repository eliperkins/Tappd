//
//  BeerResult.swift
//  Tappd
//
//  Created by Eli Perkins on 8/29/15.
//  Copyright © 2015 Eli Perkins. All rights reserved.
//

import Foundation
import Result

// Workaround for:
// https://github.com/antitypical/Result/issues/77
// http://openradar.appspot.com/19774567
// http://openradar.appspot.com/20633559

public struct ResultResult<T, Error : ErrorType> {
    public typealias t = Result<T, Error>
}

public typealias BeerResult = ResultResult<Beer, APIError>.t
public typealias SearchResultsResult = ResultResult<SearchResults, APIError>.t
public typealias ClientResult = ResultResult<Client, AuthError>.t
