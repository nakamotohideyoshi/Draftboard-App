//
//  LineupDetailController.swift
//  Draftboard
//
//  Created by Anson Schall on 5/19/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit
import PusherSwift

class LineupDetailViewController: DraftboardViewController {
    
    /*
     * This controls a detail view for:
     * 1. An existing lineup, not editing
     * 2. An existing lineup, editing
     * 3. A new blank lineup, editing
     */
    
    override var overlapsTabBar: Bool { return true }
    
    var lineupDetailView: LineupDetailView { return view as! LineupDetailView }
    var overlayView: UIControl { return lineupDetailView.overlayView }
    var tableView: UITableView { return lineupDetailView.tableView }
    var editButton: UIButton { return lineupDetailView.editButton }
    var flipButton: UIButton { return lineupDetailView.flipButton }
    var sportIcon: UIImageView { return lineupDetailView.sportIcon }
    var nameField: UITextField { return lineupDetailView.nameField }
    
    private var untouchedLineup: LineupWithStart?
    private var workingLineup: LineupWithStart?
    var lineup: LineupWithStart? {
        set { setLineup(newValue) }
        get { return getLineup() }
    }

    var liveDraftGroup: LiveDraftGroup?
    var liveContests: [LiveContest]?
    
    var draftViewController = LineupDraftViewController()
    
    override func loadView() {
        self.view = LineupDetailView()
    }
    
