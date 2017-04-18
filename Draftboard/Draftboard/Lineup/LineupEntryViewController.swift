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
    var tableView: UITableView { return lineupEntryView.tableView }
    var flipButton: UIButton { return lineupEntryView.flipButton }
    var sportIcon: UIImageView { return lineupEntryView.sportIcon }
    var nameLabel: UILabel { return lineupEntryView.nameLabel }

    var lineup: LineupWithStart? { didSet { viewDidLoad() } }
    var entries: [LineupEntry] = [] { didSet { tableView.reloadData() } }
    
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
        tableView.rowHeight = 40
//        tableView.rowHeight = 
        
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
            let text = "\(feesText) / \(entries.count)"
            self.lineupEntryView.footerView.feesEntries.valueLabel.text = text
        }
        
        flipButton.addTarget(self, action: #selector(flipButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        if lineup?.isLive == false {
            lineupEntryView.footerView.configuration = .Normal
        }
        
        if lineup?.isLive == true {
            lineupEntryView.footerView.configuration = .Live
            
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
    
    func flipButtonTapped() {
        flipAction()
    }
    
    func updatePoints() {
        tableView.reloadData()
        let myLineup = LiveLineup()
        myLineup.players = lineup!.players!.map { $0.id }
        let points = liveDraftGroup!.points(for: myLineup)
        lineupEntryView.footerView.points.valueLabel.text = Format.points.stringFromNumber(points)
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
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lineup?.isLive == true {
            return liveContests?.count ?? 0
        }
        return entries.count
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = LineupEntryCell()
        
        if lineup?.isLive == true {
            let contest = liveContests![indexPath.row]
            let rank = Int(contest.lineups.indexOf { $0.id == lineup!.id }!)
            let payout = contest.prizes[safe: rank] ?? 0
            cell.nameLabel.text = contest.contestName
            cell.feesLabel.text = Format.ordinal.stringFromNumber(rank + 1)! + " / " + Format.currency.stringFromNumber(payout)!
        } else {
            let entry = entries[indexPath.row]
            cell.nameLabel.text = entry.contest.name
            cell.feesLabel.text = Format.currency.stringFromNumber(entry.contest.buyin)!
        }
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

private typealias LiveListener = LineupEntryViewController
extension LiveListener: LiveDraftGroupListener, LiveContestListener {
    func pointsChanged(player: LivePlayer) {
        print("entry vc points changed!")
        updatePoints()
    }
    func timeRemainingChanged(game: LiveGame) {
        print("entry vc time remaining changed!")
        updateTimeRemaining()
    }
    func rankChanged() {
        print("entry vc rank changed!")
        updateWinnings()
    }
}



class LineupEntryCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let feesLabel = UILabel()
    let borderView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    override func layoutSubviews() {
        nameLabel.frame = CGRectMake(18, 0, bounds.width - 80, bounds.height)
        feesLabel.frame = CGRectMake(bounds.width - 80, 0, 62, bounds.height)
        borderView.frame = CGRectMake(0, bounds.height - 1, bounds.width, 1)
    }

    func setup() {
        addSubviews()
        setupSubviews()
    }
    
    func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(feesLabel)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        backgroundColor = .clearColor()
        
        nameLabel.font = .openSans(size: 11)
        nameLabel.textColor = .whiteColor()
        
        feesLabel.font = UIFont.oswald(size: 12)
        feesLabel.textColor = .whiteColor()
        feesLabel.textAlignment = .Right

        borderView.backgroundColor = UIColor(0x5f626d)
    }

}


