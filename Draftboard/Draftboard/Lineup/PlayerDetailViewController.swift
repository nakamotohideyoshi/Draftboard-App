//
//  PlayerDetailViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/20/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class PlayerDetailViewController: DraftboardViewController {
    
    override var overlapsTabBar: Bool { return true }
    
    var playerDetailView: PlayerDetailView { return view as! PlayerDetailView }
    var tableView: PlayerDetailTableView { return playerDetailView.tableView }
    var headerView: PlayerDetailHeaderView { return playerDetailView.headerView }
    var panelView: PlayerDetailPanelView { return playerDetailView.panelView }
    var avatarView: UIImageView { return playerDetailView.avatarView }
    var avatarHaloView: UIImageView { return playerDetailView.avatarHaloView }
    var avatarLoaderView: LoaderView { return playerDetailView.avatarLoaderView }
    var nextGameLabel: DraftboardTextLabel { return playerDetailView.nextGameLabel }
    var posStatView: ModalStatView { return playerDetailView.posStatView }
    var salaryStatView: ModalStatView { return playerDetailView.salaryStatView }
    var fppgStatView: ModalStatView { return playerDetailView.fppgStatView }
    var draftButton: DraftboardTextButton { return playerDetailView.draftButton }
    var segmentedControl: DraftboardSegmentedControl { return playerDetailView.segmentedControl }
    
    var sportName: String?
    var player: Player?
    
    override func loadView() {
        view = PlayerDetailView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setPlayerImage()
        setGameText()
        setStatValues()
        
        draftButton.label.text = "Draft Player".uppercaseString
        
        segmentedControl.choices = ["Updates", "Game Log"]
        segmentedControl.indexChangedHandler = { [weak self] (_: Int) in self?.filter() }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.contentOffset = CGPointMake(0, -tableView.contentInset.top)
    }
    
    func filter() {
        let contentOffsetY = tableView.contentOffset.y
        tableView.reloadData()
        tableView.contentOffset.y = contentOffsetY
        tableView.flashScrollIndicators()
        let last = tableView.indexPathsForVisibleRows!.last!
        tableView.scrollToRowAtIndexPath(last, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    func setPlayerImage() {
        guard let srid = player?.srid, sportName = sportName else { return }
        
        let cachesDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        let cachedImageDir = "\(cachesDir)/384/"
        let cachedImagePath = "\(cachedImageDir)/\(srid).png"
        let netImageBaseURL = "https://static-players.draftboard.com"
        let netImageURL = "\(netImageBaseURL)/\(sportName)/384/\(srid).png"
        
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
            let image = UIImage(data: data ?? NSData())
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
        guard let game = (player as? PlayerWithPositionAndGame)?.game else { return }
        
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
    }
    
    func setStatValues() {
        guard let player = player, position = (player as? PlayerWithPosition)?.position else { return }

        posStatView.valueLabel.text = position.uppercaseString
        salaryStatView.valueLabel.text = Format.currency.stringFromNumber(player.salary)
        fppgStatView.valueLabel.text = String(format: "%.1f", player.fppg)
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
        return 10 + segmentedControl.currentIndex * 15
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(PlayerDetailTableViewCell), forIndexPath: indexPath)
        let subsectionName = segmentedControl.choices[segmentedControl.currentIndex]
        cell.textLabel?.text = "\(subsectionName) Row \(indexPath.row + 1)"
        
        return cell
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
        
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(indicatorInsetTop, 0, 0, 0)
        headerView.layer.opacity = Float(headerViewOpacity)
        headerView.layer.transform = CATransform3DMakeTranslation(0, headerViewTranslateY, 0)
        panelView.layer.transform = CATransform3DMakeTranslation(0, panelViewTranslateY, 0)
        avatarView.layer.opacity = Float(headerViewOpacity)
    }
    
}
