//
//  Client.swift
//  Tappd
//
//  Created by Eli Perkins on 8/29/15.
//  Copyright © 2015 Eli Perkins. All rights reserved.
//

import Foundation
import Alamofire
import Argo
import Result

public typealias AccessToken = String

public struct Client {
    public enum Authentication {
        case AccessToken(String)
        case ClientKeyAndSecret(String, String)
    }
    
    public let authentication: Authentication
    
    private static var authCompletion: (ClientResult -> Void)?
    
    public init(accessToken: AccessToken) {
        self.authentication = .AccessToken(accessToken)
    }
    
    public init(clientKey: String, clientSecret: String) {
        self.authentication = .ClientKeyAndSecret(clientKey, clientSecret)
    }
    
    public static func clientFromWebAuth(clientKey: String, redirectURL: NSURL, completion: (ClientResult -> Void)) {
        // https://untappd.com/oauth/authenticate/?client_id=CLIENTID&response_type=token&redirect_url=REDIRECT_URL
        let URLString = "https://untappd.com/oauth/authenticate/?client_id=\(clientKey)&response_type=token&redirect_url=\(redirectURL.absoluteString)"
        guard let URL = NSURL(string: URLString) else { return }
        UIApplication.sharedApplication().openURL(URL)
        authCompletion = completion
    }
    
    public static func completeWebAuth(callbackURL: NSURL) {
        let accessTokenFragment = callbackURL.absoluteString.characters.split { $0 == "#" }.map(String.init).last
        if let accessTokenFragment = accessTokenFragment {
            let accessToken = accessTokenFragment.characters.split { $0 == "=" }.map(String.init).last
            
            if let accessToken = accessToken {
                let client = Client(accessToken: accessToken)
                authCompletion?(.Success(client))
            }
        } else {
            // auth failed
        }
        authCompletion = nil
    }
    
    var defaultParameters: [String:AnyObject] {
        switch authentication {
        case .AccessToken(let accessToken): return ["access_token" : accessToken]
        case .ClientKeyAndSecret(let key, let secret): return ["client_id" : key, "client_secret" : secret]
        }
    }
    
    public func fetchBeer(id: Int, completion: (BeerResult -> Void)) -> Request {
        let URLString = "https://api.untappd.com/v4/beer/info/\(id)"
        let request = Alamofire.request(.GET, URLString, parameters: defaultParameters, encoding: .URL, headers: nil)
        
        request.responseJSON { (request, response, result) -> Void in
            switch result {
            case .Success(let JSON):
                guard let responseData = JSON["response"] as? [String:AnyObject], beerData = responseData["beer"] as? [String:AnyObject] else {
                    let failureReason = "JSON could not be serialized because input data was nil."
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    completion(.Failure(.AlamofireError(error)))
                    break
                }
                let beer: Decoded<Beer> = decode(beerData)
                switch beer {
                case .Success(let beer):
                    completion(.Success(beer))
                case .MissingKey(let failureReason):
                    completion(.Failure(.ArgoError(failureReason)))
                case .TypeMismatch(let failureReason):
                    completion(.Failure(.ArgoError(failureReason)))
                }
            case .Failure(let (_, error)):
                completion(.Failure(.GenericError(error)))
            }
        }
        
        return request
    }
    
    public func searchBeer(query: String, completion: (SearchResultsResult -> Void)) -> Request {
        let URLString = "https://api.untappd.com/v4/search/beer"
        var parameters = defaultParameters
        parameters["q"] = query
        
        let request = Alamofire.request(.GET, URLString, parameters: parameters, encoding: .URL, headers: nil)
        
        request.responseJSON { (request, response, result) -> Void in
            switch result {
            case .Success(let JSON):
                guard let responseData = JSON["response"] as? [String:AnyObject] else {
                    let failureReason = "JSON could not be serialized because input data was nil."
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    completion(.Failure(.AlamofireError(error)))
                    break
                }
                let beer: Decoded<SearchResults> = decode(responseData)
                switch beer {
                case .Success(let searchResults):
                    completion(.Success(searchResults))
                case .MissingKey(let failureReason):
                    completion(.Failure(.ArgoError(failureReason)))
                case .TypeMismatch(let failureReason):
                    completion(.Failure(.ArgoError(failureReason)))
                }
            case .Failure(let (_, error)):
                completion(.Failure(.GenericError(error)))
            }
        }
        
        return request
    }
}

public enum AuthError: ErrorType {
    case IncompleteRedirect
}

public enum APIError: ErrorType {
    case AlamofireError(NSError)
    case ArgoError(String)
    case GenericError(ErrorType)
}
