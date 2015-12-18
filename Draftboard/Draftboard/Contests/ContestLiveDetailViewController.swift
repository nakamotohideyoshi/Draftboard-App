//
//  ContestLiveDetailViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 11/9/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestLiveDetailViewController: DraftboardViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var feeLabel: DraftboardLabel!
    @IBOutlet weak var prizeLabel: DraftboardLabel!
    @IBOutlet weak var entryLabel: DraftboardLabel!
    @IBOutlet weak var avgPmrLabel: DraftboardLabel!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    var topViewHeightBase = CGFloat()
    
    let contestStandingCell = "contestStandingCell"
    let normalContestHeaderReuseIdentifier = "normalHeaderCell"
    
    let tableView = UITableView()
    
    var contestName: String?
    
    let tempStandings = [
        "Krisdude",
        "fonsychappa",
        "tslclick",
        "motionboy",
        "bobandthemarleys",
        "tomkruze",
        "LilTimmy",
        "BobbyTables",
        "Stevesteverson",
        "TomBombadil",
        "Krisdude",
        "fonsychappa",
        "tslclick",
        "motionboy",
        "bobandthemarleys",
        "tomkruze",
        "LilTimmy",
        "BobbyTables",
        "Stevesteverson",
        "TomBombadil",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clearColor()
        view.addSubview(tableView)
        
        tableView.topRancor.constraintEqualToRancor(view.topRancor, constant: 76.0).active = true
        tableView.trailingRancor.constraintEqualToRancor(view.trailingRancor).active = true
        tableView.leadingRancor.constraintEqualToRancor(view.leadingRancor).active = true
        tableView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        
        tableView.separatorColor = .dividerOnDarkColor()
        
        // Make those cells play nice with nibs
        let bundle = NSBundle(forClass: self.dynamicType)
        let contestStandingCellNib = UINib(nibName: "ContestPlayerStandingCell", bundle: bundle)
        tableView.registerNib(contestStandingCellNib, forCellReuseIdentifier: contestStandingCell)
        
        let contestHeaderNib = UINib(nibName: "ContestsHeaderCell", bundle: bundle)
        tableView.registerNib(contestHeaderNib,
            forHeaderFooterViewReuseIdentifier: normalContestHeaderReuseIdentifier)
        
        // offset the top of the tableview with a clear headerview
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.view.frame), height: topViewHeight.constant - 76.0))
        tableView.tableHeaderView = headerView
        
        topViewHeightBase = topViewHeight.constant
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Back) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String? {
        return contestName?.uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
}

// MARK: - uitableview delegate functions

extension ContestLiveDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempStandings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(contestStandingCell,
            forIndexPath: indexPath) as! ContestPlayerStandingCell
        cell.playerName.text = tempStandings[indexPath.row]
        if indexPath.row == 0 {
            cell.lineupPlace.text = "1st place"
        } else if indexPath.row == 1 {
            cell.lineupPlace.text = "2nd place"
        } else if indexPath.row == 2 {
            cell.lineupPlace.text = "3rd place"
        } else {
            cell.lineupPlace.text = String(format: "%ith place", indexPath.row + 1)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(normalContestHeaderReuseIdentifier) as! ContestsHeaderCell
        header.titleLabel.textColor = .whiteMediumOpacity()
        header.titleLabel.text = "Player Ranking".uppercaseString
        return header
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cdvc = ContestDetailViewController(nibName: "ContestDetailViewController", bundle: nil)
//        cdvc.contestName = "$100k Slam Dunk"
//        self.navController?.pushViewController(cdvc)
    }
}

// MARK: - uitableview scroll functions

extension ContestLiveDetailViewController {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let total = topViewHeight.constant - 76.0
        
        if scrollView.contentOffset.y < 0 {
            topViewHeight.constant = topViewHeightBase + abs(scrollView.contentOffset.y)
            topView.alpha = 1.0
        }
        else {
            topView.alpha = min(1 - (scrollView.contentOffset.y / total), 1)
        }
    }
}
