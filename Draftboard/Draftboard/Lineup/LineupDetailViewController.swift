//
//  LineupDetailController.swift
//  Draftboard
//
//  Created by Anson Schall on 5/19/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDetailViewController: DraftboardViewController {
    
    var lineup: Lineup?
    var lineupDetailView: LineupDetailView { return view as! LineupDetailView }
    
    convenience init(lineup: Lineup) {
        self.init()
        self.lineup = lineup
    }
    
    override func loadView() {
        self.view = LineupDetailView()
    }
    
    override func viewDidLoad() {
        let view = lineupDetailView
        view.nameField.text = lineup?.name
        view.tableView.delegate = self
        view.tableView.dataSource = self
        
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

extension LineupDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineup?.playerIDs.count ?? 0
//        return 9
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lineupDetailView.tableView.dequeueCellForIndexPath(indexPath)
        
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

