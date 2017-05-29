//
//  ContestDetailViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/5/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

protocol EnterButtonDelegate: class {
    func tappedEnterButton(contest contest:Contest, completionHandler: ((Bool)->Void))
}
class ContestDetailViewController: DraftboardViewController {
    
    override var overlapsTabBar: Bool { return true }
    
    var contestDetailView: ContestDetailView { return view as! ContestDetailView }
    var tableView: ContestDetailTableView { return contestDetailView.tableView }
    var headerView: ContestDetailHeaderView { return contestDetailView.headerView }
    var panelView: ContestDetailPanelView { return contestDetailView.panelView }
    var countdownView: CountdownView { return contestDetailView.countdownView }
    var prizeStatView: ModalStatView { return contestDetailView.prizeStatView }
    var entrantsStatView: ModalStatView { return contestDetailView.entrantsStatView }
    var feeStatView: ModalStatView { return contestDetailView.feeStatView }
    var enterButton: DraftboardTextButton { return contestDetailView.enterButton }
    var entryCountLabel: UILabel { return contestDetailView.entryCountLabel }
    var segmentedControl: DraftboardSegmentedControl { return contestDetailView.segmentedControl }
    
    var contest: Contest?
    var games: [Game]?
    var users: [String]?
    var myEntries: [ContestPoolEntry]? { return (contest as? HasEntries)?.entries ?? [] }
    var scoring: NSDictionary?
    var delegate: EnterButtonDelegate?
    
    override func loadView() {
        view = ContestDetailView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        segmentedControl.indexChangedHandler = { [weak self] (_: Int) in self?.filter() }
        
        countdownView.date = contest?.start ?? NSDate()
        
        prizeStatView.valueLabel.text = Format.currency.stringFromNumber(contest?.prizePool ?? 0)
        entrantsStatView.valueLabel.text = "\(contest?.currentEntries ?? 0)"
        feeStatView.valueLabel.text = Format.currency.stringFromNumber(contest?.buyin ?? 0)
        
        enterButton.label.text = "Enter Contest".uppercaseString
        enterButton.addTarget(self, action: #selector(tappedEnterButton), forControlEvents: .TouchUpInside)
        
        entryCountLabel.text = NSString(format: "%d of %d Max Entries", (myEntries?.count)!, (contest?.maxEntries)!) as String

        segmentedControl.choices = ["My Entries", "Entries", "Prizes", "Games", "Scoring"]
        
        if let path = NSBundle.mainBundle().pathForResource("Scoring", ofType: "plist") {
            scoring = NSDictionary(contentsOfFile: path)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        when(DerivedData.games(sportName: contest!.sportName, draftGroupID: contest!.draftGroupID), contest!.registeredUsers()).then { games, users -> Void in
            self.games = games.sortBy { $0.start }
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.contentOffset = CGPointMake(0, -tableView.contentInset.top)
    }
    
    func filter() {
        let contentOffsetY = tableView.contentOffset.y
        tableView.reloadData()
        tableView.contentOffset.y = contentOffsetY
        tableView.flashScrollIndicators()
        if tableView.indexPathsForVisibleRows?.last != nil {
            let last = tableView.indexPathsForVisibleRows!.last!
            tableView.scrollToRowAtIndexPath(last, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }
    
    func tappedEnterButton() {
        enterButton.label.text = "Entering...".uppercaseString
        delegate?.tappedEnterButton(contest: contest!, completionHandler: { (finished) in
            if finished {
                self.updateData()
            }
            self.enterButton.label.text = "Enter Contest".uppercaseString
        })
    }
    
    // Titlebar
    
    override func titlebarTitle() -> String? {
        return contest?.name.uppercaseString
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
private typealias MyEntryDelegate = ContestDetailViewController
extension MyEntryDelegate: MyEntryCellDelegate {
    func updateData() {
        DerivedData.contestsWithEntries().then { contests -> Void in
            self.contest = contests.filter { $0.id == self.contest?.id }.last
            self.entryCountLabel.text = NSString(format: "%d of %d Max Entries", (self.myEntries?.count)!, (self.contest?.maxEntries)!) as String
            self.entrantsStatView.valueLabel.text = "\(self.contest?.currentEntries ?? 0)"
            self.tableView.reloadData()
        }
    }
}
// MARK: -

private typealias TableViewDelegate = ContestDetailViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if segmentedControl.currentIndex == 4 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.currentIndex == 0 {
            return ((myEntries?.count)! == 0) ? 0 : (myEntries?.count)! + 1
        } else if segmentedControl.currentIndex == 1 {
            return (users != nil) ? (users?.count)! : 0
        } else if segmentedControl.currentIndex == 2 {
            return (contest?.payoutSpots.count)!
        } else if segmentedControl.currentIndex == 3 {
            return (games != nil) ? (games?.count)! : 0
        } else if segmentedControl.currentIndex == 4 {
            let mlbScoring = scoring!["mlb"] as! NSDictionary
            let hittersScoring = mlbScoring["hitter"] as! NSArray
            let pitchersScoring = mlbScoring["pitcher"] as! NSArray
            if section == 0 {
                return hittersScoring.count + 1
            } else {
                return pitchersScoring.count + 1
            }
        } else {
            return 5 + segmentedControl.currentIndex * 5
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if segmentedControl.currentIndex == 0 {
            if indexPath.row == myEntries?.count {
                return 100
            } else {
                return 40
            }
        } else if segmentedControl.currentIndex == 4 {
            if indexPath.row == 0 {
                if indexPath.section == 0{
                    return 30
                } else {
                    return 50
                }
            } else {
                return 35
            }
        } else {
            return 40
        }
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if segmentedControl.currentIndex == 0 {
            if indexPath.row == myEntries?.count {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(ContestDetailGDescriptionCell), forIndexPath: indexPath) as! ContestDetailGDescriptionCell
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(ContestDetailMyEntryCell), forIndexPath: indexPath) as! ContestDetailMyEntryCell
                cell.entry = myEntries![indexPath.row]
                cell.delegate = self
                cell.guaranteed = indexPath.row == 0
                return cell
            }
        } else if segmentedControl.currentIndex == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ContestDetailEntryCell), forIndexPath: indexPath) as! ContestDetailEntryCell
            cell.usernameLabel.text = users![indexPath.row]
            
            return cell
        } else if segmentedControl.currentIndex == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ContestDetailPrizeCell), forIndexPath: indexPath) as! ContestDetailPrizeCell
            cell.payoutSpot = contest?.payoutSpots[indexPath.row]
            
