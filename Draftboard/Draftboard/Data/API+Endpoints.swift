//
//  API+Endpoints.swift
//  Draftboard
//
//  Created by Anson Schall on 5/3/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation
import PromiseKit

private typealias API_Endpoints = API
extension API_Endpoints {

    class func sportsTeams() -> Promise<[Team]> {
        let paths = [
            "api/sports/teams/nba/",
            "api/sports/teams/nhl/",
            "api/sports/teams/mlb/"
        ]
        let getAll: [Promise<[NSDictionary]>] = paths.map { API.get($0) }
        return when(getAll).then {
            try $0.flatten().map { try Team(JSON: $0) }
        }
    }
    
    class func draftGroupUpcoming() -> Promise<[DraftGroup]> {
        let path = "api/draft-group/upcoming/"
        return API.get(path).then { (json: [NSDictionary]) -> [DraftGroup] in
            return try json.map { try DraftGroup(JSON: $0) }
        }
    }
    
    class func draftGroup(id id: Int) -> Promise<DraftGroupWithPlayers> {
        let path = "api/draft-group/\(id)/"
        return API.get(path).then { (json: NSDictionary) -> DraftGroupWithPlayers in
            return try DraftGroupWithPlayers(JSON: json)
        }
    }
    
    class func contestLobby() -> Promise<[Contest]> {
        let path = "api/contest/lobby/"
        return API.get(path).then { (json: [NSDictionary]) -> [Contest] in
            return try json.map { try Contest(json: $0) }
        }
    }
    
    class func contestEntries() -> Promise<[NSDictionary]> {
        let path = "api/contest/current-entries/"
        return API.get(path)
    }
    
    class func contestEnter(contest: Contest, lineup: Lineup) -> Promise<NSDictionary> {
        let path = "api/contest/enter-lineup/"
        let params = ["contest": contest.id, "lineup": lineup.id]
        return API.post(path, JSON: params)
    }
    
    class func sportsInjuries(sportName: String) -> Promise<[Int: String]> {
        let path = "api/sports/injuries/\(sportName)/"
        return API.get(path).then { (data: [NSDictionary]) -> [Int: String] in
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
    
    class func lineupCreate(lineup: Lineup) -> Promise<AnyObject> {
        let path = "api/lineup/create/"
        let params = [
            "name": lineup.name,
//            "players": lineup.playerIDs,
            "draft_group": lineup.draftGroupID
        ]
        return API.post(path, JSON: params)
    }
    
    
    class func lineupUpcoming() -> Promise<[Lineup]> {
        let path = "api/lineup/upcoming/"
        return API.get(path).then { (json: [NSDictionary]) -> [Lineup] in
            return try json.map { try Lineup(JSON: $0) }
        }
    }
    
    class func prizeStructure(id id: Int) -> Promise<[NSDictionary]> {
        let path = "api/prize/\(id)/"
        return API.get(path).then { (data: NSDictionary) -> [NSDictionary] in
            let ranks: [NSDictionary] = try data.get("ranks")
            return ranks
            /*
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
            */
        }
    }
    
}
