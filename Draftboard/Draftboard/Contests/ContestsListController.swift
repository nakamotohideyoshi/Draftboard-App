//
//  ContestsListController.swift
//  Draftboard
//
//  Created by Karl Weber on 9/21/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestsListController: DraftboardViewController, UITableViewDelegate, UITableViewDataSource {
    let normalContestCellReuseIdentifier = "normalContestCell"
    let liveContestCellReuseIdentifier = "liveContestCell"
    let normalContestHeaderReuseIdentifier = "normalHeaderCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lineupButton: DraftboardFilterButton!
    @IBOutlet weak var gametypeButton: DraftboardFilterButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    /*
        UITableViewDatasource
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
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
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cdvc = ContestDetailViewController(nibName: "ContestDetailViewController", bundle: nil)
        self.navController?.pushViewController(cdvc)
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
