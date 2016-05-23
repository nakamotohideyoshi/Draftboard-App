//
//  LineupDetailController.swift
//  Draftboard
//
//  Created by Anson Schall on 5/19/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDetailController: DraftboardViewController {
    
    var downcastedView: LineupDetailControllerView { return view as! LineupDetailControllerView }
    var lineup: Lineup?
    
    convenience init(lineup: Lineup) {
        self.init()
        self.lineup = lineup
    }
    
    override func loadView() {
        self.view = LineupDetailControllerView()
        let view = downcastedView
        
        view.nameField.text = lineup?.name
        
        
        view.tableView.delegate = self
        view.tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        let view = downcastedView
        lineup?.getDraftGroup().then { draftGroup -> Void in
            let countdownView = CountdownView(date: draftGroup.start, size: 18.0, color: UIColor(0x46495e))
//            countdownView.frame = view.liveInValue.bounds
//            countdownView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            view.liveInValue.addSubview(countdownView)
            countdownView.leftRancor.constraintEqualToRancor(view.liveInValue.leftRancor).active = true
            countdownView.topRancor.constraintEqualToRancor(view.liveInValue.topRancor).active = true
            
        }
    }
    
    func update() {
        if let lineup = lineup {
            lineup.getDraftGroup().then { draftGroup -> Void in
                
            }
        }
    }
    
}

// MARK: -

extension LineupDetailController: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineup?.playerIDs.count ?? 0
//        return 9
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = downcastedView.tableView.dequeueCellForIndexPath(indexPath)
        
//        if let lineup = lineup {
//            let playerID = lineup.playerIDs[indexPath.row]
//
//            lineup.getDraftGroup().then { draftGroup in
//                let player = draftGroup.players[0]
//                player.gameSRID
//            }
//            when(lineup.getDraftGroup(), lineup.getPlayer(id: playerID)).then { (draftGroup, player) -> in
//                
//            }
//        }
        
//        lineup?.getDraftGroup().then { draftGroup in
//            cell.
//        }
        if let playerID = lineup?.playerIDs[indexPath.row] {
            lineup?.getPlayer(id: playerID).then { player in
                cell.player = player
//                cell.teamLabel
            }
        }
        cell.borderView.hidden = (indexPath.row == (lineup?.playerIDs.count ?? 0) - 1)
        
        return cell
    }
    
    // UITableViewDelegate
    
}

