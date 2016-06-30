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
    var overlayView: UIControl { return lineupDetailView.overlayView }
    var tableView: UITableView { return lineupDetailView.tableView }
    var editButton: UIButton { return lineupDetailView.editButton }
    var flipButton: UIButton { return lineupDetailView.flipButton }
    var sportIcon: UIImageView { return lineupDetailView.sportIcon }
    var nameField: UITextField { return lineupDetailView.nameField }
    
    var uneditedLineup: LineupWithStart?
    var lineup: LineupWithStart?
    
    var draftViewController = LineupDraftViewController()
    
    convenience init(lineup: LineupWithStart) {
        self.init()
        self.lineup = LineupWithStart(lineup: lineup)
        self.uneditedLineup = lineup
    }
    
    override func loadView() {
        self.view = LineupDetailView()
    }
    
    override func viewWillAppear(animated: Bool) {
        navController?.titlebar.updateElements()
        tableView.reloadData()
        updateFooterStats()
    }
    
    override func viewDidLoad() {
        // Overlay
        overlayView.addTarget(self, action: #selector(overlayTapped), forControlEvents: .TouchUpInside)
        
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
        
        // Total and average/player salary remaining
        updateFooterStats()

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
        
        // Get game info for players
        lineup?.getPlayersWithGames().then { players -> Void in
            self.lineup?.players = players
            self.tableView.reloadData()
        }

    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        draftViewController.lineup = lineup
        lineup?.getDraftGroupWithPlayersWithGames().then { draftGroup -> Void in
            self.draftViewController.allPlayers = draftGroup.players
        }
        
        // Edit button
        editButton.alpha = editing ? 0 : 1
        editButton.userInteractionEnabled = editing

        // Flip button
        flipButton.alpha = editing ? 0 : 1
        flipButton.userInteractionEnabled = editing
        
        // Name field
        nameField.userInteractionEnabled = editing
        nameField.clearButtonMode = editing ? .Always : .Never
        
        // Footer
        lineupDetailView.footerView.configuration = editing ? .Editing : .Normal
    }
    
    func overlayTapped() {
        nameField.resignFirstResponder()
    }
    
    func updateFooterStats() {
        // TODO: This stinks
        lineupDetailView.footerView.totalSalaryRem.valueLabel.text = Format.currency.stringFromNumber(lineup!.totalSalaryRemaining)
        lineupDetailView.footerView.avgSalaryRem.valueLabel.text = Format.currency.stringFromNumber(lineup!.avgSalaryRemaining)
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        nameField.resignFirstResponder()
        
        if (buttonType == .Value) {
            uneditedLineup = lineup
            lineup?.save().then { _ in
                self.navController?.popViewController()
            }
        }

        if buttonType == .Back {
            if nameField.isFirstResponder() {
                nameField.resignFirstResponder()
            }
            let dirty = (lineup?.name != uneditedLineup?.name) ||
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
        if lineup?.emptySlots.count > 0 { return .DisabledValue }
        if lineup?.totalSalaryRemaining < 0 { return .DisabledValue }
        return .Value
    }

    override func titlebarRightButtonText() -> String? {
        return "SAVE"
    }
    
}

// MARK: -

private typealias TableViewDelegate = LineupDetailViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate, LineupPlayerCellActionButtonDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineup?.slots.count ?? 0
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lineupDetailView.tableView.dequeueCellForIndexPath(indexPath)
        
        let slot = lineup!.slots[indexPath.row]
        cell.showAllInfo = editing
        cell.showAddButton = false
        cell.showRemoveButton = editing && slot.player != nil
        cell.showBottomBorder = slot !== lineup?.slots.last
        cell.actionButtonDelegate = self
        cell.setLineupSlot(slot)
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let slot = lineup!.slots[indexPath.row]
        if slot.player == nil {
            draftViewController.slot = slot
            self.navController?.pushViewController(draftViewController)
        }
    }
    
    // LineupPlayerCellActionButtonDelegate
    
    func actionButtonTappedForCell(cell: LineupPlayerCell) {
        let indexPath = tableView.indexPathForCell(cell)!
        lineup!.slots[indexPath.row].player = nil
        tableView.reloadData()
        navController?.updateTitlebar()
        updateFooterStats()
    }
    
}

private typealias TextFieldDelegate = LineupDetailViewController
extension TextFieldDelegate: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_: UITextField) {
        lineupDetailView.showOverlay()
    }
    
    func textFieldDidEndEditing(_: UITextField) {
        if nameField.text ?? "" == "" {
            nameField.placeholder = uneditedLineup?.name ?? "Lineup Name"
            nameField.text = uneditedLineup?.name ?? "Lineup Name"
        }
        lineup?.name = nameField.text!
        lineupDetailView.hideOverlay()
    }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        nameField.resignFirstResponder()
        return true
    }
    
}
