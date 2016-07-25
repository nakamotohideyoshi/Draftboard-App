//
//  API.swift
//  Draftboard
//
//  Created by Anson Schall on 10/26/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation
import PromiseKit

final class API {
    private init() {}
}

private typealias API_Public = API
extension API_Public {
    
    static let agent = "Draftboard iOS" // + version?
    static let baseURL = "http://draftboard-staging.herokuapp.com/"

    class func request<T>(path: String, JSON: AnyObject? = nil) -> Promise<T> {
        let request = APIRequest(path, JSON: JSON)
        request.errorConditions = [API.InvalidTokenCondition]
        return API.promise(request)
    }
    
    class func get<T>(path: String) -> Promise<T> {
        return API.request(path)
    }
    
    class func post<T>(path: String, JSON: AnyObject) -> Promise<T> {
        return API.request(path, JSON: JSON)
    }
    
}

private typealias API_Private = API
private extension API_Private {

//    static var token: String?
    static var token: String? =
        // user1
//    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXIxIiwiZW1haWwiOiIiLCJleHAiOjE0NjYwMjMxMzAsIm9yaWdfaWF0IjoxNDYzNDMxMTMwLCJ1c2VyX2lkIjo1fQ.G7C5AALFOpvNNQesjSjGOgJogcK0bAcpW-62bwqVvwA"
    // user3
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmlnX2lhdCI6MTQ2OTIyOTIzNywidXNlcl9pZCI6NywidXNlcm5hbWUiOiJ1c2VyMyIsImV4cCI6MTQ3MTgyMTIzNywiZW1haWwiOiIifQ.yyeSzGgik7HuOmXe5BRnzrIDDhqKGTaowAWHdUYq5pE"

    
    class func promise<T>(request: APIRequest) -> Promise<T> {
        return firstly {
            return API.transmit(request)
        }.recover { error in
            return API.recover403(error)
        }.then { data in
            return API.deserialize(data)
        }
    }
    
    class func transmit(request: APIRequest) -> Promise<NSData> {
        request.auth()
        return Promise<NSData> { fulfill, reject in
            NSURLConnection.sendAsynchronousRequest(request, queue: Q) { (_response, _data, _error) in
                if let error = _error {
                    return reject(URLError.UnderlyingCocoaError(request, _data, _response, error))
                }
                guard let data = _data, response = _response as? NSHTTPURLResponse else {
                    return reject(URLError.BadResponse(request, _data, _response))
                }
                guard let string = String(data: data, encoding: NSUTF8StringEncoding) else {
                    return reject(URLError.StringEncoding(request, data, response))
                }
                for condition in request.errorConditions {
                    if let error = condition(request, data, string, response) {
                        reject(error)
                    }
                }
                fulfill(data)
            }
        }
    }
    
    class func recover403(error: ErrorType) -> Promise<NSData> {
        if case let APIError.InvalidToken(request) = error {
            // Log in, then continue the promise chain
            let login = RootViewController.sharedInstance.showLoginController()
            return login.then { () -> Promise<NSData> in
                return API.transmit(request)
            }
        }
        return Promise<NSData>(error: error)
    }

    class func deserialize<T>(data: NSData) -> Promise<T> {
        // Deserialize
        let object: AnyObject
        do {
            object = try NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments])
        } catch let error {
            let dataString = String(data: data, encoding: NSUTF8StringEncoding)
            return Promise<T>(error: APIError.InvalidJSON(dataString, error))
        }
        
        // Cast as T
        guard let objectT = object as? T else {
            return Promise<T>(error: APIError.JSONTypeMismatch(object, T.self))
        }
        
        return Promise(objectT)
    }
    
}

private typealias API_Endpoints = API
extension API_Endpoints {
    
    class func auth(username username: String, password: String) -> Promise<Void> {
        let path = "api-token-auth/"
        let params = ["username": username, "password": password]
        return API.post(path, JSON: params).then { (data: NSDictionary) -> Void in
            let token: String = try data.get("token")
            API.token = token
        }
    }
    
}

private extension APIRequest {
    
    func auth() {
        if let token = API.token {
            setValue("JWT " + token, forHTTPHeaderField: "Authorization")
        }
    }
    
}

private let Q = NSOperationQueue()
