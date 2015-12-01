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
    @IBOutlet weak var lineupButton: DraftboardFilterButton!
    @IBOutlet weak var gametypeButton: DraftboardFilterButton!
    
    let tempSections = [
        "Live",
        "Upcoming",
        "Completed"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .blueDarker()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let contestCellNib = UINib(nibName: "DraftboardContestsCell", bundle: bundle)
        let contestUpcomingCellNib = UINib(nibName: "DraftboardContestsUpcomingCell", bundle: bundle)
        let contestHeaderNib = UINib(nibName: "ContestsHeaderCell", bundle: bundle)
        
        tableView.registerNib(contestCellNib, forCellReuseIdentifier: liveContestCellReuseIdentifier)
        tableView.registerNib(contestUpcomingCellNib, forCellReuseIdentifier: normalContestCellReuseIdentifier)
        tableView.registerNib(contestHeaderNib, forHeaderFooterViewReuseIdentifier: normalContestHeaderReuseIdentifier)
        
        /*
        lineupButton.text = lineups[0].name
        let lineupTapGesture = UITapGestureRecognizer(target: self, action: "switchLineup:")
        lineupButton.addGestureRecognizer(lineupTapGesture)
        gametypeButton.text = GameType.Standard.rawValue
        let gameTypeTapGesture = UITapGestureRecognizer(target: self, action: "switchGameType:")
        gametypeButton.addGestureRecognizer(gameTypeTapGesture)
        */
        
        tableView.delegate = self
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

// MARK: - UITableViewDelegate functions

extension ContestsListController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tempSections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 12
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(liveContestCellReuseIdentifier, forIndexPath: indexPath) as! DraftboardContestsCell
            cell.topBorderView.hidden = (indexPath.row == 0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(normalContestCellReuseIdentifier, forIndexPath: indexPath) as! DraftboardContestsUpcomingCell
            cell.topBorderView.hidden = (indexPath.row == 0)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(normalContestHeaderReuseIdentifier) as! ContestsHeaderCell
        if section > 0 {
            header.titleLabel.textColor = .whiteMediumOpacity()
        } else {
            header.titleLabel.textColor = .whiteColor()
        }
        header.titleLabel.text = tempSections[section].uppercaseString
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // TODO: Actual logic for selecting section
        
        if indexPath.section == 0 {
            let cdvc = ContestLiveDetailViewController(nibName: "ContestLiveDetailViewController", bundle: nil)
            cdvc.contestName = "$100k Slam Dunk"
            self.navController?.pushViewController(cdvc)
        } else {
            let cdvc = ContestDetailViewController(nibName: "ContestDetailViewController", bundle: nil)
            cdvc.contestName = "$100k Slam Dunk"
            self.navController?.pushViewController(cdvc)
        }
        
    }
}
