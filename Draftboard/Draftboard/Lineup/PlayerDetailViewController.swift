//
//  PlayerDetailViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/20/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

protocol PlayerDetailDraftButtonDelegate: class {
    func draftButtonTapped(indexPath: NSIndexPath)
}

class PlayerDetailViewController: DraftboardViewController {
    
    override var overlapsTabBar: Bool { return true }
    
    var playerDetailView: PlayerDetailView { return view as! PlayerDetailView }
    var tableView: PlayerDetailTableView { return playerDetailView.tableView }
    var headerView: PlayerDetailHeaderView { return playerDetailView.headerView }
    var panelView: PlayerDetailPanelView { return playerDetailView.panelView }
    var statsView: DraftboardView { return panelView.statsView }
    var backgroundView: UIView { return playerDetailView.backgroundView }
    var avatarView: UIImageView { return playerDetailView.avatarView }
    var avatarHaloView: UIImageView { return playerDetailView.avatarHaloView }
    var avatarLoaderView: LoaderView { return playerDetailView.avatarLoaderView }
    var nextGameLabel: DraftboardTextLabel { return playerDetailView.nextGameLabel }
    var teamNameLabel: DraftboardTextLabel { return playerDetailView.teamNameLabel }
    var posStatView: ModalStatView { return playerDetailView.posStatView }
    var salaryStatView: ModalStatView { return playerDetailView.salaryStatView }
    var fppgStatView: ModalStatView { return playerDetailView.fppgStatView }
    var draftButton: DraftboardTextButton { return playerDetailView.draftButton }
    var gameDetailView: PlayerGameDetailView { return playerDetailView.gameDetailView }
    var segmentedControl: DraftboardSegmentedControl { return playerDetailView.segmentedControl }
    var showAddButton: Bool = false { didSet { didSetShowAddButton() } }
    var showRemoveButton: Bool = false { didSet { didSetShowRemoveButton() } }
    
    var sportName: String?
    var player: Player?
    var reports: [Report]?
    var gameLogs: NSArray?
    var indexPath: NSIndexPath?
    weak var draftButtonDelegate: PlayerDetailDraftButtonDelegate?
    
