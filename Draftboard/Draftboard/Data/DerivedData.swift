//
//  DerivedData.swift
//  Draftboard
//
//  Created by Anson Schall on 5/26/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class DerivedData {
    private static var draftGroupsBySportName = Cache(defaultMaxCacheAge: .OneMinute, defaultMinCacheAge: .OneMinute) {
        return when(Data.draftGroups.get(), Data.contests.get()).then {
            (draftGroups, contests) -> [DraftGroupWithContestCount] in
            
            var contestCounts = contests.countBy { $0.draftGroupID }
            return draftGroups.map {
                // Add contest counts to draftgroups
                $0.withContestCount(contestCounts[$0.id]!)
            }.filter {
                // Filter by contest existence
                $0.contestCount > 0
            }.sortBy {
                // Order by start date
                $0.start
            }
            
        }
    }
//    class func upcomingSportChoices() -> Promise<[Choice<String>]> {
//        return draftGroupsBySportName.get().then {
//            $0.map { (sportName, draftGroups) in
//                let title = sportName.uppercaseString
//                let subtitle = "\(draftGroups.reduce(0) { $0 + $1.contestCount }) Contests"
//                return Choice(title: title, subtitle: subtitle, value: sportName)
//            }
//        }
//    }
    class func upcomingDraftGroupChoices(lineups: [LineupWithStart] = []) -> Promise<[Choice<DraftGroup>]> {
        let df = NSDateFormatter()
        
        return draftGroupsBySportName.get().then {
            $0.map {
                let calendar = NSCalendar.currentCalendar()
                let date1 = calendar.startOfDayForDate(NSDate.init())
                let date2 = calendar.startOfDayForDate($0.start)
                let components = calendar.components(NSCalendarUnit.Day, fromDate: date1, toDate: date2, options: [])
                var title = ""
                if (components.day == 0) {
                    df.dateFormat = "h:mm a"
                    title = "\($0.sportName.uppercaseString) - Today @ \(df.stringFromDate($0.start))"
                } else if (components.day == 1) {
                    df.dateFormat = "h:mm a"
                    title = "\($0.sportName.uppercaseString) - Tomorrow @ \(df.stringFromDate($0.start))"
                } else {
                    df.dateFormat = "eeee @ h:mm a"
                    title = "\($0.sportName.uppercaseString) - \(df.stringFromDate($0.start))"
                }
                
                let currentSportName = $0.sportName
                let alreadyExists = lineups.filter { $0.sportName == currentSportName && $0.isLive == false }.count
                var subtitle = "\($0.numGames) Games"
                if (alreadyExists > 0) {
                    subtitle = "\($0.sportName) lineup already created".uppercaseString
                }
                
                return Choice(title: title, subtitle: subtitle, value: $0, editing: alreadyExists > 0)
            }
        }
    }
}

extension DerivedData {
    class func games(sportName sportName: String, draftGroupID: Int) -> Promise<[Game]> {
        return when(Data.sportsTeams[sportName].get(), Data.boxscores[draftGroupID].get()).then { (teams, boxscores) -> [Game] in
            let teamsBySRID = teams.keyBy { $0.srid }
            return boxscores.flatMap {
                guard let home = teamsBySRID[$0.sridHome], away = teamsBySRID[$0.sridAway] else { return nil }
                return Game(srid: $0.srid, home: home, away: away, start: $0.start)
            }
        }
    }
}

extension DerivedData {
    class func allLineupsWithStarts() -> Promise<[LineupWithStart]> {
        var lineups = [Lineup]()
        return when(Data.upcomingLineups.get(), Data.liveLineups.get()).then { upcoming, live -> Promise<[DraftGroupWithPlayers]> in
            lineups = live + upcoming
            return when(lineups.map { Data.draftGroup[$0.draftGroupID].get() })
        }.then { draftGroups -> [LineupWithStart] in
            let draftGroupsByID = draftGroups.keyBy { $0.id }
            return lineups.map { $0.withStart(draftGroupsByID[$0.draftGroupID]!.start) }
        }
    }
    
