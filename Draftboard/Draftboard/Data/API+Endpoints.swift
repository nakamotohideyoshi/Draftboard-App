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

    class func sportsTeams(sportName sportName: String) -> Promise<[Team]> {
        let path = "api/sports/teams/\(sportName)/"
        return API.get(path).then { (json: [NSDictionary]) -> [Team] in
            try json.map { try Team(json: $0) }
        }
    }
    
    class func draftGroupBoxscores(draftGroupID draftGroupID: Int) -> Promise<[Boxscore]> {
        let path = "api/draft-group/boxscores/\(draftGroupID)/"
        return API.get(path).then { (json: [String: NSDictionary]) -> [Boxscore] in
            try json.values.map { try Boxscore(json: $0) }
        }
    }

//    class func sportsTeams() -> Promise<[Team]> {
//        let paths = [
//            "api/sports/teams/nba/",
//            "api/sports/teams/nhl/",
//            "api/sports/teams/mlb/"
//        ]
//        let getAll: [Promise<[NSDictionary]>] = paths.map { API.get($0) }
//        return when(getAll).then {
//            try $0.flatten().map { try Team(JSON: $0) }
//        }
//    }
    
    
    class func draftGroupFantasyPoints(id id: Int) -> Promise<[Int: Double]> {
        let path = "api/draft-group/fantasy-points/\(id)/"
        return API.get(path).then { (json: NSDictionary) -> [Int: Double] in
            let players: [String: NSDictionary] = try json.get("players")
            return Array(players.values).transform([Int: Double]()) { result, value in
//                let id: Int = (try? value.get("id")) ?? -1
//                let fp: Double = (try? value.get("fp")) ?? -100
                result[try! value.get("id")] = try! value.get("fp")
                return result
            }
        }
    }
    
    class func sportsScoreboardGames(sportName sportName: String) -> Promise<[String: Double]> {
        let path = "api/sports/scoreboard-games/\(sportName)/"
        return API.get(path).then { (json: [String: NSDictionary]) -> [String: Double] in
            var timeRemaining = [String: Double]()
            for (srid, game) in json {
                if let boxscoreDict: NSDictionary = try? game.get("boxscore") {
                    if let _: Int = try? boxscoreDict.get("quarter") {
                        let boxscore = try RealtimeGameBoxscore(JSON: boxscoreDict, sportName: sportName)
                        timeRemaining[boxscore.game] = boxscore.timeRemaining
                    } else {
                        timeRemaining[srid] = 0
                    }
                    
                } else {
                    timeRemaining[srid] = Sport.gameDuration[sportName]!
                }
            }
            return timeRemaining
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
            return try json.map {
                try Contest(json: $0)
            }.sort {
                if $0.start != $1.start { return $0.start < $1.start }
                if $0.buyin != $1.buyin { return $0.buyin > $1.buyin }
                return $0.name < $1.name
            }
        }
    }
    
    class func contestStatus(id id: Int) -> Promise<String> {
        let path = "api/contest/info/\(id)/"
        return API.get(path).then { (JSON: NSDictionary) -> String in
            let status: String = try JSON.get("status")
            return status
        }
    }
    
    class func contestInfo(id id: Int) -> Promise<Contest> {
        let path = "api/contest/info/contest_pool/\(id)/"
        return API.get(path).then { try Contest(json: $0) }
    }
    
    class func contestEntries() -> Promise<[NSDictionary]> {
        let path = "api/contest/current-entries/"
        return API.get(path)
    }
    
    class func contestEnter(contest: Contest, lineup: Lineup) -> Promise<NSDictionary> {
        let path = "api/contest/enter-lineup/"
        let params = ["contest_pool": contest.id, "lineup": lineup.id]
        return API.post(path, JSON: params)
    }
    
    class func contestAllLineups(id id: Int) -> Promise<String> {
        let path = "api/contest/all-lineups/\(id)/"
        return API.get(path)
    }
    
    class func contestRegisteredUsers(id id: Int) -> Promise<[NSDictionary]> {
        let path = "api/contest/registered-users/\(id)/"
        return API.get(path)
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
        var lineupName = lineup.name
        if lineupName == "New Lineup" {
            lineupName = ""
        }
        let params = [
            "name": lineupName,
            "players": lineup.players!.map { $0.id },
            "draft_group": lineup.draftGroupID
        ]
        return API.post(path, JSON: params)
    }
    
    class func lineupEdit(lineup: Lineup) -> Promise<AnyObject> {
        let path = "api/lineup/edit/"
        let params = [
            "name": lineup.name,
            "players": lineup.players!.map { $0.id },
            "lineup": lineup.id
        ]
        return API.post(path, JSON: params)
    }

    
    class func lineupUpcoming() -> Promise<[Lineup]> {
        let path = "api/lineup/upcoming/"
        return API.get(path).then { (json: [NSDictionary]) -> [Lineup] in
            return try json.map { try Lineup(JSON: $0) }
        }
    }
    
    class func lineupLive() -> Promise<[Lineup]> {
        let path = "api/lineup/live/"
        return API.get(path).then { (json: [NSDictionary]) -> [Lineup] in
            return try json.map { try Lineup(JSON: $0) }
        }
    }
    
    class func lineupCurrent() -> Promise<[NSDictionary]> {
        let path = "api/lineup/current/"
        return API.get(path)
    }
    
    class func playHistory(date: String) -> Promise<NSDictionary> {
        let path = "api/contest/play-history/\(date)/"
        return API.get(path)
    }
    
    class func contestPoolEntries() -> Promise<[ContestPoolEntry]> {
        let path = "api/contest/contest-pools/entries/"
        return API.get(path).then { (json: [NSDictionary]) -> [ContestPoolEntry] in
            return try json.map { try ContestPoolEntry(JSON: $0) }.sortBy{ $0.id }
        }
    }
    
    class func contestUnregisterEntry(entry: LineupEntry) -> Promise<AnyObject> {
        let path = "api/contest/unregister-entry/\(entry.id)/"
        let params = [:]
        return API.post(path, JSON: params)
    }
    
    class func contestUnregisterEntry(entry: ContestPoolEntry) -> Promise<AnyObject> {
        let path = "api/contest/unregister-entry/\(entry.id)/"
        let params = [:]
        return API.post(path, JSON: params)
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
    
    class func getPlayerReports(srid srid: String) -> Promise<[Report]> {
        let path = "api/sports/updates/player/\(srid)/"
        return API.get(path).then { (json: [NSDictionary]) -> [Report] in
            let news: [NSDictionary] = json.filter { $0["category"] as! String == "news" }
            return try news.map { try Report.init(json: $0) }
        }
    }
    
    class func getMLBPlayerGameLogs(playerID playerID: Int) -> Promise<[NSDictionary]> {
        let path = "api/sports/player/history/mlb/20/\(playerID)/"
        return API.get(path).then { (json: [NSDictionary]) -> [NSDictionary] in
            return json
        }
    }
    
    class func getNBAPlayerGameLogs(playerID playerID: Int) -> Promise<[NSDictionary]> {
        let path = "api/sports/player/history/nba/20/\(playerID)/"
        return API.get(path).then { (json: [NSDictionary]) -> [NSDictionary] in
            return json
        }
    }
    
    class func getNFLPlayerGameLogs(playerID playerID: Int) -> Promise<[NSDictionary]> {
        let path = "api/sports/player/history/nfl/20/\(playerID)/"
        return API.get(path).then { (json: [NSDictionary]) -> [NSDictionary] in
            return json
        }
    }
    
    class func getPlayerStatuses(sportName sportName: String) -> Promise<[NSDictionary]> {
        let path = "api/sports/player-status/\(sportName)/"
        return API.get(path).then { (json: NSDictionary) -> [NSDictionary] in
            let playerUpdates: [NSDictionary] = try json.get("player_updates")
            return playerUpdates
        }
    }
}