    override func loadView() {
        view = PlayerDetailView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        
        setPlayerImage()
        setGameText()
        setStatValues()
        
        nextGameLabel.hidden = true
        
        draftButton.label.text = "Draft Player".uppercaseString
        
        segmentedControl.choices = ["Updates", "Game Log"]
        segmentedControl.indexChangedHandler = { [weak self] (_: Int) in self?.filter() }
        
        draftButton.addTarget(self, action: #selector(draftButtonTapped), forControlEvents: .TouchUpInside)
        
        setGameStatValues(statData: player?.stat)
        Realtime.onPlayerRawStat(for: sportName!) { stat in
            let srid: String = try! stat.get("srid_player")
            if srid == self.player?.srid {
                self.setGameStatValues(statData: stat)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        player?.getPlayerReports().then { reports -> Void in
            self.reports = reports
            self.tableView.reloadData()
        }
        player?.getPlayerGameLog(sportName: sportName!).then { gameLogs -> Void in
            self.gameLogs = gameLogs
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.contentOffset = CGPointMake(0, -tableView.contentInset.top)
        player?.getPlayerStatus(sportName: sportName!).then { status in
            self.navController?.titlebar.setSubtitle(status, color: .redDraftboard())
        }
    }
    
    func filter() {
        let contentOffsetY = tableView.contentOffset.y
        tableView.reloadData()
        tableView.contentOffset.y = contentOffsetY
        tableView.flashScrollIndicators()
        if tableView.indexPathsForVisibleRows?.last != nil {
            let last = tableView.indexPathsForVisibleRows!.last!
            tableView.scrollToRowAtIndexPath(last, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        } else {
            tableView.setContentOffset(CGPointMake(0, -tableView.contentInset.top), animated: false)
        }
    }
    
    func setPlayerImage() {
        guard let srid = player?.srid, sportName = sportName else { return }
        
        let cachesDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        let cachedImageDir = "\(cachesDir)/384/"
        let cachedImagePath = "\(cachedImageDir)/\(srid).png"
        let netImageBaseURL = "https://static-players.draftboard.com"
        let netImageURL = "\(netImageBaseURL)/\(sportName)/384/\(srid).png"
        let defaultImageName = "PlayerPhotos/player-default-256"
        
        _ = try? NSFileManager.defaultManager().createDirectoryAtPath(cachedImageDir, withIntermediateDirectories: true, attributes: nil)
        
        avatarView.layer.opacity = 0
        avatarHaloView.layer.opacity = 0
        avatarLoaderView.hidden = false

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var data = NSData(contentsOfFile: cachedImagePath)
            if data == nil {
                data = NSData(contentsOfURL: NSURL(string: netImageURL)!)
                data?.writeToFile(cachedImagePath, atomically: true)
            }
            var image = UIImage(data: data ?? NSData())
            if image == nil {
                image = UIImage(named: defaultImageName)?.imageWithRenderingMode(.AlwaysTemplate)
                self.avatarView.tintColor = .blueDark()
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.avatarView.image = image
                self.avatarHaloView.layer.transform = CATransform3DMakeRotation(-0.5, 0, 0, 1)
                self.avatarLoaderView.hidden = true
                UIView.animateWithDuration(0.5) {
                    self.avatarView.layer.opacity = 1
                }
                UIView.animateWithDuration(1.5, delay: 0, options: .CurveEaseOut, animations: {
                    self.avatarHaloView.layer.opacity = 1
                    self.avatarHaloView.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })
        }
    }
    
    func setGameText() {
        guard let player = player, game = (player as? PlayerWithPositionAndGame)?.game, team = (player as? PlayerWithPositionAndGame)?.team else { return }
        
        let df = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let startsToday = calendar.isDateInToday(game.start)
        let startsTomorrow = calendar.isDateInTomorrow(game.start)
        
        let teamsText = "\(game.away.alias) @ \(game.home.alias)"
        
        df.dateFormat = "h:mm a"
        let timeText = df.stringFromDate(game.start)
        
        df.dateFormat = "eeee"
        let dayText = (startsToday || startsTomorrow) ?
            (startsToday ? "Today" : "Tomorrow") :
            (df.stringFromDate(game.start))
        
        let nextGameText = "\(teamsText) — \(timeText) \(dayText)"
        nextGameLabel.text = nextGameText.uppercaseString
        
        // Make player team white
        let teamString = "\\b\(player.teamAlias)\\b"
        let teamColor = UIColor.whiteColor()
        let teamRange = (nextGameText as NSString).rangeOfString(teamString, options: .RegularExpressionSearch)
        let nextGameAttributedText = NSMutableAttributedString(attributedString: nextGameLabel.attributedText!)
        nextGameAttributedText.addAttribute(NSForegroundColorAttributeName, value: teamColor, range: teamRange)
        nextGameLabel.attributedText = nextGameAttributedText
        
        teamNameLabel.text = team.city.uppercaseString + " " + team.name.uppercaseString
        
        gameDetailView.sportName = sportName
        gameDetailView.game = game
    }
    
    func setStatValues() {
        guard let player = player, position = (player as? PlayerWithPosition)?.position else { return }

        posStatView.valueLabel.text = position.uppercaseString
        salaryStatView.valueLabel.text = Format.currency.stringFromNumber(player.salary)
        fppgStatView.valueLabel.text = String(format: "%.1f", player.fppg)
    }
    
    func setGameStatValues(statData data: NSDictionary? = nil) {
        guard let player = player, position = (player as? PlayerWithPosition)?.position else { return }
        statsView.subviews.forEach { $0.removeFromSuperview() }
        if (sportName == "nfl") {
            if (position == "QB") {
                var startX = CGFloat(20)
                var labels = ["pass yd", "pass td", "int", "rush yd", "rush td"]
                var values: [Int] = []
                if (data == nil) {
                    values.append(0)
                } else {
                    let pass_yds: Int = try! data!.get("pass_yds")
                    values.append(pass_yds)
                }
                if (data == nil) {
                    values.append(0)
                } else {
                    let pass_td: Int = try! data!.get("pass_td")
                    values.append(pass_td)
                }
                if (data == nil) {
                    values.append(0)
                } else {
                    let ints: Int = try! data!.get("ints")
                    values.append(ints)
                }
                if (data == nil) {
                    values.append(0)
                } else {
                    let rush_yds: Int = try! data!.get("rush_yds")
                    values.append(rush_yds)
                }
                if (data == nil) {
                    values.append(0)
                } else {
                    let rush_td: Int = try! data!.get("rush_td")
                    let off_fum_rec_td: Int = try! data!.get("off_fum_rec_td")
                    values.append(rush_td + off_fum_rec_td)
                }
                if (data != nil) {
                    let rec_rec: Int = try! data!.get("rec_rec")
                    if rec_rec != 0 {
                        labels.append("rec")
                        values.append(rec_rec)
                    }
                    let rec_yds: Int = try! data!.get("rec_yds")
                    if rec_yds != 0 {
                        labels.append("rec yd")
                        values.append(rec_yds)
                    }
                    let rec_td: Int = try! data!.get("rec_td")
                    if rec_td != 0 {
                        labels.append("rec td")
                        values.append(rec_td)
                    }
                    let ret_punt_td: Int = try! data!.get("ret_punt_td")
                    let ret_kick_td: Int = try! data!.get("ret_kick_td")
                    let ret_td = ret_punt_td + ret_kick_td
                    if ret_td != 0 {
                        labels.append("ret td")
                        values.append(ret_td)
                    }
                    let two_pt_conv: Int = try! data!.get("two_pt_conv")
                    if two_pt_conv != 0 {
                        labels.append("2pc")
                        values.append(two_pt_conv)
                    }
                    let off_fum_lost: Int = try! data!.get("off_fum_lost")
                    if off_fum_lost != 0 {
                        labels.append("fum")
                        values.append(off_fum_lost)
                    }
                }
                var index = 0
                labels.forEach { label in
                    let fieldLabel = DraftboardLabel()
                    fieldLabel.font = .openSans(weight: .Semibold, size: 8)
                    fieldLabel.textColor = UIColor(0x9c9faf)
                    fieldLabel.textAlignment = .Center
                    fieldLabel.text = label.uppercaseString
                    fieldLabel.frame = CGRectMake(startX, 20, 40, 10)
                    statsView.addSubview(fieldLabel)
                    
                    let valueLabel = DraftboardLabel()
                    valueLabel.font = .oswald(size: 18)
                    valueLabel.textColor = .whiteColor()
                    valueLabel.textAlignment = .Center
                    valueLabel.text = Format.points.stringFromNumber(values[index])
                    valueLabel.frame = CGRectMake(startX, 35, 40, 20)
                    statsView.addSubview(valueLabel)
                    
                    startX += 50
                    index += 1
                }
            } else if (position == "RB") {
                var startX = CGFloat(20)
                var labels = ["rush yd", "rush td", "rec", "rec yd", "rec td"]
                var values: [Int] = []
                if (data == nil) {
                    values.append(0)
                } else {
                    let rush_yds: Int = try! data!.get("rush_yds")
                    values.append(rush_yds)
                }
                if (data == nil) {
                    values.append(0)
                } else {
                    let rush_td: Int = try! data!.get("rush_td")
                    let off_fum_rec_td: Int = try! data!.get("off_fum_rec_td")
                    values.append(rush_td + off_fum_rec_td)
                }
                if (data == nil) {
                    values.append(0)
                } else {
                    let rec_rec: Int = try! data!.get("rec_rec")
                    values.append(rec_rec)
                }
                if (data == nil) {
                    values.append(0)
                } else {
                    let rec_yds: Int = try! data!.get("rec_yds")
                    values.append(rec_yds)
                }
                if (data == nil) {
                    values.append(0)
                } else {
                    let rec_td: Int = try! data!.get("rec_td")
                    values.append(rec_td)
                }
                if (data != nil) {
                    let ret_punt_td: Int = try! data!.get("ret_punt_td")
                    let ret_kick_td: Int = try! data!.get("ret_kick_td")
                    let ret_td = ret_punt_td + ret_kick_td
                    if ret_td != 0 {
                        labels.append("ret td")
                        values.append(ret_td)
                    }
                    let off_fum_lost: Int = try! data!.get("off_fum_lost")
                    if off_fum_lost != 0 {
                        labels.append("fum")
                        values.append(off_fum_lost)
                    }
                    let pass_yds: Int = try! data!.get("pass_yds")
                    if pass_yds != 0 {
                        labels.append("pass yd")
                        values.append(pass_yds)
                    }
                    let pass_td: Int = try! data!.get("pass_td")
                    if pass_td != 0 {
                        labels.append("pass td")
                        values.append(pass_td)
                    }
                    let ints: Int = try! data!.get("ints")
                    if ints != 0 {
                        labels.append("int")
                        values.append(ints)
                    }
                    
                    let two_pt_conv: Int = try! data!.get("two_pt_conv")
                    if two_pt_conv != 0 {
                        labels.append("2pc")
                        values.append(two_pt_conv)
                    }
                    
                }
                var index = 0
                labels.forEach { label in
                    let fieldLabel = DraftboardLabel()
                    fieldLabel.font = .openSans(weight: .Semibold, size: 8)
                    fieldLabel.textColor = UIColor(0x9c9faf)
                    fieldLabel.textAlignment = .Center
                    fieldLabel.text = label.uppercaseString
                    fieldLabel.frame = CGRectMake(startX, 20, 40, 10)
                    statsView.addSubview(fieldLabel)
                    
                    let valueLabel = DraftboardLabel()
                    valueLabel.font = .oswald(size: 18)
                    valueLabel.textColor = .whiteColor()
                    valueLabel.textAlignment = .Center
                    valueLabel.text = Format.points.stringFromNumber(values[index])
                    valueLabel.frame = CGRectMake(startX, 35, 40, 20)
                    statsView.addSubview(valueLabel)
                    
                    startX += 50
                    index += 1
                }
            } else {
                var startX = CGFloat(20)
                var labels = ["rec", "rec yd", "rec td"]
                var values: [Int] = []
                if (data == nil) {
                    values.append(0)
                } else {
                    let rec_rec: Int = try! data!.get("rec_rec")
                    values.append(rec_rec)
                }
                if (data == nil) {
                    values.append(0)
                } else {
                    let rec_yds: Int = try! data!.get("rec_yds")
                    values.append(rec_yds)
                }
                if (data == nil) {
                    values.append(0)
                } else {
                    let rec_td: Int = try! data!.get("rec_td")
                    values.append(rec_td)
                }
                if (data != nil) {
                    let rush_yds: Int = try! data!.get("rush_yds")
                    if rush_yds != 0 {
                        labels.append("rush yd")
                        values.append(rush_yds)
                    }
                    var rush_td: Int = try! data!.get("rush_td")
                    let off_fum_rec_td: Int = try! data!.get("off_fum_rec_td")
                    rush_td += off_fum_rec_td
                    if rush_td != 0 {
                        labels.append("rush td")
                        values.append(rush_td)
                    }
                    let ret_punt_td: Int = try! data!.get("ret_punt_td")
                    let ret_kick_td: Int = try! data!.get("ret_kick_td")
                    let ret_td = ret_punt_td + ret_kick_td
                    if ret_td != 0 {
                        labels.append("ret td")
                        values.append(ret_td)
                    }
                    let pass_yds: Int = try! data!.get("pass_yds")
                    if pass_yds != 0 {
                        labels.append("pass yd")
                        values.append(pass_yds)
                    }
                    let pass_td: Int = try! data!.get("pass_td")
                    if pass_td != 0 {
                        labels.append("pass td")
                        values.append(pass_td)
                    }
                    let ints: Int = try! data!.get("ints")
                    if ints != 0 {
                        labels.append("int")
                        values.append(ints)
                    }
                    
                    let two_pt_conv: Int = try! data!.get("two_pt_conv")
                    if two_pt_conv != 0 {
                        labels.append("2pc")
                        values.append(two_pt_conv)
                    }
                    let off_fum_lost: Int = try! data!.get("off_fum_lost")
                    if off_fum_lost != 0 {
                        labels.append("fum")
                        values.append(off_fum_lost)
                    }
                }
                var index = 0
                labels.forEach { label in
                    let fieldLabel = DraftboardLabel()
                    fieldLabel.font = .openSans(weight: .Semibold, size: 8)
                    fieldLabel.textColor = UIColor(0x9c9faf)
                    fieldLabel.textAlignment = .Center
                    fieldLabel.text = label.uppercaseString
                    fieldLabel.frame = CGRectMake(startX, 20, 40, 10)
                    statsView.addSubview(fieldLabel)
                    
                    let valueLabel = DraftboardLabel()
                    valueLabel.font = .oswald(size: 18)
                    valueLabel.textColor = .whiteColor()
                    valueLabel.textAlignment = .Center
                    valueLabel.text = Format.points.stringFromNumber(values[index])
                    valueLabel.frame = CGRectMake(startX, 35, 40, 20)
                    statsView.addSubview(valueLabel)
                    
                    startX += 50
                    index += 1
                }
            }
        }
    }
    
    func didSetShowAddButton() {
        if showAddButton { showRemoveButton = false }
        draftButton.backgroundColor = .greenDraftboard()
        draftButton.layer.borderColor = UIColor.greenDraftboard().CGColor
        draftButton.label.text = "Draft Player".uppercaseString
        draftButton.hidden = !(showAddButton || showRemoveButton)
        statsView.hidden = showAddButton || showRemoveButton
    }
    
    func didSetShowRemoveButton() {
        if showRemoveButton { showAddButton = false }
        draftButton.backgroundColor = .redDraftboard()
        draftButton.layer.borderColor = UIColor.redDraftboard().CGColor
        draftButton.label.text = "Drop Player".uppercaseString
        draftButton.hidden = !(showAddButton || showRemoveButton)
        statsView.hidden = showAddButton || showRemoveButton
    }
    
    func draftButtonTapped() {
        draftButtonDelegate?.draftButtonTapped(indexPath!)
    }
    // Titlebar
    
    override func titlebarTitle() -> String? {
        return player?.name.uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if buttonType == .Back {
            navController?.popViewController()
        }
    }
    
}

// MARK: -

private typealias TableViewDelegate = PlayerDetailViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.currentIndex == 0 {
            return reports?.count ?? 0
        } else {
            if gameLogs == nil {
                return 0
            } else {
                return gameLogs!.count + 1
            }
        }
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if segmentedControl.currentIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(PlayerReportCell), forIndexPath: indexPath) as! PlayerReportCell
            let report = reports![indexPath.row]
            cell.timeLabel.text = report.dayAgo
            cell.titleLabel1.text = report.headline
            cell.contentLabel1.text = report.notes
            cell.titleLabel2.text = "Analysis"
            cell.contentLabel2.text = report.analysis
            return cell
        } else {
            if sportName == "mlb" {
                let position = (player as? PlayerWithPositionAndGame)?.position
                if position == "SP" {
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCellWithIdentifier(String(MLBPitcherGameLogHeaderCell), forIndexPath: indexPath)
                        
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCellWithIdentifier(String(MLBPitcherGameLogCell), forIndexPath: indexPath) as! MLBPitcherGameLogCell
                        let gameLog: MLBPitcherGameLog = gameLogs![indexPath.row - 1] as! MLBPitcherGameLog
                        
                        cell.dateLabel.text = gameLog.date
                        cell.oppLabel.text = gameLog.opp
                        cell.resultLabel.text = ""
                        cell.ipLabel.text = NSString(format:"%d", gameLog.ip) as String
                        cell.hLabel.text = NSString(format:"%d", gameLog.h) as String
                        cell.erLabel.text = NSString(format:"%d", gameLog.er) as String
                        cell.bbLabel.text = NSString(format:"%d", gameLog.bb) as String
                        cell.soLabel.text = NSString(format:"%d", gameLog.so) as String
                        cell.fpLabel.text = NSString(format:"%.2f", gameLog.fp) as String
                        
                        return cell
                    }
                } else {
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCellWithIdentifier(String(MLBHitterGameLogHeaderCell), forIndexPath: indexPath)
                        
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCellWithIdentifier(String(MLBHitterGameLogCell), forIndexPath: indexPath) as! MLBHitterGameLogCell
                        let gameLog: MLBHitterGameLog = gameLogs![indexPath.row - 1] as! MLBHitterGameLog
                        
                        cell.dateLabel.text = gameLog.date
                        cell.oppLabel.text = gameLog.opp
                        cell.abLabel.text = ""
                        cell.rLabel.text = NSString(format:"%d", gameLog.r) as String
                        cell.hLabel.text = NSString(format:"%d", gameLog.h) as String
                        cell.doublesLabel.text = NSString(format:"%d", gameLog.doubles) as String
                        cell.triplesLabel.text = NSString(format:"%d", gameLog.triples) as String
                        cell.hrLabel.text = NSString(format:"%d", gameLog.hr) as String
                        cell.rbiLabel.text = NSString(format:"%d", gameLog.rbi) as String
                        cell.bbLabel.text = NSString(format:"%d", gameLog.bb) as String
                        cell.sbLabel.text = NSString(format:"%d", gameLog.sb) as String
                        cell.fpLabel.text = NSString(format:"%.2f", gameLog.fp) as String
                        
                        return cell
                    }
                }
                
            } else if sportName == "nfl" {
                let position = (player as? PlayerWithPositionAndGame)?.position
                
                if position == "QB" {
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCellWithIdentifier(String(NFLQBGameLogHeaderCell), forIndexPath: indexPath)
                        
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCellWithIdentifier(String(NFLQBGameLogCell), forIndexPath: indexPath) as! NFLQBGameLogCell
                        let gameLog: NFLQBGameLog = gameLogs![indexPath.row - 1] as! NFLQBGameLog
                        
                        cell.dateLabel.text = gameLog.date
                        cell.oppLabel.text = gameLog.opp
                        cell.passYdsLabel.text = NSString(format:"%d", gameLog.pass_yds) as String
                        cell.passTdLabel.text = NSString(format:"%d", gameLog.pass_td) as String
                        cell.passIntLabel.text = NSString(format:"%d", gameLog.pass_int) as String
                        cell.rushYdsLabel.text = NSString(format:"%d", gameLog.rush_yds) as String
                        cell.rushTdLabel.text = NSString(format:"%d", gameLog.rush_td) as String
                        cell.fpLabel.text = NSString(format:"%.2f", gameLog.fp) as String
                        
                        return cell
                    }
                } else if position == "RB" {
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCellWithIdentifier(String(NFLRBGameLogHeaderCell), forIndexPath: indexPath)
                        
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCellWithIdentifier(String(NFLRBGameLogCell), forIndexPath: indexPath) as! NFLRBGameLogCell
                        let gameLog: NFLRBGameLog = gameLogs![indexPath.row - 1] as! NFLRBGameLog
                        
                        cell.dateLabel.text = gameLog.date
                        cell.oppLabel.text = gameLog.opp
                        cell.rushYdsLabel.text = NSString(format:"%d", gameLog.rush_yds) as String
                        cell.rushTdLabel.text = NSString(format:"%d", gameLog.rush_td) as String
                        cell.recRecLabel.text = NSString(format:"%d", gameLog.rec_rec) as String
                        cell.recYdsLabel.text = NSString(format:"%d", gameLog.rec_yds) as String
                        cell.recTdLabel.text = NSString(format:"%d", gameLog.rec_td) as String
                        cell.fpLabel.text = NSString(format:"%.2f", gameLog.fp) as String
                        
                        return cell
                    }
                } else {
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCellWithIdentifier(String(NFLGameLogHeaderCell), forIndexPath: indexPath)
                        
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCellWithIdentifier(String(NFLGameLogCell), forIndexPath: indexPath) as! NFLGameLogCell
                        let gameLog: NFLGameLog = gameLogs![indexPath.row - 1] as! NFLGameLog
                        
                        cell.dateLabel.text = gameLog.date
                        cell.oppLabel.text = gameLog.opp
                        cell.recRecLabel.text = NSString(format:"%d", gameLog.rec_rec) as String
                        cell.recYdsLabel.text = NSString(format:"%d", gameLog.rec_yds) as String
                        cell.recTdLabel.text = NSString(format:"%d", gameLog.rec_td) as String
                        cell.fpLabel.text = NSString(format:"%.2f", gameLog.fp) as String
                        
                        return cell
                    }
                }
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(PlayerDetailTableViewCell), forIndexPath: indexPath)
                let subsectionName = segmentedControl.choices[segmentedControl.currentIndex]
                cell.textLabel?.text = "\(subsectionName) Row \(indexPath.row + 1)"
                return cell
            }
            
        }
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

