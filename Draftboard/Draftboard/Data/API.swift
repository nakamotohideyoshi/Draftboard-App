//
//  API.swift
//  Draftboard
//
//  Created by Anson Schall on 10/26/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation
import PromiseKit

final class API { // Do not subclass
    private init() {} // Do not instantiate
}

// MARK: - Internal

private extension API {
    static let agent = "Draftboard iOS" // + version?
    static let baseURL = "http://draftboard-ios-sandbox.herokuapp.com/"
    //static var token: String?
    static var token: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjozLCJlbWFpbCI6IiIsInVzZXJuYW1lIjoiYWRtaW4iLCJvcmlnX2lhdCI6MTQ1NDAwNTQ0NiwiZXhwIjoxNDU2NTk3NDQ2fQ.QKFr2j5tpgI-rhNgflVhSnpY-KSPG1nbqbGI8IisMA8"
    
    class func request(path: String) -> NSMutableURLRequest {
        let rq = NSMutableURLRequest()
        rq.URL = NSURL(string: API.baseURL + path)!
        rq.setValue(API.agent, forHTTPHeaderField: "User-Agent")
        rq.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = API.token {
            rq.setValue("JWT " + token, forHTTPHeaderField: "Authorization")
        }
        return rq
    }
    
    class func promise(rq: NSMutableURLRequest) -> Promise<AnyObject> {
        return firstly {
            return NSURLConnection.promise(rq)
        }.recover { error in
            return API.recover403(error)
        }.then { data in
            return API.deserialize(data)
        }
    }
    
    class func recover403(error: ErrorType) -> Promise<NSData> {
        // Guard for a specific BadResponse error, kind of weird
        guard case let URLError.BadResponse(request, data, response) = error,
            let rq = request as? NSMutableURLRequest,
            d = data,
            r = response as? NSHTTPURLResponse,
            s = String(data: d, encoding: NSUTF8StringEncoding)
        where
            r.statusCode == 403 && s.containsString("Authentication")
        else { return Promise<NSData>(error: error) }
        
        // Log in, then continue the promise chain
        let login = RootViewController.sharedInstance.showLoginController()
        return login.then { () -> Promise<NSData> in
            rq.setValue("JWT " + API.token!, forHTTPHeaderField: "Authorization")
            return NSURLConnection.promise(rq)
        }
    }

    class func deserialize(data: NSData) -> Promise<AnyObject> {
        if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
            return Promise(json)
        }
        if let str = String(data: data, encoding: NSUTF8StringEncoding) {
            return Promise(str)
        }
        return Promise(error: APIError.Whatever)
    }

    class func get(path: String) -> Promise<AnyObject> {
        let rq = API.request(path)
        return API.promise(rq)
    }
    
    class func post(path: String, json: NSDictionary) -> Promise<AnyObject> {
        let rq = API.request(path)
        rq.HTTPMethod = "POST"
        rq.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(json, options: [])
        rq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return API.promise(rq)
    }
}


// MARK: - Authentication

extension API {
    class func auth(username username: String, password: String) -> Promise<Void> {
        let path = "api-token-auth/"
        let params = ["username": username, "password": password]
        return API.post(path, json: params).then { json in
            guard let data = json as? NSDictionary,
                let token = data["token"] as? String
            else { throw APIError.FailedToParse(json) }
            
            API.token = token
            print(token)
            
            return Promise()
        }
    }
}

// MARK: - General accessors

extension API {
    class func draftGroupUpcoming() -> Promise<[DraftGroup]> {
        let path = "api/draft-group/upcoming/"
        return API.get(path).then { json in
            guard let data = json as? [NSDictionary]
            else { throw APIError.FailedToParse(json) }
            
            var draftGroups = [DraftGroup]()
            for dict in data {
                if let draftGroup = DraftGroup(upcomingData: dict) {
                    draftGroups.append(draftGroup)
                } else {
                    throw APIError.FailedToModel(DraftGroup)
                }
            }
            
            return Promise(draftGroups)
        }
    }