            return cell
        } else if segmentedControl.currentIndex == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ContestDetailGameCell), forIndexPath: indexPath) as! ContestDetailGameCell
            cell.game = games![indexPath.row]
            
            return cell
        } else if segmentedControl.currentIndex == 4 {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier(String(ContestDetailScoringHeaderCell), forIndexPath: indexPath) as! ContestDetailScoringHeaderCell
                    cell.titleLabel.text = "Hitters".uppercaseString
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier(String(ContestDetailScoringCell), forIndexPath: indexPath) as! ContestDetailScoringCell
                    let mlbScoring = scoring!["mlb"] as! NSDictionary
                    let scores = mlbScoring["hitter"] as! NSArray
                    cell.score = scores[indexPath.row - 1] as? NSDictionary
                    
                    return cell
                }
            } else {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier(String(ContestDetailScoringHeaderCell), forIndexPath: indexPath) as! ContestDetailScoringHeaderCell
                    cell.titleLabel.text = "Pitchers".uppercaseString
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier(String(ContestDetailScoringCell), forIndexPath: indexPath) as! ContestDetailScoringCell
                    let mlbScoring = scoring!["mlb"] as! NSDictionary
                    let scores = mlbScoring["pitcher"] as! NSArray
                    cell.score = scores[indexPath.row - 1] as? NSDictionary
                    
                    return cell
                }
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ContestDetailTableViewCell), forIndexPath: indexPath)
            let subsectionName = segmentedControl.choices[segmentedControl.currentIndex]
            cell.textLabel?.text = "\(subsectionName) Row \(indexPath.row + 1)"
            
            return cell
        }
        
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

extension ContestDetailViewController: UIScrollViewDelegate {
    
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
        countdownView.layer.opacity = Float(headerViewOpacity)
    }
    
}
