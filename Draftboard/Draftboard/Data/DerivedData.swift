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
            
            var draftGroupsBySportName = [String: [DraftGroupWithContestCount]]()
            draftGroups.map { draftGroup in
                // Add contest counts to draftgroups
                draftGroup.withContestCount(contests.filter{$0.draftGroupID == draftGroup.id}.count)
            }.filter {
                // Filter by contest existence
                $0.contestCount > 0
            }.sort { a, b in
                // Order by start date
                a.start.compare(b.start) == .OrderedAscending
            }.forEach {
                // Organize by sport name
                draftGroupsBySportName[$0.sportName, withDefault: []].append($0)
            }
            return draftGroupsBySportName
            
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
        return draftGroupsBySportName.get().then {
            $0[sportName]!.map {
                let title = "\($0.start)"
                let subtitle = "\($0.contestCount) Contests, \($0.numGames) Games"
                return Choice(title: title, subtitle: subtitle, value: $0)
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