//
//  LineupEntryViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 7/1/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupEntryViewController: DraftboardViewController {
    
    var lineupEntryView: LineupEntryView { return view as! LineupEntryView }
    var tableView: LineupEntryTableView { return lineupEntryView.tableView }
    var flipButton: UIButton { return lineupEntryView.flipButton }
    var sportIcon: UIImageView { return lineupEntryView.sportIcon }
    var nameLabel: UILabel { return lineupEntryView.nameLabel }

    var lineup: LineupWithStart? { didSet { viewDidLoad() } }
    var entries: [LineupEntry] = [] { didSet { tableView.reloadData() } }
    var finishedEntries: [LineupFinishedEntry] = [] { didSet { tableView.reloadData() } }
    var lineupFinished: Bool = false
    
    var liveDraftGroup: LiveDraftGroup?
    var liveContests: [LiveContest]?
    
    var flipAction: (() -> Void) = {}

    override func loadView() {
        self.view = LineupEntryView()
    }
    
    override func viewDidLoad() {
        // FIXME: Don't rely on lineup being non-nil
        if lineup == nil {
            let draftGroup = DraftGroup(id: 1, sportName: "nba", start: NSDate.distantFuture(), numGames: 0)
            lineup = LineupWithStart(draftGroup: draftGroup)
        }
        
        // Sport icon
        sportIcon.image = Sport.icons[lineup!.sportName]
        
        // Lineup name
        nameLabel.text = lineup!.name
        
        // Edit button
        
        // Flip button
        
        // Players
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Countdown
        lineupEntryView.footerView.countdown.countdownView.date = lineup!.start
        
        // Get game info for players
        lineup?.getPlayersWithGames().then { players -> Void in
            self.lineup?.players = players
            self.tableView.reloadData()
            self.viewWillAppear(false)
        }

        lineup?.getEntries().then { entries -> Void in
            self.entries = entries
            self.tableView.reloadData()
            let totalBuyin = entries.reduce(0) { $0 + $1.contest.buyin }
            let feesText = Format.currency.stringFromNumber(totalBuyin)!
            let text = "\(entries.count)"
            self.lineupEntryView.footerView.fees.valueLabel.text = feesText
            self.lineupEntryView.footerView.entries.valueLabel.text = text
        }
        
        flipButton.addTarget(self, action: #selector(flipButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        if lineup?.isLive == false {
            lineupEntryView.footerView.configuration = .Normal
            lineupEntryView.columnLabel1.text = "Remove".uppercaseString
            lineupEntryView.columnLabel2.text = "Contest".uppercaseString
            lineupEntryView.columnLabel3.text = "Fee".uppercaseString
        }
        
        if lineup?.isLive == true {
            lineupEntryView.footerView.configuration = .Live
            lineupEntryView.columnLabel1.text = "Contest".uppercaseString
            lineupEntryView.columnLabel2.text = "".uppercaseString
            lineupEntryView.columnLabel3.text = "Pos / Winning".uppercaseString
            
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
                    self.lineupEntryView.footerView.configuration = .Finished
                    self.lineupEntryView.footerView.winnings.titleLabel.text = "Won".uppercaseString
                    self.lineupEntryView.columnLabel3.text = "Pos / Won".uppercaseString
                    self.lineup?.getEntriesForFinished().then { entries -> Void in
                        self.lineupEntryView.footerView.finishedEntries.valueLabel.text = "\(entries.count)"
                        self.lineupFinished = true
                        self.finishedEntries = entries
                    }
                } else {
                    self.lineupEntryView.footerView.configuration = .Live
                    self.lineupEntryView.footerView.winnings.titleLabel.text = "Winning".uppercaseString
                    self.lineupEntryView.columnLabel3.text = "Pos / Winning".uppercaseString
                    self.lineupFinished = false
                    self.finishedEntries = []
                }
            }
        }

    }
    
    func flipButtonTapped() {
        flipAction()
    }
    
    func updatePoints() {
        tableView.reloadData()
        let myLineup = LiveLineup()
        myLineup.players = lineup!.players!.map { $0.id }
        if liveDraftGroup != nil {
            let points = liveDraftGroup!.points(for: myLineup)
            lineupEntryView.footerView.points.valueLabel.text = Format.points.stringFromNumber(points)
        }
    }
    
    func updateTimeRemaining() {
        tableView.reloadData()
        if (lineup!.isLive && liveContests?.count == 0) {
            lineupEntryView.footerView.pmr.valueLabel.text = String(format: "%.0f", 0)
        } else {
            let games = (lineup!.players as! [PlayerWithPositionAndGame]).map { $0.game.srid }
            let timeRemaining = games.reduce(0) { $0 + liveDraftGroup!.timeRemaining(for: $1) }
            lineupEntryView.footerView.pmr.valueLabel.text = String(format: "%.0f", timeRemaining)
        }
    }
    
    func updateWinnings() {
        tableView.reloadData()
        let winnings = liveContests!.reduce(0) { total, contest -> Double in
            if contest.lineups.count > 0 {
                let rank = Int(contest.lineups.indexOf { $0.id == lineup!.id }!)
                let payout = contest.prizes[safe: rank] ?? 0
                return total + payout
            } else {
                return total
            }
        }
        lineupEntryView.footerView.winnings.valueLabel.text = Format.currency.stringFromNumber(winnings)
    }

}