    class func contestsWithEntries() -> Promise<[ContestWithEntries]> {
        return when(Data.contests.fresh(), Data.contestPoolEntries.fresh()).then { contests, entries -> [ContestWithEntries] in
            let contestEntries = entries.groupBy { $0.contestPoolID }
            return contests.map { $0.withEntries(contestEntries[$0.id] ?? []) }
        }
    }
    
    class func getLineupStatus(contests: [Int]) -> Promise<[String]> {
        return when(contests.map { Data.contestGroup[$0].get() }).then { status -> [String] in
            return status
        }
    }
}

extension Lineup {
    
    func getDraftGroup() -> Promise<DraftGroupWithPlayers> {
        return Data.draftGroup[draftGroupID].get()
    }
    
    func getGames() -> Promise<[Game]> {
        return DerivedData.games(sportName: sportName, draftGroupID: draftGroupID)
    }
    
    // Games keyed by both home and away alias
    func getGamesByTeam() -> Promise<[String: Game]> {
        return getGames().then { games -> [String: Game] in
            return games.transform([String: Game]()) {
                $0[$1.home.srid] = $1
                $0[$1.away.srid] = $1
                return $0
            }
        }
    }
    
    // Used by LineupDetailViewController
    func getPlayersWithGames() -> Promise<[PlayerWithPositionAndGame]?> {
        return when(getDraftGroup(), getGamesByTeam()).then { draftGroup, gamesByTeam -> [PlayerWithPositionAndGame]? in
            guard let players = self.players else { return nil }
            let playersWithGamesBySRID = draftGroup.players.transform([String: PlayerWithPositionAndGame]()) { result, player in
                result[player.srid] = player.withGame(gamesByTeam[player.teamSRID]!)
                return result
            }
            let playerWithGames = players.map { playersWithGamesBySRID[$0.srid]! }
            var results: [PlayerWithPositionAndGame] = []
            var index = 0
            for p in playerWithGames {
                let newPlayer: PlayerWithPositionAndGame = p
                newPlayer.stat = players[index].stat
                results.append(newPlayer)
                index += 1
            }
            return results
        }
    }
    
    // Used by LineupDraftViewController
    func getDraftGroupWithPlayersWithGames() -> Promise<DraftGroupWithPlayers> {
        return when(getDraftGroup(), getGamesByTeam()).then { draftGroup, gamesByTeam -> DraftGroupWithPlayers in
            let players = draftGroup.players.map { player -> PlayerWithPositionAndGame in
                player.withGame(gamesByTeam[player.teamSRID]!)
            }.sort { p1, p2 in
                if p1.salary != p2.salary { return p1.salary > p2.salary }
                if p1.fppg != p2.fppg { return p1.fppg > p2.fppg }
                return p1.lastName < p2.lastName
            }

            return draftGroup.withPlayersWithGames(players)
        }
    }

    func getEntries() -> Promise<[LineupEntry]> {
        return DerivedData.entriesByLineup().then {
            return $0[self.id] ?? []
        }
    }
    
