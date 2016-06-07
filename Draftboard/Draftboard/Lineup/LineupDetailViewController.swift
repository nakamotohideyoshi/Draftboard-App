//
//  LineupDetailController.swift
//  Draftboard
//
//  Created by Anson Schall on 5/19/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDetailViewController: DraftboardViewController {
    
    /*
     * This controls a detail view for:
     * 1. An existing lineup, not editing
     * 2. An existing lineup, editing
     * 3. A new blank lineup, editing
     */
    
    var lineupDetailView: LineupDetailView { return view as! LineupDetailView }
    var editButton: UIButton { return lineupDetailView.editButton }
    var flipButton: UIButton { return lineupDetailView.flipButton }
    var nameField: UITextField { return lineupDetailView.nameField }
    
    var lineup: LineupWithStart?
    var draftGroup: DraftGroup?
    
    /*
    var lineupID: Int?
    var lineupSport: String = ""
    var lineupName: String = ""
    var lineupPlayers: [Player] = []
    var lineupStart: NSDate = NSDate()
    var lineupFees: Double = 0.00
    var lineupEntries: Int = 0
    var lineupBudget: Double = 0.00
    var lineupSalary: Double = 0.00
    var lineupPoints: Double = 0
    var lineupWinnings: Double = 0.00
    var lineupPMR: Double = 0
     */
    
    convenience init(lineup: LineupWithStart) {
        self.init()
        self.lineup = lineup
    }
    
    override func loadView() {
        self.view = LineupDetailView()
    }
    
    override func viewDidLoad() {
        let view = lineupDetailView
        
        // Sport icon
        view.sportIcon.image = UIImage(named: "icon-baseball")
        
        // Lineup name
        view.nameField.delegate = self
        view.nameField.placeholder = lineup?.name ?? "Lineup Name"
        view.nameField.text = lineup?.name ?? "Lineup Name"
        
        // Edit button
        
        // Flip button
        
        // Players
        view.tableView.delegate = self
        view.tableView.dataSource = self
        
        // Countdown
        view.footerView.countdown.countdownView.date = lineup!.start
        
        // Fees / Entries
        
        // Total salary remaining
        
        // Average salary remaining
        
        // Points
        
        // Winnings
        
        // PMR
        
        view.editAction = {
            if view.footerView.configuration == .Normal {
                view.footerView.configuration = .Editing
            } else if view.footerView.configuration == .Editing {
                view.footerView.configuration = .Live
            } else if view.footerView.configuration == .Live {
                view.footerView.configuration = .Normal
            }
            
        }
        
        /*
        if let draftGroup = draftGroup {
            let countdownView = CountdownView(date: draftGroup.start, size: 18.0, color: UIColor(0x46495e))
    //            countdownView.frame = view.liveInValue.bounds
    //            countdownView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            view.liveInValue.addSubview(countdownView)
            countdownView.leftRancor.constraintEqualToRancor(view.liveInValue.leftRancor).active = true
            countdownView.topRancor.constraintEqualToRancor(view.liveInValue.topRancor).active = true
        }
         */

        /*
        lineup?.getDraftGroup().then { draftGroup -> Void in
            let countdownView = CountdownView(date: draftGroup.start, size: 18.0, color: UIColor(0x46495e))
//            countdownView.frame = view.liveInValue.bounds
//            countdownView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            view.liveInValue.addSubview(countdownView)
            countdownView.leftRancor.constraintEqualToRancor(view.liveInValue.leftRancor).active = true
            countdownView.topRancor.constraintEqualToRancor(view.liveInValue.topRancor).active = true
        }
         */
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // Edit button
        editButton.alpha = editing ? 0 : 1
        editButton.userInteractionEnabled = editing

        // Flip button
        flipButton.alpha = editing ? 0 : 1
        flipButton.userInteractionEnabled = editing
        
        // Name field
        nameField.userInteractionEnabled = editing
        nameField.clearButtonMode = editing ? .UnlessEditing : .Never
        
        // Footer
        lineupDetailView.footerView.configuration = editing ? .Editing : .Normal
    }
    
    func update() {
        if let lineup = lineup {
            lineup.getDraftGroup().then { draftGroup -> Void in
                
            }
        }
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if buttonType == .Back {
            self.navController?.popViewController()
        }
    }
    
    // DraftboardTitlebarDatasource
    
    override func titlebarTitle() -> String {
        return (lineup == nil) ? "NEW LINEUP" : "EDIT LINEUP"
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType? {
        return .DisabledValue
    }

    override func titlebarRightButtonText() -> String? {
        return "SAVE"
    }
    
}

// MARK: -

private typealias TableViewDelegate = LineupDetailViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return lineup?.playerIDs.count ?? 0
        return lineup?.slots.count ?? 0
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
        if let slot = lineup?.slots[indexPath.row] {
            cell.positionLabel.text = slot.name
            if let player = slot.player {
                cell.avatarImageView.player = player
                cell.nameLabel.text = player.shortName
                if let player = player as? LineupPlayerWithGame {
                    cell.teamLabel.text = " - " + player.game.home.alias + " vs " + player.game.away.alias
                } else {
                    cell.teamLabel.text = " - " + player.teamAlias
                }
                cell.salaryLabel.text = Format.currency.stringFromNumber(player.salary ?? 0)
            }
        }
        cell.borderView.hidden = (indexPath.row == (lineup?.slots.count ?? 0) - 1)
        
        return cell
    }
    
    // UITableViewDelegate
    
}

private typealias TextFieldDelegate = LineupDetailViewController
extension TextFieldDelegate: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



