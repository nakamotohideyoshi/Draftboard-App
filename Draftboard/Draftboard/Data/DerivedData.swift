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
            (draftGroups, contests) -> [String: [DraftGroupWithContestCount]] in
            
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
            }.groupBy {
                // Organize by sport name
                $0.sportName
            }
            
        }
    }
    class func upcomingSportChoices() -> Promise<[Choice<String>]> {
        return draftGroupsBySportName.get().then {
            $0.map { (sportName, draftGroups) in
                let title = sportName.uppercaseString
                let subtitle = "\(draftGroups.reduce(0) { $0 + $1.contestCount }) Contests"
                return Choice(title: title, subtitle: subtitle, value: sportName)
            }
        }
    }
    class func upcomingDraftGroupChoices(sportName sportName: String) -> Promise<[Choice<DraftGroup>]> {
        let df = NSDateFormatter()
        df.dateFormat = "eeee, MMM d - h:mm a"
        return draftGroupsBySportName.get().then {
            $0[sportName]!.map {
                let title = df.stringFromDate($0.start)
                let subtitle = "\($0.contestCount) Contests, \($0.numGames) Games"
                return Choice(title: title, subtitle: subtitle, value: $0)
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
    class func upcomingLineupsWithStarts() -> Promise<[LineupWithStart]> {
        return when(Data.draftGroups.get(), Data.upcomingLineups.get()).then { (draftGroups, lineups) -> [LineupWithStart] in
            let draftGroupsByID = draftGroups.keyBy { $0.id }
            return lineups.map { $0.withStart(draftGroupsByID[$0.draftGroupID]!.start) }
        }
    }
}

extension Lineup {
    
    func getGames() -> Promise<[Game]> {
        return DerivedData.games(sportName: sportName, draftGroupID: draftGroupID)
    }
    
    func getPlayersWithGames() -> Promise<[PlayerWithGame]?> {
        return getGames().then { games -> [PlayerWithGame]? in
            guard let players = self.players else { return nil }
            if let players = players as? [PlayerWithGame] { return players }
            
            let gamesByTeam = games.transform([String: Game]()) {
                $0[$1.home.alias] = $1
                $0[$1.away.alias] = $1
                return $0
            }
            
            return players.map { $0.withGame(gamesByTeam[$0.teamAlias]!) }
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