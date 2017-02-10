//
//  Data.swift
//  Draftboard
//
//  Created by Anson Schall on 11/19/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class Data {
    static let sportsTeams = MultiCache(defaultMaxCacheAge: .OneDay, defaultMinCacheAge: .OneDay) {
        sportName in API.sportsTeams(sportName: sportName)
    }
    static let boxscores = MultiCache { draftGroupID in API.draftGroupBoxscores(draftGroupID: draftGroupID) }
    static let upcomingLineups = Cache { API.lineupUpcoming() }
    static let liveLineups = Cache { API.lineupLive() }
    static let draftGroups = Cache { API.draftGroupUpcoming() }
    static let draftGroup = MultiCache { id in API.draftGroup(id: id) }
    static let contests = Cache { API.contestLobby() }
    static let contestPoolEntries = Cache(defaultMaxCacheAge: 10, defaultMinCacheAge: 10) { API.contestPoolEntries() }
    static let contestGroup = MultiCache { id in API.contestStatus(id: id) }
}

//enum SortByOther: ErrorType {
//    case UnequalLength
//}
//extension Array {
//    func sortByOther<U>(other: Array<U>, isOrderedBefore: (U, U) -> Bool) -> [Element] {
////        if self.count != other.count { throw SortByOther.UnequalLength }
//        return self.enumerate().sort { (a, b) in
//            return isOrderedBefore(other[a.index], other[b.index])
//        }.map { (i, element) in element }
//    }
//}
//
//extension Array where Element: Lineup {
//    func sortedByDate() -> Promise<[Element]> {
//        return when(map { $0.getDraftGroup() }).then { draftGroups -> [Element] in
//            return self.sortByOther(draftGroups) { (a, b) in
//                a.start.earlierDate(b.start) == a.start
//            }
//        }
//    }
//}

extension Contest {
    func enter(with lineup: Lineup) -> Promise<[ContestWithEntries]> {
        return API.contestEnter(self, lineup: lineup).then { _ in
            DerivedData.contestsWithEntries()
        }
    }
}


extension LineupEntry {
    func unregister() -> Promise<AnyObject> {
        Data.contestPoolEntries.clearCache()
        return API.contestUnregisterEntry(self)
    }
}

extension Lineup {
    func save() -> Promise<AnyObject> {
        Data.upcomingLineups.clearCache()
        if id < 0 {
            return API.lineupCreate(self)
        }
        return API.lineupEdit(self)
    }
    /*
    func getDraftGroup() -> Promise<DraftGroupWithPlayers> {
        return Data.draftGroup[draftGroupID].get()
    }
    func getSportName() -> Promise<String> {
        return getDraftGroup().then { $0.sportName }
    }
    func getPlayers() -> Promise<[Player]> {
        return getDraftGroup().then { $0.players }
    }
    func getPlayer(id id: Int) -> Promise<Player?> {
        return getPlayers().then { $0.filter { $0.id == id }.first }
    }
 */
//    func getPlayer(idx idx: Int) -> Promise<Player?> {
//        return getPlayers().then { $0.filter { $0.id == id }.first }
//    }
    /*
    func getSport() -> Promise<Sport> {
        return getDraftGroup().then { draftGroup in
            return draftGroup.getSport()
        }
    }*/
}
/*
extension Player {
    func getTeam() -> Promise<Team> {
        return Data.teams.get().then { teams in
            teams.filter { $0.srid == self.teamSRID }[0]
        }
    }
}
 */

extension Data {
//    class func liveContestLineups(id id: Int) -> Promise<LiveContest> { }

    class func liveDraftGroup(id id: Int, sportName: String) -> Promise<LiveDraftGroup> {
        return when(API.draftGroupFantasyPoints(id: id), API.sportsScoreboardGames(sportName: sportName)).then { points, timeRemaining -> LiveDraftGroup in
            let draftGroup = LiveDraftGroup()
            draftGroup.id = id
            draftGroup.sportName = sportName
            draftGroup.points = points
            draftGroup.timeRemaining = timeRemaining
            return draftGroup
        }
    }
    
    class func liveContests() -> Promise<[Int: [LiveContest]]> {
        // Get contests (not pools)
        return API.lineupCurrent().then { lineups -> [Int: [LiveContest]] in
            var lineupContests = [Int: [LiveContest]]()
            for lineup in lineups {
                let id: Int = try! lineup.get("id")
                let sport: String = try! lineup.get("sport")
                let draftGroup: Int = try! lineup.get("draft_group")
                let contestsByPool: [String: [Int]] = try! lineup.get("contests_by_pool")
                lineupContests[id] = []
                for (pool, contests) in contestsByPool {
                    for contest in contests {
                        let liveContest = LiveContest()
                        liveContest.id = contest
                        liveContest.sportName = sport
                        liveContest.poolID = Int(pool)!
                        liveContest.draftGroupID = draftGroup
                        API.contestAllLineups(id: contest).then { hexString -> Void in
                            liveContest.setLineups(hexString: hexString, sportName: sport)
                            for l in liveContest.lineups {
                                print(l.players)
                            }
                        }
                        API.contestInfo(id: Int(pool)!).then { contest -> Void in
                            liveContest.contestName = contest.name
                            liveContest.prizes = contest.payoutSpots.sortBy { $0.rank }.map { $0.value }
                        }
                        lineupContests[id]?.append(liveContest)
                    }
                }
            }
            return lineupContests
        }
    }

    class func liveContests(for lineup: Lineup) -> Promise<(LiveDraftGroup, [LiveContest])> {
        return when(liveContests(), liveDraftGroup(id: lineup.draftGroupID, sportName: lineup.sportName)).then { contests, draftGroup -> (LiveDraftGroup, [LiveContest]) in
            let contests = contests[lineup.id] ?? []
            print("data - live contests", contests)
            draftGroup.listeners = contests.map { $0 as LiveDraftGroupListener }
            contests.forEach { $0.draftGroup = draftGroup }
            return (draftGroup, contests)
        }
    }

}