private typealias TableViewDelegate = LineupEntryViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate, LineupEntryUpcomingCellActionButtonDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lineup?.isLive == true {
            if lineupFinished {
                return finishedEntries.count
            } else {
                return liveContests?.count ?? 0
            }
            
        }
        return entries.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if lineup?.isLive == true {
            return 60.0
        }
        return 40.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if lineup?.isLive == true {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(LineupEntryLiveCell), forIndexPath: indexPath) as! LineupEntryLiveCell
            if lineupFinished {
                let finishedEntry = finishedEntries[indexPath.row]
                cell.nameLabel.text = finishedEntry.contestName
                cell.posLabel.text = Format.ordinal.stringFromNumber(finishedEntry.finalRank)!
                cell.winningLabel.text = Format.currency.stringFromNumber(finishedEntry.payout)!
                
                if finishedEntry.contestName.rangeOfString("H2H") != nil {
                    cell.posBarContainer.hidden = true
                    cell.firstHHPosBar.hidden = false
                    cell.secondHHPosBar.hidden = false
                    cell.firstHHPosBar.backgroundColor = UIColor(0x5f626d)
                    cell.secondHHPosBar.backgroundColor = UIColor(0x307655)
                    let rank = finishedEntry.finalRank - 1
                    if rank == 0 {
                        cell.secondHHPosBar.backgroundColor = UIColor(0x00e956)
                    } else {
                        cell.firstHHPosBar.backgroundColor = .whiteColor()
                    }
                } else {
                    cell.posBarContainer.hidden = false
                    cell.firstHHPosBar.hidden = true
                    cell.secondHHPosBar.hidden = true
                    let rank = finishedEntry.finalRank - 1
                    if finishedEntry.contestName.rangeOfString("Tourney ") != nil {
                        for i in 0...7 {
                            cell.posBarContainer.subviews[i].backgroundColor = UIColor(0x5f626d)
                        }
                        for i in 7...9 {
                            cell.posBarContainer.subviews[i].backgroundColor = UIColor(0x307655)
                        }
                        if rank < 3 {
                            cell.posBarContainer.subviews[9 - rank].backgroundColor = UIColor(0x00e956)
                        } else {
                            cell.posBarContainer.subviews[9 - rank].backgroundColor = .whiteColor()
                        }
                    } else {
                        for i in 0...5 {
                            cell.posBarContainer.subviews[i].backgroundColor = UIColor(0x5f626d)
                        }
                        for i in 5...9 {
                            cell.posBarContainer.subviews[i].backgroundColor = UIColor(0x307655)
                        }
                        if rank < 5 {
                            cell.posBarContainer.subviews[9 - rank].backgroundColor = UIColor(0x00e956)
                        } else {
                            cell.posBarContainer.subviews[9 - rank].backgroundColor = .whiteColor()
                        }
                    }
                }
            } else {
                let contest = liveContests![indexPath.row]
                let rank = Int(contest.lineups.indexOf { $0.id == lineup!.id }!)
                let payout = contest.prizes[safe: rank] ?? 0
                cell.nameLabel.text = contest.contestName
                cell.posLabel.text = Format.ordinal.stringFromNumber(rank + 1)!
                cell.winningLabel.text = Format.currency.stringFromNumber(payout)!
                if contest.contestSize == 10 {
                    cell.posBarContainer.hidden = false
                    cell.firstHHPosBar.hidden = true
                    cell.secondHHPosBar.hidden = true
                    let limit = 10 - contest.prizes.count
                    for i in 0...limit {
                        cell.posBarContainer.subviews[i].backgroundColor = UIColor(0x5f626d)
                    }
                    for i in limit...9 {
                        cell.posBarContainer.subviews[i].backgroundColor = UIColor(0x307655)
                    }
                    if rank < contest.prizes.count {
                        cell.posBarContainer.subviews[9 - rank].backgroundColor = UIColor(0x00e956)
                    } else {
                        cell.posBarContainer.subviews[9 - rank].backgroundColor = .whiteColor()
                    }
                } else {
                    cell.posBarContainer.hidden = true
                    cell.firstHHPosBar.hidden = false
                    cell.secondHHPosBar.hidden = false
                    cell.firstHHPosBar.backgroundColor = UIColor(0x5f626d)
                    cell.secondHHPosBar.backgroundColor = UIColor(0x307655)
                    if rank == 0 {
                        cell.secondHHPosBar.backgroundColor = UIColor(0x00e956)
                    } else {
                        cell.firstHHPosBar.backgroundColor = .whiteColor()
                    }
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(LineupEntryUpcomingCell), forIndexPath: indexPath) as! LineupEntryUpcomingCell
            cell.actionButtonDelegate = self
            let entry = entries[indexPath.row]
            cell.nameLabel.text = entry.contest.name
            cell.feesLabel.text = Format.currency.stringFromNumber(entry.contest.buyin)!
            return cell
        }
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // LineupEntryUpcomingCellActionButtonDelegate
    
    func removeButtonTappedForCell(cell: LineupEntryUpcomingCell) {
        let indexPath = tableView.indexPathForCell(cell)!
        let entry = entries[indexPath.row]
        entry.unregister().then { result -> Void in
            self.entries.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            let totalBuyin = self.entries.reduce(0) { $0 + $1.contest.buyin }
            let feesText = Format.currency.stringFromNumber(totalBuyin)!
            let text = "\(self.entries.count)"
            self.lineupEntryView.footerView.fees.valueLabel.text = feesText
            self.lineupEntryView.footerView.entries.valueLabel.text = text
        }
    }
}

private typealias LiveListener = LineupEntryViewController
extension LiveListener: LiveDraftGroupListener, LiveContestListener {
    func pointsChanged(player: LivePlayer) {
        //print("entry vc points changed!")
        updatePoints()
    }
    func timeRemainingChanged(game: LiveGame) {
        //print("entry vc time remaining changed!")
        updateTimeRemaining()
    }
    func rankChanged() {
        //print("entry vc rank changed!")
        updateWinnings()
    }
}
