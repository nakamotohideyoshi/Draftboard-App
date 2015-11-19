//
//  DDM.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//
import UIKit

enum DDMError: ErrorType {
    case LoadingError(sportId: Int)
    case NotHandled
}

enum DDMResult<T, U> {
    case Success(T)
    case Failure(U)
}

final class DDM {
    static let sharedInstance = DDM()
    
    var sports = [Sport]()
    var nbaTeams = [Team]()
    var nbaPlayers = [Player]()
    var currentSport: Sport
    
    static var players: [Player] = []
    class func requestPlayers() {
        API.draftGroup(id: 1) { json in
//            let dict = json as! NSDictionary
//            let playerArray = dict["players"] as! NSArray
//            for playerDict in playerArray {
//                DDM.players.append(Player(data: playerDict as! NSDictionary))
//            }
        }
    }
    
    init() {
        let sportData = DDM.sharedInstance.loadJsonFromBundle("sports")
        let nbaTeamData = DDM.sharedInstance.loadJsonFromBundle("nba_teams")
        let nbaPlayerData = DDM.sharedInstance.loadJsonFromBundle("nba_players")
        
        let sportsArray = sportData?["sports"] as! NSArray
        for (_, data) in sportsArray.enumerate() {
            sports.append(Sport(data: data as! NSDictionary))
        }
        
        let nbaTeamsArray = nbaTeamData?["teams"] as! NSArray
        for (_, data) in nbaTeamsArray.enumerate() {
            nbaTeams.append(Team(data: data as! NSDictionary))
        }
        
        let nbaPlayersArray = nbaPlayerData?["players"] as! NSArray
        for (_, data) in nbaPlayersArray.enumerate() {
            nbaPlayers.append(Player(data: data as! NSDictionary))
        }
    
        currentSport = sports[0]
    }
    
    /*
    class func players() -> [Player]? {
        return DDM.sharedInstance.nbaPlayers
    }
    */
    
    class func teams() -> [Team]? {
        return DDM.sharedInstance.nbaTeams
    }
    
    class func teamForId(id: Int) -> Team? {
        let teams = DDM.sharedInstance.nbaTeams
        
        for (_, team) in teams.enumerate() {
            if (team.id == id) {
                return team
            }
        }
        
        return nil
    }
    
    func loadJsonFromBundle(filename: String) -> NSDictionary? {
        let bundlePath = NSBundle.mainBundle().pathForResource(filename, ofType: "json")!
        
        do {
            let jsonData = try NSData(contentsOfFile: bundlePath, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            return jsonResult
        } catch {
            print("error loading json", filename)
        }
        
        return nil
    }
    
    class func getDraftGroup() {
        API.draftGroup(id: 1) { json in
            print(json)
        }
    }
    
    class func playersForContest(contest: Contest, completion: (result: DDMResult<[Model], DDMError>) -> Void) {
//        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
//        
//        dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
//            do {
//                let data = try DDM.playersForSport(0)
//                completion(result: DDMResult.Success(data))
//            } catch let error as DDMError {
//                completion(result: DDMResult.Failure(error))
//            } catch {
//                completion(result: DDMResult.Failure(DDMError.NotHandled))
//            }
//        }
    }
}