    func isFinished() -> Promise<Bool> {
        return DerivedData.getLineupStatus(contests).then { statuses -> Bool in
            if statuses.count > 0 {
                var count = 0
                for status in statuses {
                    if status == "completed" || status == "closed" || status == "cancelled" {
                        count += 1
                    }
                }
                if count == statuses.count {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        }
    }
    
    func getEntriesForFinished() -> Promise<[LineupFinishedEntry]> {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
        
        return Promise<[LineupFinishedEntry]> { fulfill, reject in
            API.playHistory(dateFormatter.stringFromDate((self as! LineupWithStart).start)).then { history -> Void in
                if let lineups: [NSDictionary] = try? history.get("lineups") {
                    for l in lineups {
                        let id: Int = try! l.get("id")
                        if (id == self.id) {
                            let entriesJSON: [NSDictionary] = try! l.get("entries")
                            print(entriesJSON)
                            let entries: [LineupFinishedEntry] = try entriesJSON.map{ try LineupFinishedEntry.init(JSON: $0) }
                            var results: [LineupFinishedEntry] = []
                            var count = 0
                            for entry in entries {
                                Data.getContestResult[entry.contestID].get().then { json -> Void in
                                    let ranked_entries: [NSDictionary] = try! json.get("ranked_entries")
                                    let newEntry = entry
                                    let rankedEntries: [FinishedRankedEntry] = try! ranked_entries.map { try FinishedRankedEntry.init(JSON: $0) }
                                    newEntry.entries = rankedEntries
                                    results.append(newEntry)
                                    count += 1
                                    if (count == entries.count) {
                                        fulfill(results)
                                    }
                                }
                            }
                            fulfill(entries)
                        }
                    }
                }
                fulfill([])
            }
        }
    }
}

extension Player {
    func getPlayerStatus(sportName sportName: String) -> Promise<String> {
        let path = "api/sports/player-status/\(sportName)/"
        return API.get(path).then { (json: NSDictionary) -> String in
            let playerUpdates: [NSDictionary] = try json.get("player_updates")
            
            let playerStatuses: [NSDictionary] = try playerUpdates.filter {
                try $0.get("player_srid") == self.srid
            }
            if playerStatuses.count == 0 {
                return ""
            } else {
                let playerStatus: NSDictionary = playerStatuses.first!
                let status:String = try playerStatus.get("status")
                if status == "Questionable".uppercaseString {
                    return status
                } else if status == "Doubtful".uppercaseString {
                    return status
                } else if status == "OUT" || status == "IR" || status == "IR-R" || status == "NFI" || status == "PUP-R" || status == "PUP-P" || status == "INACTIVE" {
                    return "OUT"
                } else {
                    return ""
                }
            }
        }
    }
    
    func getPlayerReports() -> Promise<[Report]> {
        return Data.playerReports[srid].get().then { reports in
            return reports
        }
    }
    
    func getPlayerGameLog(sportName sportName: String) -> Promise<NSArray> {
        let team = (self as? PlayerWithPositionAndGame)?.team
        let position = (self as? PlayerWithPositionAndGame)?.position
        
        if sportName == "mlb" {
            return when(Data.mlbPlayerGameLogs[id].get(), Data.sportsTeams[sportName].get()).then { (result, teams) -> NSArray in
                if result.count == 0 {
                    return []
                } else {
                    let gameLogs = result[0]
                    let teamsBySRID = teams.keyBy { $0.srid }
                    
                    if position == "SP" {
                        let startArr: [String] = try! gameLogs.get("start")
                        let homeTeams: [String] = try! gameLogs.get("srid_home")
                        let awayTeams: [String] = try! gameLogs.get("srid_away")
                        let ipValues: [Int] = try! gameLogs.get("ip_1")
                        let hValues: [Int] = try! gameLogs.get("h")
                        let erValues: [Int] = try! gameLogs.get("er")
                        let bbValues: [Int] = try! gameLogs.get("bb")
                        let soValues: [Int] = try! gameLogs.get("ktotal")
                        let fpValues: [Double] = try! gameLogs.get("fp")
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MMM dd"
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
                        
                        var gameStats = [MLBPitcherGameLog] ()
                        
                        for (i, value) in startArr.enumerate() {
                            let startDate:NSDate = try API.dateFromString(value)
                            let start:String = dateFormatter.stringFromDate(startDate)
                            let homeTeam: String = homeTeams[i]
                            let awayTeam: String = awayTeams[i]
                            var opp = ""
                            if homeTeam == team?.srid {
                                opp = (teamsBySRID[awayTeam]?.alias)!
                            }
                            if awayTeam == team?.srid {
                                opp = "@" + (teamsBySRID[homeTeam]?.alias)!
                            }
                            let gameStat: MLBPitcherGameLog = MLBPitcherGameLog.init(date: start, opp: opp, result: "", ip: ipValues[i], h: hValues[i], er: erValues[i], bb: bbValues[i], so: soValues[i], fp: fpValues[i])
                            gameStats.append(gameStat)
                        }
                        return gameStats
                    } else {
                        let startArr: [String] = try! gameLogs.get("start")
                        let homeTeams: [String] = try! gameLogs.get("srid_home")
                        let awayTeams: [String] = try! gameLogs.get("srid_away")
                        let rValues: [Int] = try! gameLogs.get("r")
                        let hValues: [Int] = try! gameLogs.get("h")
                        let doubleValues: [Int] = try! gameLogs.get("d")
                        let tripleValues: [Int] = try! gameLogs.get("t")
                        let hrValues: [Int] = try! gameLogs.get("hr")
                        let rbiValues: [Int] = try! gameLogs.get("rbi")
                        let bbValues: [Int] = try! gameLogs.get("bb")
                        let hbpValues: [Int] = try! gameLogs.get("hbp")
                        let sbValues: [Int] = try! gameLogs.get("sb")
                        let fpValues: [Double] = try! gameLogs.get("fp")
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MMM dd"
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
                        
                        var gameStats = [MLBHitterGameLog] ()
                        
                        for (i, value) in startArr.enumerate() {
                            let startDate:NSDate = try API.dateFromString(value)
                            let start:String = dateFormatter.stringFromDate(startDate)
                            let homeTeam: String = homeTeams[i]
                            let awayTeam: String = awayTeams[i]
                            var opp = ""
                            if homeTeam == team?.srid {
                                opp = (teamsBySRID[awayTeam]?.alias)!
                            }
                            if awayTeam == team?.srid {
                                opp = "@" + (teamsBySRID[homeTeam]?.alias)!
                            }
                            let gameStat: MLBHitterGameLog = MLBHitterGameLog.init(date: start, opp: opp, ab: 0, r: rValues[i], h: hValues[i], doubles: doubleValues[i], triples: tripleValues[i], hr: hrValues[i], rbi: rbiValues[i], bb: bbValues[i] + hbpValues[i], sb: sbValues[i], fp: fpValues[i])
                            gameStats.append(gameStat)
                        }
                        return gameStats
                    }
                }
            }
        } else if sportName == "nfl" {
            return when(Data.nflPlayerGameLogs[id].get(), Data.sportsTeams[sportName].get()).then { (result, teams) -> NSArray in
                if result.count == 0 {
                    return []
                } else {
                    let gameLogs = result[0]
                    let teamsBySRID = teams.keyBy { $0.srid }
                    
                    if position == "QB" {
                        let startArr: [String] = try! gameLogs.get("start")
                        let homeTeams: [String] = try! gameLogs.get("srid_home")
                        let awayTeams: [String] = try! gameLogs.get("srid_away")
                        let passYdsValues: [Int] = try! gameLogs.get("pass_yds")
                        let passTdValues: [Int] = try! gameLogs.get("pass_td")
                        let passIntValues: [Int] = try! gameLogs.get("pass_int")
                        let rushYdsValues: [Int] = try! gameLogs.get("rush_yds")
                        let rushTdValues: [Int] = try! gameLogs.get("rush_td")
                        let fpValues: [Double] = try! gameLogs.get("fp")
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MMM dd"
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
                        
                        var gameStats = [NFLQBGameLog] ()
                        
                        for (i, value) in startArr.enumerate() {
                            let startDate:NSDate = try API.dateFromString(value)
                            let start:String = dateFormatter.stringFromDate(startDate)
                            let homeTeam: String = homeTeams[i]
                            let awayTeam: String = awayTeams[i]
                            var opp = ""
                            if homeTeam == team?.srid {
                                opp = (teamsBySRID[awayTeam]?.alias)!
                            }
                            if awayTeam == team?.srid {
                                opp = "@" + (teamsBySRID[homeTeam]?.alias)!
                            }
                            let gameStat: NFLQBGameLog = NFLQBGameLog.init(date: start, opp: opp, pass_yds: passYdsValues[i], pass_td: passTdValues[i], pass_int: passIntValues[i], rush_yds: rushYdsValues[i], rush_td: rushTdValues[i], fp: fpValues[i])
                            gameStats.append(gameStat)
                        }
                        return gameStats
                    } else if position == "RB" {
                        let startArr: [String] = try! gameLogs.get("start")
                        let homeTeams: [String] = try! gameLogs.get("srid_home")
                        let awayTeams: [String] = try! gameLogs.get("srid_away")
                        let rushYdsValues: [Int] = try! gameLogs.get("rush_yds")
                        let rushTdValues: [Int] = try! gameLogs.get("rush_td")
                        let recRecValues: [Int] = try! gameLogs.get("rec_rec")
                        let recYdsValues: [Int] = try! gameLogs.get("rec_yds")
                        let recTdValues: [Int] = try! gameLogs.get("rec_td")
                        let fpValues: [Double] = try! gameLogs.get("fp")
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MMM dd"
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
                        
                        var gameStats = [NFLRBGameLog] ()
                        
                        for (i, value) in startArr.enumerate() {
                            let startDate:NSDate = try API.dateFromString(value)
                            let start:String = dateFormatter.stringFromDate(startDate)
                            let homeTeam: String = homeTeams[i]
                            let awayTeam: String = awayTeams[i]
                            var opp = ""
                            if homeTeam == team?.srid {
                                opp = (teamsBySRID[awayTeam]?.alias)!
                            }
                            if awayTeam == team?.srid {
                                opp = "@" + (teamsBySRID[homeTeam]?.alias)!
                            }
                            let gameStat: NFLRBGameLog = NFLRBGameLog.init(date: start, opp: opp, rush_yds: rushYdsValues[i], rush_td: rushTdValues[i], rec_rec: recRecValues[i], rec_yds: recYdsValues[i], rec_td: recTdValues[i], fp: fpValues[i])
                            gameStats.append(gameStat)
                        }
                        return gameStats
                    } else {
                        let startArr: [String] = try! gameLogs.get("start")
                        let homeTeams: [String] = try! gameLogs.get("srid_home")
                        let awayTeams: [String] = try! gameLogs.get("srid_away")
                        let recRecValues: [Int] = try! gameLogs.get("rec_rec")
                        let recYdsValues: [Int] = try! gameLogs.get("rec_yds")
                        let recTdValues: [Int] = try! gameLogs.get("rec_td")
                        let fpValues: [Double] = try! gameLogs.get("fp")
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MMM dd"
                        dateFormatter.timeZone = NSTimeZone(abbreviation: "EST")
                        
                        var gameStats = [NFLGameLog] ()
                        
                        for (i, value) in startArr.enumerate() {
                            let startDate:NSDate = try API.dateFromString(value)
                            let start:String = dateFormatter.stringFromDate(startDate)
                            let homeTeam: String = homeTeams[i]
                            let awayTeam: String = awayTeams[i]
                            var opp = ""
                            if homeTeam == team?.srid {
                                opp = (teamsBySRID[awayTeam]?.alias)!
                            }
                            if awayTeam == team?.srid {
                                opp = "@" + (teamsBySRID[homeTeam]?.alias)!
                            }
                            let gameStat: NFLGameLog = NFLGameLog.init(date: start, opp: opp, rec_rec: recRecValues[i], rec_yds: recYdsValues[i], rec_td: recTdValues[i], fp: fpValues[i])
                            gameStats.append(gameStat)
                        }
                        return gameStats
                    }
                }
            }
        } else {
            return Data.nbaPlayerGameLogs[id].get().then { gameLogs in
                return []
            }
        }
    }
}
extension DerivedData {
    class func entriesByLineup() -> Promise<[Int: [LineupEntry]]> {
        return when(Data.contestPoolEntries.get(), Data.contests.get()).then { entries, contests -> [Int: [LineupEntry]] in
            let contestsByID = contests.keyBy { $0.id }
            return entries.transform([Int: [LineupEntry]]()) {
                $0[$1.lineupID] = $0[$1.lineupID] ?? []
                $0[$1.lineupID]!.append(LineupEntry(id: $1.id, contest: contestsByID[$1.contestPoolID]!))
                return $0
            }
        }
    }
}


private extension Dictionary {
    // See: https://gist.github.com/jverkoey/0b993932ddc9bd69120d
    subscript(key: Key, @autoclosure withDefault value: Void -> Value) -> Value {
        mutating get {
            if self[key] == nil {
                self[key] = value()
            }
            return self[key]!
        }
        set {
            self[key] = newValue
        }
    }
}