extension PlayerDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_: UIScrollView) {
        let headerViewH = headerView.frame.height
        let panelViewH = panelView.frame.height
        let contentOffsetY = tableView.contentOffset.y
        let contentInsetTop = tableView.contentInset.top
        
        let percentage = (contentOffsetY + contentInsetTop) / headerViewH
        let clampedPercentage = max(0, min(1, percentage))
        
        let indicatorInsetTop = max(76 + panelViewH, -contentOffsetY)
        let headerViewOpacity = 1 - clampedPercentage
        let headerViewTranslateY = (percentage > 0 ? 0.1 : 0.3) * percentage * headerViewH
        let panelViewTranslateY = (percentage < 1) ? 0 : contentOffsetY + contentInsetTop - headerViewH
        let backgroundViewTranslateY = (percentage < 0) ? contentInsetTop * -percentage * 0.8 : 0
        
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(indicatorInsetTop, 0, 0, 0)
        headerView.layer.opacity = Float(headerViewOpacity)
        headerView.layer.transform = CATransform3DMakeTranslation(0, headerViewTranslateY, 0)
        panelView.layer.transform = CATransform3DMakeTranslation(0, panelViewTranslateY, 0)
        backgroundView.layer.transform = CATransform3DMakeTranslation(0, backgroundViewTranslateY, 0)
        avatarView.layer.opacity = Float(headerViewOpacity)
    }
    
}
