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
    static let baseURL = "http://draftboard-staging.herokuapp.com/"
//    static var token: String?
    static var token: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo1LCJlbWFpbCI6IiIsImV4cCI6MTQ2MjU2MjEwMSwidXNlcm5hbWUiOiJ1c2VyMSIsIm9yaWdfaWF0IjoxNDU5OTcwMTAxfQ.1G9G0EDU5ws-guH_Cf42iRW3uwYyNekVA5c3B5BtBRU"
    
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

private extension Promise where T: AnyObject {
    func asType<U>(type: U.Type) -> Promise<U> {
        return then { json -> U in
            guard let data = json as? U
            else { throw JSONError.UnexpectedRootNode(json) }
            return data
        }
    }
}

// MARK: - Authentication

extension API {
    class func auth(username username: String, password: String) -> Promise<Void> {
        let path = "api-token-auth/"
        let params = ["username": username, "password": password]
        return API.post(path, json: params).asType(NSDictionary).then { data -> Void in
            guard let token = data["token"] as? String
            else { throw APIError.FailedToParse(data) }
            API.token = token
        }
    }
}

// MARK: - General accessors

extension API {
    class func draftGroupUpcoming() -> Promise<[DraftGroup]> {
        let path = "api/draft-group/upcoming/"
        return API.get(path).asType([NSDictionary]).then { data -> [DraftGroup] in
            var draftGroups = [DraftGroup]()
            for dict in data {
                if let draftGroup = DraftGroup(upcomingData: dict) {
                    draftGroups.append(draftGroup)
                } else {
                    throw APIError.FailedToModel(DraftGroup)
                }
            }
            return draftGroups
        }
    }

    class func draftGroup(id id: Int) -> Promise<DraftGroup> {
        let path = "api/draft-group/\(id)/"
        return API.get(path).asType(NSDictionary).then { data -> DraftGroup in
            if let draftGroup = DraftGroup(idData: data) {
                return draftGroup
            } else {
                throw APIError.FailedToModel(DraftGroup)
            }
        }
    }
    
    class func contestLobby() -> Promise<[Contest]> {
        let path = "api/contest/lobby/"
        return API.get(path).asType([NSDictionary]).then { data -> [Contest] in
            var contests = [Contest]()
            for dict in data {
                if let contest = Contest(data: dict) {
                    contests.append(contest)
                } else {
                    throw APIError.FailedToModel(Contest)
                }
            }
            return contests
        }
    }
    
    class func contestEntries() -> Promise<[NSDictionary]> {
        let path = "api/contest/current-entries/"
        return API.get(path).asType([NSDictionary])
    }
    
    class func contestEnter(contest: Contest, lineup: Lineup) -> Promise<NSDictionary> {
        let path = "api/contest/enter-lineup/"
        let params = ["contest": contest.id, "lineup": lineup.id]
        return API.post(path, json: params).asType(NSDictionary)
    }
    
    class func sportsInjuries(sportName: String) -> Promise<[Int: String]> {
        let path = "api/sports/injuries/\(sportName)/"
        return API.get(path).asType([NSDictionary]).then { data -> [Int: String] in
            var injuries = [Int: String]()
            for injuryDict in data {
                guard let playerID = injuryDict["player_id"] as? Int,
                    status = injuryDict["status"] as? String
                else { continue }
                injuries[playerID] = status
            }
            return injuries
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
        return API.get(path).asType([NSDictionary]).then { data -> [Lineup] in
            var lineups = [Lineup]()
            for dict in data {
                if let lineup = Lineup(upcomingData: dict) {
                    lineups.append(lineup)
                } else {
                    throw APIError.FailedToModel(Lineup)
                }
            }
            return lineups
        }
    }
    
    class func prizeStructure(id id: Int) -> Promise<[NSDictionary]> {
        let path = "api/prize/\(id)/"
        return API.get(path).asType(NSDictionary).then { data -> [NSDictionary] in
            guard let ranks = data["ranks"] as? [NSDictionary]
            else { throw APIError.FailedToParse(data) }
            
            var payouts = [NSDictionary]()
            var lastRank: Int = 0
            var lastValue: Double = 0.00
            for position in ranks {
                guard let rank = position["rank"] as? Int,
                    value = position["value"] as? Double
                else { throw APIError.FailedToModel(NSDictionary) }
                
                if value == lastValue { continue }
                
                func ordinalForInt(i: Int) -> String {
                    // Ordinals
                    var suffix = "th"
                    let ones = i % 10
                    let tens = (i / 10) % 10
                    
                    if (tens != 1 && ones == 1) {
                        suffix = "st";
                    } else if (tens != 1 && ones == 2) {
                        suffix = "nd";
                    } else if (tens != 1 && ones == 3) {
                        suffix = "rd";
                    }
                    return String(format: "%d\(suffix)", i)
                }

                let left1 = (rank == lastRank + 1) ? "" : ordinalForInt(lastRank + 1) + "–"
                let left2 = ordinalForInt(rank)
                payouts.append([
                    "left": left1 + left2,
                    "right": Format.currency.stringFromNumber(value)!
                ])
                
                lastRank = rank
                lastValue = value
            }
            return payouts
        }
    }

}

// MARK: - Errors and Typealiases

enum APIError : ErrorType {
    case Whatever
    case FailedToParse(AnyObject)
    case FailedToModel(AnyClass)
}

