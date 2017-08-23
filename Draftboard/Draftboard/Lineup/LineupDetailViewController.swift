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
    var playerStatuses: [NSDictionary]?
    
    var draftViewController = LineupDraftViewController()
    
    var showPlayerAction: (player: Player, sportName: String) -> Void = {_ in}
    
    override func loadView() {
        self.view = LineupDetailView()
    }
    
    override func viewDidLoad() {
        print("view did load for lineup", lineup != nil ? lineup!.id : "empty", lineup != nil ? lineup?.name : "emtpy")
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
        when(lineup!.getPlayersWithGames(), Data.playerStatuses[lineup!.sportName].get()).then { players, statuses -> Void in
            self.lineup?.players = players
            self.playerStatuses = statuses
            self.tableView.reloadData()
            self.viewWillAppear(false)
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        print("view will appear for lineup ", lineup!.id, lineup?.name)
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
        
        lineup?.getEntries().then { entries -> Void in
            let totalBuyin = entries.reduce(0) { $0 + $1.contest.buyin }
            let feesText = Format.currency.stringFromNumber(totalBuyin)!
            let text = "\(entries.count)"
            self.lineupDetailView.footerView.fees.valueLabel.text = feesText
            self.lineupDetailView.footerView.entries.valueLabel.text = text
        }
        
        if lineup?.isLive == false {
            lineupDetailView.footerView.configuration = editing ? .Editing : .Normal
            editButton.hidden = false
            lineupDetailView.columnLabel.text = "Salary".uppercaseString
            
            for subview in lineupDetailView.footerView.subviews {
                if let statView = subview as? StatView {
                    if let countdownView = statView as? CountdownStatView {
                        countdownView.countdownView.color = UIColor(0x46495e)
                    } else {
                        statView.valueLabel.textColor = UIColor(0x46495e)
                    }
                    statView.backgroundColor = .clearColor()
                    statView.rightBorderView.backgroundColor = UIColor(0xebedf2)
                }
            }
            lineupDetailView.footerView.topBorderView.backgroundColor = UIColor(0xebedf2)
        }

        if lineup?.isLive == true {
            lineupDetailView.footerView.configuration = .Live
            editButton.hidden = true
            lineupDetailView.columnLabel.text = "PTS"
            tableView.allowsSelection = true
            
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
            
            
            lineup?.isFinished().then { finished -> Void in
                if (finished) {
                    self.lineupDetailView.footerView.configuration = .Finished
                    self.lineupDetailView.footerView.winnings.titleLabel.text = "Won".uppercaseString
                    self.lineup?.getEntriesForFinished().then { entries -> Void in
                        self.lineupDetailView.footerView.finishedEntries.valueLabel.text = "\(entries.count)"
                    }
                } else {
                    self.lineupDetailView.footerView.configuration = .Live
                    self.lineupDetailView.footerView.winnings.titleLabel.text = "Winning".uppercaseString
                }
            }
        }
    }
    
    func emptyViewData() {
        workingLineup = nil
        untouchedLineup = nil
        liveDraftGroup = nil
        liveContests = nil
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
        if liveDraftGroup != nil {
            let myLineup = LiveLineup()
            myLineup.players = lineup!.players!.map { $0.id }
            let points = liveDraftGroup!.points(for: myLineup)
            lineupDetailView.footerView.points.valueLabel.text = Format.points.stringFromNumber(points)
        }
    }
    
    func updateTimeRemaining() {
        tableView.reloadData()
        if (lineup!.isLive && liveContests?.count == 0) {
            lineupDetailView.footerView.pmr.valueLabel.text = String(format: "%.0f", 0)
        } else {
            if liveDraftGroup != nil {
                let games = (lineup!.players as! [PlayerWithPositionAndGame]).map { $0.game.srid }
                let timeRemaining = games.reduce(0) { $0 + liveDraftGroup!.timeRemaining(for: $1) }
                lineupDetailView.footerView.pmr.valueLabel.text = String(format: "%.0f", timeRemaining)
            }
        }
        
    }
    
    func updateWinnings() {
        if (lineup!.isLive && liveContests?.count == 0) {
            Data.getWinnings(for: lineup!).then { winnings -> Void in
                self.lineupDetailView.footerView.winnings.valueLabel.text = Format.currency.stringFromNumber(winnings)
            }
        } else {
            let winnings = liveContests!.reduce(0) { total, contest -> Double in
                if contest.lineups.count > 0 {
                    let rank = Int(contest.lineups.indexOf { $0.id == lineup!.id }!)
                    let payout = contest.prizes[safe: rank] ?? 0
                    return total + payout
                } else {
                    return total
                }
            }
            lineupDetailView.footerView.winnings.valueLabel.text = Format.currency.stringFromNumber(winnings)
        }
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
                let actions = ["Discard changes", "Keep working"]
                
                vc.actions = actions
                vc.promise.then { index -> Void in
                    RootViewController.sharedInstance.popAlertViewController()
                    if index == 0 {
                        self.navController?.popViewController()
                    }
                }
                
                RootViewController.sharedInstance.pushAlertViewController(vc)
                vc.titleLabel.text = "Cancel Lineup Edit".uppercaseString
                vc.errorLabel.text = "You will lose your changes if you leave without saving."
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
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate, LineupPlayerCellActionButtonDelegate, PlayerDetailDraftButtonDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lineup?.slots.count ?? 0
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lineupDetailView.tableView.dequeueCellForIndexPath(indexPath)
        
        let slot = lineup!.slots[safe: indexPath.row]
        cell.showAllInfo = true
        cell.showAddButton = false
        cell.showRemoveButton = editing && slot!.player != nil
        cell.showBottomBorder = slot !== lineup?.slots.last
        cell.withinBudget = true
        cell.actionButtonDelegate = self
        cell.setLineupSlot(slot)
        if let player = slot!.player {
            if playerStatuses != nil {
                let statuses: [NSDictionary] = try! playerStatuses!.filter {
                    try $0.get("player_srid") == player.srid
                }
                if statuses.count == 0 {
                    cell.setPlayerStatus("")
                } else {
                    let playerStatus: NSDictionary = statuses.first!
                    let status:String = try! playerStatus.get("status")
                    cell.setPlayerStatus(status)
                }
            } else {
                cell.setPlayerStatus("")
            }
        } else {
            cell.setPlayerStatus("")
        }
        if lineup?.isLive == true {
            if let player = slot!.player, liveDraftGroup = liveDraftGroup {
                let playerPoints = liveDraftGroup.points(for: player.id)
                cell.salaryLabel.text = Format.points.stringFromNumber(playerPoints)
                cell.fppgLabel.text = ""
            } else {
                cell.salaryLabel.text = ""
                cell.fppgLabel.text = ""
            }
            if let player = slot!.player as? PlayerWithPositionAndGame, liveDraftGroup = liveDraftGroup {
                let playerTimeRemaining = liveDraftGroup.timeRemaining(for: player.game.srid)
                cell.timeRemainingView.remaining = playerTimeRemaining / Sport.gameDuration[lineup!.sportName]!
            } else {
                cell.timeRemainingView.remaining = 0
            }
        } else {
            cell.timeRemainingView.remaining = 0
        }
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let slot = lineup?.slots[safe: indexPath.row]
        if editing == true {
            if let player = slot?.player {
                let playerDetailViewController = PlayerDetailViewController()
                playerDetailViewController.sportName = lineup?.sportName
                playerDetailViewController.player = player
                playerDetailViewController.showRemoveButton = true
                playerDetailViewController.draftButtonDelegate = self
                playerDetailViewController.indexPath = indexPath
                navController?.pushViewController(playerDetailViewController)
            } else {
                draftViewController.slot = slot
                navController?.pushViewController(draftViewController)
            }
        } else {
            self.showPlayerAction(player: (slot?.player)!, sportName: (lineup?.sportName)!)
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
    
    // PlayerDetailDraftButtonDelegate
    func draftButtonTapped(indexPath: NSIndexPath) {
        lineup!.slots[indexPath.row].player = nil
        tableView.reloadData()
        navController?.updateTitlebar()
        delay(0.1) {
            self.updateFooterStats()
        }
        navController?.popViewController()
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
        //print("points changed!")
        updatePoints()
    }
    func timeRemainingChanged(game: LiveGame) {
        //print("ldvc time remaining changed!")
        updateTimeRemaining()
    }
    func rankChanged() {
        //print("ldvc rank changed!")
        updateWinnings()
    }
}

