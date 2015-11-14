//
//  API.swift
//  Draftboard
//
//  Created by Anson Schall on 10/26/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation

final class API {
    
    private static var session = NSURLSession.sharedSession()
    private static let baseURL = "http://" +
//        "noodle.local:8080/"
        "rio-dfs.herokuapp.com/"
    
    // Do not instantiate
    private init() {}
    
    private class func http(path: String, method: String, parameters: NSDictionary, completion: (data: NSData, response: NSHTTPURLResponse) -> Void) {

        // Build query string
        let p = parameters as! [String: String]
        let q = p.map() {$0 + "=" + $1}.joinWithSeparator("&")

        // Build request
        let request = NSMutableURLRequest()
        request.HTTPMethod = method
        if method == "GET" {
            let query = (q == "") ? "" : "?" + q
            request.URL = NSURL(string: API.baseURL + path + query)!
        }
        if method == "POST" {
            request.URL = NSURL(string: API.baseURL + path)!
            request.HTTPBody = q.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        // Submit request
        API.session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if error != nil {
                print(error)
                return
            }
            completion(data: data!, response: response as! NSHTTPURLResponse)
        }).resume()

    }
    
    private class func endpoint(path: String, method: String, parameters: NSDictionary, completion: (AnyObject) -> Void) {
        API.http(path, method: method, parameters: parameters, completion: { data, response in
            // Unauthorized
            if response.statusCode == 403 {
                API.auth(completion: {
                    API.endpoint(path, method: method, parameters: parameters, completion: completion)
                })
            }
            // Probably 200 OK
            else {
                // JSON response
                if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
                    completion(json)
                }
                // Probably HTML response
                else {
                    let str = String(data: data, encoding: NSUTF8StringEncoding)!
                    if str.containsString("This is not yet available to the public.") {
                        API.preAuth(completion: {
                            API.endpoint(path, method: method, parameters: parameters, completion: completion)
                        })
                    }
                    else {
                        completion(str)
                    }
                }
            }
        })
    }
    
    private class func get(path: String, parameters: NSDictionary = [:], completion: (AnyObject) -> Void) {
        API.endpoint(path, method: "GET", parameters: parameters, completion: completion)
    }
    
    private class func post(path: String, parameters: NSDictionary = [:], completion: (AnyObject) -> Void) {
        API.endpoint(path, method: "POST", parameters: parameters, completion: completion)
    }
    
}

// MARK: - Authentication

extension API {

    // Get a JWT token and use it in auth header from now on
    class func auth(completion completion: () -> Void) {
        let params = ["username": "admin", "password": "admin"]
        API.post("api-token-auth/", parameters: params, completion: { json in
            let dict = json as! NSDictionary
            let token = dict["token"] as! String
            
            let config = API.session.configuration
            config.HTTPAdditionalHeaders = ["Authorization": "JWT " + token]
            API.session = NSURLSession(configuration: config)
            
            completion()
        })
    }
    
    // Get past the "garden wall"
    class func preAuth(completion completion: () -> Void) {
        let params = ["password": "gpp"]
        // Automatically picks up session cookie
        API.post("", parameters: params, completion: { _ in completion() })
    }
    
}

// MARK: - General accessors

extension API {

    class func draftGroup(id id: Int, completion: (AnyObject) -> Void) {
        API.get("api/draft-group/\(id)/", completion: completion)
    }

}
