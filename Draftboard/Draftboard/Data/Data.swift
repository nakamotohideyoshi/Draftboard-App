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

extension DraftGroup {
//    func getGames() -> Promise<
}

