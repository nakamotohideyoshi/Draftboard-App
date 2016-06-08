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
    var tableView: UITableView { return lineupDetailView.tableView }
    var editButton: UIButton { return lineupDetailView.editButton }
    var flipButton: UIButton { return lineupDetailView.flipButton }
    var sportIcon: UIImageView { return lineupDetailView.sportIcon }
    var nameField: UITextField { return lineupDetailView.nameField }
    
    var uneditedLineup: LineupWithStart?
    var lineup: LineupWithStart?
    
    convenience init(lineup: LineupWithStart) {
        self.init()
        self.lineup = lineup
    }
    
    override func loadView() {
        self.view = LineupDetailView()
    }
    
    override func viewDidLoad() {
        // Sport icon
        sportIcon.image = UIImage(named: "icon-baseball")
        
        // Lineup name
        nameField.delegate = self
        nameField.placeholder = lineup?.name ?? "Lineup Name"
        nameField.text = lineup?.name ?? "Lineup Name"
        
        // Edit button
        
        // Flip button
        
        // Players
        tableView.delegate = self
        tableView.dataSource = self
        
        // Countdown
        lineupDetailView.footerView.countdown.countdownView.date = lineup!.start
        
        // Fees / Entries
        
        // Total salary remaining
        
        // Average salary remaining
        
        // Points
        
        // Winnings
        
        // PMR
        
//        let footerView = lineupDetailView.footerView
//        lineupDetailView.editAction = {
//            if footerView.configuration == .Normal {
//                footerView.configuration = .Editing
//            } else if footerView.configuration == .Editing {
//                footerView.configuration = .Live
//            } else if footerView.configuration == .Live {
//                footerView.configuration = .Normal
//            }
//        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        uneditedLineup = LineupWithStart(lineup: lineup!)
        
        // Get game info for players
        lineup?.getPlayersWithGames().then { playersWithGames -> Void in
            self.lineup?.players = playersWithGames
            self.tableView.reloadData()
        }
        
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
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if buttonType == .Back {
            if nameField.isFirstResponder() {
                nameField.resignFirstResponder()
            }
            let dirty = (nameField.text != uneditedLineup?.name) ||
                (lineup?.players != uneditedLineup?.players)
            if !dirty {
                self.navController?.popViewController()
            } else {
                let vc = ErrorViewController(nibName: "ErrorViewController", bundle: nil)
                let actions = ["Abandon changes", "Keep working"]
                
                vc.actions = actions
                vc.promise.then { index -> Void in
                    RootViewController.sharedInstance.popAlertViewController()
                    if index == 0 {
                        self.navController?.popViewController()
                    }
                }
                
                RootViewController.sharedInstance.pushAlertViewController(vc)
                vc.titleLabel.text = "REALLY?"
                vc.errorLabel.text = "You'll lose your changes if you leave without saving."
            }
        }
    }
    
    // DraftboardTitlebarDatasource
    
    override func titlebarTitle() -> String {
        return (lineup?.id > 0) ? "EDIT LINEUP" : "NEW LINEUP"
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
        return lineup?.slots.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lineupDetailView.tableView.dequeueCellForIndexPath(indexPath)
        
        if let slot = lineup?.slots[indexPath.row] {
            cell.positionLabel.text = slot.name
            if let player = slot.player {
                cell.avatarImageView.player = player
                cell.nameLabel.text = player.shortName
                if let player = player as? PlayerWithGame {
                    cell.teamLabel.text = " - " + player.game.home.alias + " vs " + player.game.away.alias
                } else {
                    cell.teamLabel.text = " - " + player.teamAlias
                }
                cell.salaryLabel.text = Format.currency.stringFromNumber(player.salary ?? 0)
            } else {
                cell.avatarImageView.player = nil
                cell.nameLabel.text = "Select \(slot.description)"
            }
        }
        cell.borderView.hidden = (indexPath.row == (lineup?.slots.count ?? 0) - 1)
        
        return cell
    }
    
    // UITableViewDelegate
    
}

private typealias TextFieldDelegate = LineupDetailViewController
extension TextFieldDelegate: UITextFieldDelegate {
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        nameField.resignFirstResponder()
        if nameField.text ?? "" == "" {
            nameField.text = nameField.placeholder
        }
        return true
    }
    
}



