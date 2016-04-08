//
//  ContestsListController.swift
//  Draftboard
//
//  Created by Karl Weber on 9/21/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestsListController: DraftboardViewController {
    
    let normalContestCellReuseIdentifier = "normalContestCell"
    let liveContestCellReuseIdentifier = "liveContestCell"
    let normalContestHeaderReuseIdentifier = "normalHeaderCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lineupButton: DraftboardArrowButton!
    @IBOutlet weak var gametypeButton: DraftboardArrowButton!
    
    var loaderView: LoaderView!
    
//    let tempSections = [
//        "Live",
//        "Upcoming",
//        "Completed"
//    ]
    
    var lineups: [Lineup]?
    var startTimes: [NSDate]?
    var contests: [NSDate: [Contest]]?
//    var entries = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .blueDarker()
        tableView.indicatorStyle = .White
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let contestCellNib = UINib(nibName: "DraftboardContestsCell", bundle: bundle)
        let contestUpcomingCellNib = UINib(nibName: "DraftboardContestsUpcomingCell", bundle: bundle)
        let contestHeaderNib = UINib(nibName: "ContestsHeaderCell", bundle: bundle)
        
        tableView.registerNib(contestCellNib, forCellReuseIdentifier: liveContestCellReuseIdentifier)
        tableView.registerNib(contestUpcomingCellNib, forCellReuseIdentifier: normalContestCellReuseIdentifier)
        tableView.registerNib(contestHeaderNib, forHeaderFooterViewReuseIdentifier: normalContestHeaderReuseIdentifier)
        tableView.delegate = self
        
        // Create loader view
        loaderView = LoaderView(frame: CGRectZero)
        loaderView.thickness = 2.0
        loaderView.spinning = true
        
        view.addSubview(loaderView)
        constrainLoaderView()
        
        lineupButton.addTarget(self, action: .lineupTap, forControlEvents: .TouchUpInside)
        gametypeButton.addTarget(self, action: .gametypeTap, forControlEvents: .TouchUpInside)
        
        showLoader()
    }
    
    override func viewWillAppear(animated: Bool) {
        API.lineupUpcoming().then { lineups in
            self.gotLineups(lineups)
        }
        API.contestLobby().then { contests in
            self.gotContests(contests)
        }
//        API.contestEntries().then { entries in
//            self.gotEntries(entries)
//        }
    }
    
    func showLoader() {
        loaderView.hidden = false
        tableView.hidden = true
        lineupButton.hidden = true
        gametypeButton.hidden = true
    }
    
    func hideLoader() {
        loaderView.hidden = true
        tableView.hidden = false
        lineupButton.hidden = false
        gametypeButton.hidden = false
    }
    
    func constrainLoaderView() {
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.widthRancor.constraintEqualToConstant(42.0).active = true
        loaderView.heightRancor.constraintEqualToConstant(42.0).active = true
        loaderView.centerYRancor.constraintEqualToRancor(view.centerYRancor).active = true
        loaderView.centerXRancor.constraintEqualToRancor(view.centerXRancor).active = true
    }
    
    func lineupTap(button: DraftboardButton) {
        let noFilterChoice = [
            "title": "Show All",
            "subtitle": "? Contests"
        ]
        let mcc = DraftboardModalChoiceController(title: "Filter by Lineup Eligibility", choices: nil)
        if self.lineups?.count > 0 {
            var choices = self.lineups?.map { ["title": $0.name, "subtitle": "In ? Contests", "object": $0] }
            choices?.insert(noFilterChoice, atIndex: 0)
            mcc.choiceData = choices
        }
        else {
            API.lineupUpcoming().then { lineups -> Void in
                self.lineups = lineups
                var choices = self.lineups?.map { ["title": $0.name, "subtitle": "In ? Contests", "object": $0] }
                choices?.insert(noFilterChoice, atIndex: 0)
                mcc.choiceData = choices
            }
        }
        
        RootViewController.sharedInstance.pushModalViewController(mcc)
    }
    
    func gametypeTap(button: DraftboardButton) {
        let choices = [
            [
                "title": "Show All",
                "subtitle": "? Contests"
            ],
            [
                "title": "Guaranteed Prize Pool",
                "subtitle": "? Contests"
            ],
            [
                "title": "Head-To-Head",
                "subtitle": "? Contests"
            ]
        ]
    
        let mcc = DraftboardModalChoiceController(title: "Filter by Contest Type", choices: choices)
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
    func gotLineups(lineups: [Lineup]) {
        self.lineups = lineups
    }
    
    func gotContests(contests: [Contest]) {
        self.contests = contests.reduce([:]) { (var dict, contest) -> [NSDate: [Contest]] in
            if dict[contest.start] == nil {
                dict[contest.start] = [Contest]()
            }
            dict[contest.start]?.append(contest)
            dict[contest.start]?.sortInPlace { a, b in
                if a.gpp != b.gpp { return a.gpp }
                if a.buyin != b.buyin { return a.buyin > b.buyin }
                if a.prizePool != b.prizePool { return a.prizePool > b.prizePool }
                return a.name < b.name
            }
            return dict
        }
        self.startTimes = self.contests?.keys.sort { date1, date2 in
            return date1.earlierDate(date2) == date1
        }
        self.tableView.reloadData()
        self.hideLoader()
    }
    
//    func gotEntries(entries: [NSDictionary]) {
//        self.entries = entries.flatMap { $0["contest"] as? Int }
//        self.tableView.reloadData()
//    }
}

// MARK: - UITableViewDelegate functions

extension ContestsListController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let startTimes = self.startTimes
        else { return 0 }
        
        return startTimes.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let start = self.startTimes?[section],
            contests = self.contests?[start]
        else { return 0 }
        
        return contests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(normalContestCellReuseIdentifier, forIndexPath: indexPath) as! DraftboardContestsUpcomingCell

        guard let start = self.startTimes?[indexPath.section],
            contests = self.contests?[start]
        else { return cell }
        
        let contest = contests[indexPath.row]
        let fee = Format.currency.stringFromNumber(contest.buyin)!
        let prizes = Format.currency.stringFromNumber(contest.prizePool)!
//        let entered = self.entries.contains(contest.id)
        cell.titleLabel.text = contest.name
        cell.contestFee.text = "\(fee)"
        cell.contestPrizes.text = "\(prizes)"
        cell.iconImageView.tintColor = .whiteLowOpacity()
//        cell.iconImageView.tintColor = entered ? .whiteColor() : .whiteMediumOpacity()
        cell.guaranteedImageView.hidden = !contest.gpp
        cell.topBorderView.hidden = (indexPath.row == 0)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(normalContestHeaderReuseIdentifier) as! ContestsHeaderCell
        
        guard let start = self.startTimes?[section]
        else { return header }

        header.countdownView.date = start
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let start = self.startTimes?[indexPath.section],
            contests = self.contests?[start]
        else { return }

        let contest = contests[indexPath.row]
//        let entered = self.entries.contains(contest.id)
        let cdvc = ContestDetailViewController(nibName: "ContestDetailViewController", bundle: nil)
        cdvc.contest = contest
//        cdvc.contestEntered = entered
        self.navController?.pushViewController(cdvc)
    }
}

private extension Selector {
    static let lineupTap = #selector(ContestsListController.lineupTap(_:))
    static let gametypeTap = #selector(ContestsListController.gametypeTap(_:))
}