    override func viewDidLoad() {
        // FIXME: Don't rely on lineup being non-nil
        if lineup == nil {
            let draftGroup = DraftGroup(id: 1, sportName: "nba", start: .distantFuture(), numGames: 0)
            lineup = LineupWithStart(draftGroup: draftGroup)
        }
        // Overlay
        overlayView.addTarget(self, action: #selector(overlayTapped), forControlEvents: .TouchUpInside)
        
        // Sport icon
        sportIcon.image = Sport.icons[lineup!.sportName]
        
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
            self.viewWillAppear(false)
        }
        
        lineup?.getEntries().then { entries -> Void in
            let totalBuyin = entries.reduce(0) { $0 + $1.contest.buyin }
            let feesText = Format.currency.stringFromNumber(totalBuyin)!
            let text = "\(feesText) / \(entries.count)"
            self.lineupDetailView.footerView.feesEntries.valueLabel.text = text
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        let selectedIndexPath = tableView.indexPathForSelectedRow
        tableView.allowsSelection = (navController != nil)
        tableView.reloadData()
        if let indexPath = selectedIndexPath {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            delay(0.15) {
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
        navController?.titlebar.updateElements()
        delay(0.3) {
            self.updateFooterStats()
        }
        
        if lineup?.isLive == false {
            lineupDetailView.footerView.configuration = editing ? .Editing : .Normal
            editButton.hidden = false
        }

        if lineup?.isLive == true {
            lineupDetailView.footerView.configuration = .Live
            editButton.hidden = true

            if liveDraftGroup == nil {
                Data.liveContests(for: lineup!).then { draftGroup, contests -> Void in
                    contests.forEach { $0.listener = self }
                    draftGroup.listeners.append(self)
                    draftGroup.startRealtime()
                    self.liveDraftGroup = draftGroup
                    self.liveContests = contests
                    self.updatePoints()
                    self.updateTimeRemaining()
                    self.updateWinnings()
                }
            }
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
    
    func setLineup(newLineup: LineupWithStart?) {
        untouchedLineup = newLineup
        workingLineup = (newLineup == nil) ? nil : LineupWithStart(lineup: newLineup!)
    }
    
    func getLineup() -> LineupWithStart? {
        return workingLineup
    }
    
    func overlayTapped() {
        nameField.resignFirstResponder()
    }
    
    func updatePoints() {
        tableView.reloadData()
        let myLineup = LiveLineup()
        myLineup.players = lineup!.players!.map { $0.id }
        let points = liveDraftGroup!.points(for: myLineup)
        lineupDetailView.footerView.points.valueLabel.text = Format.points.stringFromNumber(points)
    }
    
    func updateTimeRemaining() {
        tableView.reloadData()
        let games = (lineup!.players as! [PlayerWithPositionAndGame]).map { $0.game.srid }
        let timeRemaining = games.reduce(0) { $0 + liveDraftGroup!.timeRemaining(for: $1) }
        lineupDetailView.footerView.pmr.valueLabel.text = String(format: "%.0f", timeRemaining)
    }
    
    func updateWinnings() {
        let winnings = liveContests!.reduce(0) { total, contest -> Double in
            let rank = Int(contest.lineups.indexOf { $0.id == lineup!.id }!)
            let payout = contest.prizes[safe: rank] ?? 0
            return total + payout
        }
        lineupDetailView.footerView.winnings.valueLabel.text = Format.currency.stringFromNumber(winnings)
    }
    
    func updateFooterStats() {
        // TODO: This stinks
        let totalValueLabel = lineupDetailView.footerView.totalSalaryRem.valueLabel
        let totalValueEnd = lineup!.totalSalaryRemaining
        let totalValueStart = Format.currency.numberFromString(totalValueLabel.text!)!.doubleValue
        let totalValueDelta = totalValueEnd - totalValueStart
        
        let avgValueLabel = lineupDetailView.footerView.avgSalaryRem.valueLabel
        let avgValueEnd = lineup!.avgSalaryRemaining
        let avgValueStart = Format.currency.numberFromString(avgValueLabel.text!)!.doubleValue
        let avgValueDelta = avgValueEnd - avgValueStart

        let spring = Spring(stiffness: 8.0, damping: 0, velocity: 0.0)
        spring.updateBlock = { (value) -> Void in
            let totalValue = round((totalValueStart + (totalValueDelta * Double(value))) / 100) * 100
            totalValueLabel.text = Format.currency.stringFromNumber(totalValue)
            totalValueLabel.textColor = (totalValue >= 0) ? UIColor(0x46495e) : UIColor(0xe42e2f)
            let avgValue = round((avgValueStart + (avgValueDelta * Double(value))) / 100) * 100
            avgValueLabel.text = Format.currency.stringFromNumber(avgValue)
            avgValueLabel.textColor = (avgValue >= 0) ? UIColor(0x46495e) : UIColor(0xe42e2f)
        }
        spring.start()
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        nameField.resignFirstResponder()
        
        if (buttonType == .Value) {
            untouchedLineup = lineup
            lineup?.save().then { _ in
                self.navController?.popViewController()
            }
        }

        if buttonType == .Back {
            if nameField.isFirstResponder() {
                nameField.resignFirstResponder()
            }
            let dirty = (lineup?.name != untouchedLineup?.name) ||
                (lineup?.players != untouchedLineup?.players)
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
        cell.withinBudget = true
        cell.actionButtonDelegate = self
        cell.setLineupSlot(slot)
        if lineup?.isLive == true {
            if let player = slot.player, liveDraftGroup = liveDraftGroup {
                let playerPoints = liveDraftGroup.points(for: player.id)
                cell.salaryLabel.text = Format.points.stringFromNumber(playerPoints)
            } else {
                cell.salaryLabel.text = ""
            }
            if let player = slot.player as? PlayerWithPositionAndGame, liveDraftGroup = liveDraftGroup {
                let playerTimeRemaining = liveDraftGroup.timeRemaining(for: player.game.srid)
                cell.timeRemainingView.remaining = playerTimeRemaining / Sport.gameDuration[lineup!.sportName]!
            } else {
                cell.timeRemainingView.remaining = 0
            }
        }
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let slot = lineup?.slots[safe: indexPath.row]
        if let player = slot?.player {
            let playerDetailViewController = PlayerDetailViewController()
            playerDetailViewController.sportName = lineup?.sportName
            playerDetailViewController.player = player
            navController?.pushViewController(playerDetailViewController)
        } else {
            draftViewController.slot = slot
            navController?.pushViewController(draftViewController)
        }
    }
    
    // LineupPlayerCellActionButtonDelegate
    
    func actionButtonTappedForCell(cell: LineupPlayerCell) {
        let indexPath = tableView.indexPathForCell(cell)!
        lineup!.slots[indexPath.row].player = nil
        tableView.reloadData()
        navController?.updateTitlebar()
        delay(0.1) {
            self.updateFooterStats()
        }
    }
    
}

private typealias TextFieldDelegate = LineupDetailViewController
extension TextFieldDelegate: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_: UITextField) {
        lineupDetailView.showOverlay()
    }
    
    func textFieldDidEndEditing(_: UITextField) {
        if nameField.text ?? "" == "" {
            nameField.placeholder = untouchedLineup?.name ?? "Lineup Name"
            nameField.text = untouchedLineup?.name ?? "Lineup Name"
        }
        lineup?.name = nameField.text!
        lineupDetailView.hideOverlay()
    }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        nameField.resignFirstResponder()
        return true
    }
    
}

private typealias LiveListener = LineupDetailViewController
extension LiveListener: LiveDraftGroupListener, LiveContestListener {
    func pointsChanged(player: LivePlayer) {
        updatePoints()
    }
    func timeRemainingChanged(game: LiveGame) {
        print("ldvc time remaining changed!")
        updateTimeRemaining()
    }
    func rankChanged() {
        print("ldvc rank changed!")
        updateWinnings()
    }
}