    class func draftGroup(id id: Int) -> Promise<DraftGroup> {
        let path = "api/draft-group/\(id)/"
        return API.get(path).then { json in
            guard let data = json as? NSDictionary
            else { throw APIError.FailedToParse(json) }
            
            if let draftGroup = DraftGroup(idData: data) {
                return Promise(draftGroup)
            } else {
                throw APIError.FailedToModel(DraftGroup)
            }
        }
    }
    
    class func contestLobby() -> Promise<[Contest]> {
        let path = "api/contest/lobby/"
        return API.get(path).then { json in
            guard let data = json as? [NSDictionary]
            else { throw APIError.FailedToParse(json) }
            
            var contests = [Contest]()
            for dict in data {
                if let contest = Contest(data: dict) {
                    contests.append(contest)
                } else {
                    throw APIError.FailedToModel(Contest)
                }
            }
            return Promise(contests)
        }
    }
    
    class func contestEntries() -> Promise<[NSDictionary]> {
        let path = "api/contest/current-entries/"
        return API.get(path).then { json in
            guard let data = json as? [NSDictionary]
            else { throw APIError.FailedToParse(json) }
            return Promise(data)
        }
    }
    
    class func contestEnter(contest: Contest, lineup: Lineup) -> Promise<NSDictionary> {
        let path = "api/contest/enter-lineup/"
        let params = ["contest": contest.id, "lineup": lineup.id]
        return API.post(path, json: params).then { json in
            guard let data = json as? NSDictionary
            else { throw APIError.FailedToParse(json) }
            return Promise(data)
        }
    }
    
    class func sportsInjuries(sportName: String) -> Promise<[Int: String]> {
        let path = "api/sports/injuries/\(sportName)/"
        return API.get(path).then { json in
            guard let data = json as? [NSDictionary]
            else { throw APIError.FailedToParse(json) }
            
            var injuries = [Int: String]()
            for injuryDict in data {
                guard let playerID = injuryDict["player_id"] as? Int,
                    status = injuryDict["status"] as? String
                else { continue }
                injuries[playerID] = status
            }
            
            return Promise(injuries)
        }
    }

    class func lineupCreate(lineup: Lineup) {
        let path = "api/lineup/create/"
        let params = [
            "name": lineup.name,
            "players": lineup.players.map {$0?.id ?? 0},
            "draft_group": lineup.draftGroup.id
        ]
        API.post(path, json: params)
    }
    
    class func lineupUpcoming() -> Promise<[Lineup]> {
        let path = "api/lineup/upcoming/"
        return API.get(path).then { json in
            guard let data = json as? [NSDictionary]
            else { throw APIError.FailedToParse(json) }
            
            var lineups = [Lineup]()
            for dict in data {
                if let lineup = Lineup(upcomingData: dict) {
                    lineups.append(lineup)
                } else {
                    throw APIError.FailedToModel(Lineup)
                }
            }
            return Promise(lineups)

//            // Temp
//            if lineups.count > 3 {
//                let fewLineups = [Lineup](lineups.suffix(3))
//                fulfill(fewLineups)
//            } else {
//                fulfill(lineups)
//            }
        }
    }
    
    class func prizeStructure(id id: Int) -> Promise<[NSDictionary]> {
        let path = "api/prize/\(id)/"
        return API.get(path).then { json in
            guard let data = json as? NSDictionary,
                ranks = data["ranks"] as? [NSDictionary]
            else { throw APIError.FailedToParse(json) }
            
            var payouts = [NSDictionary]()
            for position in ranks {
                guard let rank = position["rank"] as? Int,
                    value = position["value"] as? Double
                else { throw APIError.FailedToModel(NSDictionary) }
                payouts.append([
                    "left": String(format: "%dst", rank),
                    "right": Format.currency.stringFromNumber(value)!
                ])
            }
            return Promise(payouts)
        }
    }

}

// MARK: - Errors and Typealiases

enum APIError : ErrorType {
    case Whatever
    case FailedToParse(AnyObject)
    case FailedToModel(AnyClass)
}

