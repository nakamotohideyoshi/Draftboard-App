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
    #if Staging
        static let baseURL = "https://staging.draftboard.com/"
    #else
        static let baseURL = "https://www.draftboard.com/"
    #endif
//    static let baseURL = "http://192.168.0.104:8000/"
//    static let baseURL = "http://localhost:8000/"
//    static let baseURL = "https://delorean.draftboard.com/"
    
    static var username: String?

    class func request<T>(path: String, JSON: AnyObject? = nil) -> Promise<T> {
        let request = APIRequest(path, JSON: JSON)
        request.errorConditions = [API.InvalidTokenCondition, API.BadResponseCodeCondition]
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

    static var token: String?
//    static var token: String? =
        // user1
//    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXIxIiwiZW1haWwiOiIiLCJleHAiOjE0NjYwMjMxMzAsIm9yaWdfaWF0IjoxNDYzNDMxMTMwLCJ1c2VyX2lkIjo1fQ.G7C5AALFOpvNNQesjSjGOgJogcK0bAcpW-62bwqVvwA"
    // user3
//    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6IiIsIm9yaWdfaWF0IjoxNDczMTEwMDM5LCJ1c2VyX2lkIjo3LCJleHAiOjE0NzU3MDIwMzksInVzZXJuYW1lIjoidXNlcjMifQ.8r-kNc_nDqMuN3-h5Rayk-_azNBtO6mifZItUAxm26g"

    
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
                guard let data = _data, let response = _response as? NSHTTPURLResponse else {
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
        } else if case let URLError.UnderlyingCocoaError(request, _, _, err) = error {
            let vc = ErrorViewController(nibName: "ErrorViewController", bundle: nil)
            let actions = ["Try Again"]
            
            vc.actions = actions
            vc.promise.then { index -> Promise<NSData> in
                RootViewController.sharedInstance.popAlertViewController()
                return API.transmit(request as! APIRequest)
            }
            
            RootViewController.sharedInstance.pushAlertViewController(vc)
            vc.errorLabel.text = "Please check your network connection and try again!"
        }
        return Promise<NSData>(error: error)
    }

    class func deserialize<T>(data: NSData) -> Promise<T> {
        let deserialized = (try? NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments])) ??
            String(data: data, encoding: NSUTF8StringEncoding)

        // Deserialize or try as String
        guard let object = deserialized else {
            return Promise<T>(error: APIError.InvalidJSON(data))
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
    
    class func auth(username username: String, password: String, remember: Bool) -> Promise<Void> {
        let path = "api-token-auth/"
        let params = ["username": username, "password": password]
        return API.post(path, JSON: params).then { (data: NSDictionary) -> Void in
            let token: String = try data.get("token")
            API.token = token
            API.username = username
            if remember {
                NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    class func signup(firstname firstname: String, lastname: String, username: String, email: String, password: String, birthYear: String, birthMonth: String, birthDay: String, zipcode: String) -> Promise<Void> {
        let path = "api/account/register/"
        let params = ["first": firstname, "last": lastname, "username": username, "email": email, "password": password, "birth_year": birthYear, "birth_month": birthMonth, "birth_day": birthDay, "postal_code": zipcode]
        return API.post(path, JSON: params).then { (data: NSDictionary) -> Void in
            
        }
    }
    
    class func deauth() {
        API.token = nil
        API.username = nil
        NSUserDefaults.standardUserDefaults().removeObjectForKey("token")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
}

private extension APIRequest {
    
    func auth() {
        if let token = API.token {
            setValue("JWT " + token, forHTTPHeaderField: "Authorization")
        } else if let token = NSUserDefaults.standardUserDefaults().stringForKey("token") {
            setValue("JWT " + token, forHTTPHeaderField: "Authorization")
            API.token = token
            API.username = NSUserDefaults.standardUserDefaults().stringForKey("username")
        }
    }
    
}

private let Q = NSOperationQueue()
