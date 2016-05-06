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
    
    class func draftGroupUpcoming() -> Promise<[DraftGroup]> {
        let path = "api/draft-group/upcoming/"
        return API.get(path).then { (data: [NSDictionary]) -> [DraftGroup] in
            return try data.map { try DraftGroup(throwableData: $0) }
        }
    }
    
    class func draftGroup(id id: Int) -> Promise<DraftGroup> {
        let path = "api/draft-group/\(id)/"
        return API.get(path).then { (data: NSDictionary) -> DraftGroup in
            return try DraftGroup(throwableData: data)
        }
    }
    
    class func contestLobby() -> Promise<[Contest]> {
        let path = "api/contest/lobby/"
        return API.get(path).then { (data: [NSDictionary]) -> [Contest] in
            return try data.map { try Contest(throwableData: $0) }
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
    
    class func lineupCreate(lineup: Lineup) -> Void {
        let path = "api/lineup/create/"
        let params = [
            "name": lineup.name,
            "players": lineup.players.map {$0?.id ?? 0},
            "draft_group": lineup.draftGroup.id
        ]
        let doNothing: (AnyObject) -> Void = {_ in}
        API.post(path, JSON: params).then(doNothing)
    }
    
    class func lineupUpcoming() -> Promise<[Lineup]> {
        let path = "api/lineup/upcoming/"
        return API.get(path).then { (data: [NSDictionary]) -> [Lineup] in
            return try data.map { try Lineup(throwableData: $0) }
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
