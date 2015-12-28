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
    private static let baseURL = "http://draftboard-ios-sandbox.herokuapp.com/"
    private static var token: String?
    
    // Do not instantiate
    private init() {}
    
    private class func http(path: String, method: String, parameters: NSDictionary, completion: (data: NSData, response: NSHTTPURLResponse) -> Void) {
        let request = NSMutableURLRequest()
        request.HTTPMethod = method
        request.URL = NSURL(string: API.baseURL + path)!
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Method-specific
        if method == "GET" {
            // No handling of parameters!
        }
        if method == "POST" {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Authentication
        if let token = API.token {
            request.addValue("JWT " + token, forHTTPHeaderField: "Authorization")
        }

        // Make request
        API.session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let error = error {
                print(error)
            } else {
                completion(data: data!, response: response as! NSHTTPURLResponse)
            }
        }).resume()
    }
    
    private class func endpoint(path: String, method: String, parameters: NSDictionary, completion: (AnyObject) -> Void) {
        API.http(path, method: method, parameters: parameters, completion: { data, response in
            // 403 Unauthorized
            if response.statusCode == 403 {
                API.auth(completion: {
                    API.endpoint(path, method: method, parameters: parameters, completion: completion)
                })
            }
            // 2XX
            else if response.statusCode / 100 == 2 {
                // JSON response
                if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
                    completion(json)
                }
                // Probably HTML response
                else {
                    print("Could not parse JSON in response")
                }
            }
            else {
                print("Unhandled HTTP status code in API response")
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
            
            API.token = token
            
            completion()
        })
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
        API.post("api/lineup/create/", parameters: postData) { _ in }
    }
    
    class func lineupUpcoming() -> Promise<[Lineup]> {
        return Promise { fulfill, reject in
            API.get("api/lineup/upcoming/") { json in
                guard let data = json as? [NSDictionary]
                else { return }
                
                var lineups = [Lineup]()
                for lineupDict in data {
                    if let lineup = Lineup(data: lineupDict) {
                        // Players
                        if let playersData = lineupDict["players"] as? [NSDictionary] {
                            var players = [Player?]()
                            for playerDict in playersData {
                                let player = Player(lineupData: playerDict)
                                players.append(player)
                            }
                            lineup.players = players
                        }
                        lineups.append(lineup)
                    }
                }
                // Temp
                if lineups.count > 0 {
                    let limitedLineupCount = lineups.count > 2 ? 2 : lineups.count - 1
                    let fewLineups: [Lineup] = lineups.reverse()[0...limitedLineupCount].reverse()
                    fulfill(fewLineups)
                } else {
                    fulfill(lineups)
                }
            }
        }
    }
}
