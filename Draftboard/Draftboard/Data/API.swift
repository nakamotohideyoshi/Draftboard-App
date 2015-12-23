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
    
    private static var session = NSURLSession.sharedSession()
    private static let baseURL = "http://" +
//        "noodle.local:8080/"
//        "rio-dfs.herokuapp.com/"
        "draftboard-ios-sandbox.herokuapp.com/"
    private static var token: String?
    
    // Do not instantiate
    private init() {}
    
    private class func http(path: String, method: String, parameters: NSDictionary, paramsAsJSON: Bool = false, completion: (data: NSData, response: NSHTTPURLResponse) -> Void) {
        var q: String = ""
        if paramsAsJSON {
            // Dump JSON
            let json = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
            q = String(data: json, encoding: NSUTF8StringEncoding)!
        }
        else {
            // Build query string
            let p = parameters as! [String: String]
            q = p.map() {$0 + "=" + $1}.joinWithSeparator("&")
        }

        // Build request
        let request = NSMutableURLRequest()
        request.HTTPMethod = method
        if paramsAsJSON {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        if let token = API.token {
            request.addValue("JWT " + token, forHTTPHeaderField: "Authorization")
        }
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
    
    private class func endpoint(path: String, method: String, parameters: NSDictionary, paramsAsJSON: Bool = false, completion: (AnyObject) -> Void) {
        API.http(path, method: method, parameters: parameters, paramsAsJSON: paramsAsJSON, completion: { data, response in
            // 403 Unauthorized
            if response.statusCode == 403 {
                API.auth(completion: {
                    API.endpoint(path, method: method, parameters: parameters, completion: completion)
                })
            }
            // 200 OK
            else if response.statusCode == 200 {
                // JSON response
                if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
                    completion(json)
                }
                // Probably HTML response
                else {
                    let str = String(data: data, encoding: NSUTF8StringEncoding)!
                    if str.containsString("This is not yet available to the public.") {
                        API.preAuth(completion: {
                            API.endpoint(path, method: method, parameters: parameters, paramsAsJSON: paramsAsJSON, completion: completion)
                        })
                    }
                    else {
                        completion(str)
                    }
                }
            }
            else {
                print("Unhandled HTTP status code in API response")
            }
        })
    }
    
    private class func get(path: String, parameters: NSDictionary = [:], paramsAsJSON: Bool = false, completion: (AnyObject) -> Void) {
        API.endpoint(path, method: "GET", parameters: parameters, paramsAsJSON: paramsAsJSON, completion: completion)
    }
    
    private class func post(path: String, parameters: NSDictionary = [:], paramsAsJSON: Bool = false, completion: (AnyObject) -> Void) {
        API.endpoint(path, method: "POST", parameters: parameters, paramsAsJSON: paramsAsJSON, completion: completion)
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
            
            API.token = token
            
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
    class func draftGroupUpcoming() -> Promise<[DraftGroup]> {
        return Promise { fulfill, reject in
            API.get("api/draft-group/upcoming/") { json in
                guard let data = json as? [NSDictionary]
                else { return }
                
                var draftGroups = [DraftGroup]()
                for draftGroupDict in data {
                    if let draftGroup = DraftGroup(data: draftGroupDict) {
                        draftGroups.append(draftGroup)
                    }
                }
                fulfill(draftGroups)
            }
        }
    }

    class func draftGroup(id id: Int) -> Promise<DraftGroup> {
        return Promise { fulfill, reject in
            API.get("api/draft-group/\(id)/") { json in
                guard let data = json as? NSDictionary,
                    players = data["players"] as? [NSDictionary],
                    draftGroup = DraftGroup(data: data)
                else { return }

                draftGroup.players = [Player]()
                for playerDict in players {
                    if let player = Player(data: playerDict) {
                        draftGroup.players.append(player)
                    }
                }
                fulfill(draftGroup)
            }
        }
    }
    
    class func contestLobby() -> Promise<[Contest]> {
        return Promise { fulfill, reject in
            API.get("api/contest/lobby/") { json in
                guard let data = json as? [NSDictionary]
                else { return }
                
                var contests = [Contest]()
                for contestDict in data {
                    if let contest = Contest(data: contestDict) {
                        contests.append(contest)
                    }
                }
                fulfill(contests)
            }
        }
    }
    
    class func sportsInjuries(sportName: String) -> Promise<[Int: String]> {
        return Promise { fulfill, reject in
            API.get("api/sports/injuries/\(sportName)/") { json in
                guard let data = json as? [NSDictionary]
                else { return }
                
                var injuries = [Int: String]()
                for injuryDict in data {
                    guard let playerID = injuryDict["player_id"] as? Int,
                        status = injuryDict["status"] as? String
                    else { continue }
                    injuries[playerID] = status
                }
                fulfill(injuries)
            }
        }
    }
    
    class func lineupCreate(lineup: Lineup) {
        let postData = NSMutableDictionary()
        postData["name"] = lineup.name
        postData["players"] = lineup.players.map {$0?.id ?? 0}
        postData["draft_group"] = lineup.draftGroup.id
        API.post("api/lineup/create/", parameters: postData, paramsAsJSON: true) { _ in }
    }
}
