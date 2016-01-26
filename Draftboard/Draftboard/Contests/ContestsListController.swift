//
//  ContestsListController.swift
//  Draftboard
//
//  Created by Karl Weber on 9/21/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestsListController: DraftboardViewController{
    let normalContestCellReuseIdentifier = "normalContestCell"
    let liveContestCellReuseIdentifier = "liveContestCell"
    let normalContestHeaderReuseIdentifier = "normalHeaderCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lineupButton: DraftboardArrowButton!
    @IBOutlet weak var gametypeButton: DraftboardArrowButton!
    
//    let tempSections = [
//        "Live",
//        "Upcoming",
//        "Completed"
//    ]
    
    var contests = [Contest]()
    var entries = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .blueDarker()
        
        API.contestLobby().then { contests in
            self.gotContests(contests)
        }
        API.contestEntries().then { entries in
            self.gotEntries(entries)
        }
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let contestCellNib = UINib(nibName: "DraftboardContestsCell", bundle: bundle)
        let contestUpcomingCellNib = UINib(nibName: "DraftboardContestsUpcomingCell", bundle: bundle)
        let contestHeaderNib = UINib(nibName: "ContestsHeaderCell", bundle: bundle)
        
        tableView.registerNib(contestCellNib, forCellReuseIdentifier: liveContestCellReuseIdentifier)
        tableView.registerNib(contestUpcomingCellNib, forCellReuseIdentifier: normalContestCellReuseIdentifier)
        tableView.registerNib(contestHeaderNib, forHeaderFooterViewReuseIdentifier: normalContestHeaderReuseIdentifier)
        
        lineupButton.addTarget(self, action: Selector("lineupTap:"), forControlEvents: .TouchUpInside)
        gametypeButton.addTarget(self, action: Selector("gametypeTap:"), forControlEvents: .TouchUpInside)
        
        tableView.delegate = self
    }
    
    func lineupTap(button: DraftboardButton) {
        let choices = NSDictionary(dictionary: [
            "title": "Lineup A",
            "subtitle": "Basketball",
            "object": "Object"
        ])
        
        let mcc = DraftboardModalChoiceController(title: "Lineup Types", choices: [choices])
        RootViewController.sharedInstance.pushModalViewController(mcc)
    }
    
    func gametypeTap(button: DraftboardButton) {
        let choices = NSDictionary(dictionary: [
            "title": "Game Type A",
            "subtitle": "14 Games",
            "object": "Object"
        ])
        
        let mcc = DraftboardModalChoiceController(title: "Game Types", choices: [choices])
        RootViewController.sharedInstance.pushModalViewController(mcc)
    }
    
    override func didSelectModalChoice(index: Int) {
        // TODO: actually sort
        RootViewController.sharedInstance.popModalViewController()
    }
    
    override func didCancelModal() {
        RootViewController.sharedInstance.popModalViewController()
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if(buttonType == .Menu) {
            let gfvc = GlobalFilterViewController(nibName: "GlobalFilterViewController", bundle: nil)
            RootViewController.sharedInstance.pushModalViewController(gfvc)
        }
    }
    
    override func titlebarTitle() -> String? {
        return "All Contests".uppercaseString
    }
    
    override func titlebarAttributedTitle() -> NSMutableAttributedString? {
        let attrStr = super.titlebarAttributedTitle()
        attrStr?.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenDraftboard(), range: NSMakeRange(0, 3))
        return attrStr
    }
}

// MARK: - Data
extension ContestsListController {
    func gotContests(contests: [Contest]) {
        self.contests = contests
        self.tableView.reloadData()
    }
    
    func gotEntries(entries: [NSDictionary]) {
        self.entries = entries.flatMap { $0["contest"] as? Int }
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate functions

extension ContestsListController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(normalContestCellReuseIdentifier, forIndexPath: indexPath) as! DraftboardContestsUpcomingCell
        let contest = self.contests[indexPath.row]
        let fee = Format.currency.stringFromNumber(contest.buyin)!
        let prizes = Format.currency.stringFromNumber(contest.prizePool)!
        let entered = self.entries.contains(contest.id)
        cell.titleLabel.text = contest.name
        cell.contestInfo.text = "\(fee) FEE / \(prizes) PRIZES"
        cell.iconImageView.tintColor = entered ? .whiteColor() : .whiteMediumOpacity()
        cell.topBorderView.hidden = (indexPath.row == 0)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(normalContestHeaderReuseIdentifier) as! ContestsHeaderCell
        header.titleLabel.textColor = .whiteMediumOpacity()
        header.titleLabel.text = "Upcoming".uppercaseString
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let contest = self.contests[indexPath.row]
        let entered = self.entries.contains(contest.id)
        let cdvc = ContestDetailViewController(nibName: "ContestDetailViewController", bundle: nil)
        cdvc.contest = contest
        cdvc.contestEntered = entered
        self.navController?.pushViewController(cdvc)
    }
}
