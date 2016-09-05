//
//  ContestDetailViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 10/27/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailViewControllerOld: DraftboardViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewTop: NSLayoutConstraint!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var liveInLabel: CountdownView!
    @IBOutlet weak var startDateLabel: DraftboardLabel!
    @IBOutlet weak var feeLabel: DraftboardLabel!
    @IBOutlet weak var prizesLabel: DraftboardLabel!
    @IBOutlet weak var guaranteedImageView: UIImageView!
    @IBOutlet weak var entriesLabel: DraftboardLabel!
    @IBOutlet weak var prizesLabelConstraint: NSLayoutConstraint!
    
    var draftButton: DraftboardArrowButton!
    var draftButtonTop: NSLayoutConstraint!
    var draftButtonWidth: NSLayoutConstraint!
    var draftButtonHeight: NSLayoutConstraint!
    
    var segmentedControl: DraftboardSegmentedControl!
    var segmentedHeight: NSLayoutConstraint!
    var segmentedTop: NSLayoutConstraint!
    
    var topViewTopStart: CGFloat = 0.0
    var topViewHeightStart: CGFloat = 0.0
    var draftButtonTopStart: CGFloat = 0.0
    
    var stuck = true
    
    let detailCellIdentifier = "contest_detail_cell"
    
    var contest: Contest!
    var lineupChoice: Lineup?
    var eligibleLineups: [Lineup]?
    var contestEntered = false
    var lineupSelected: Int?
    var confirmationModal: ContestConfirmationModal?
    
    var tableData = [
        "payout": [NSDictionary](),
        "scoring": [NSDictionary](),
        "games": [NSDictionary](),
        "entries": [NSDictionary]()
    ]
    var tableDataKey = "payout"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve data
        /*
        API.prizeStructure(id: contest.prizeStructure).then { payout -> Void in
            self.tableData["payout"] = payout
            self.tableView.reloadData()
        }
     */
        
        // Create UI
        createSegmentedControl()
        createDraftButton()
        
        /*
        // Update start date
        let df = NSDateFormatter()
        df.dateFormat = "E, MMMM dd, h:mm a"
        let start = df.stringFromDate(contest.start)
        startDateLabel.text = start.uppercaseString
        
        // Update "live in" label
        liveInLabel.date = contest.start
        liveInLabel.size = 60.0
        liveInLabel.color = .whiteColor()
        
        // Set stats
        let fee = Format.currency.stringFromNumber(contest.buyin)
        let prizes = Format.currency.stringFromNumber(contest.prizePool)
        let entries = "\(contest.currentEntries) / \(contest.entries)"
        feeLabel.text = fee
        prizesLabel.text = prizes
        entriesLabel.text = entries
        if !contest.gpp {
            prizesLabelConstraint.constant = 0
            guaranteedImageView.hidden = true
        }
        
        // Full?
        if contest.currentEntries == contest.entries {
            disableContestEntry()
            draftButton.label.text = "Contest Full".uppercaseString
        }

        // Remove background colors from nibh
        topView.backgroundColor = .clearColor()
        tableView.backgroundColor = .clearColor()
        
        // Need these for scrollViewDidScroll
        topViewTopStart = topViewTop.constant
        topViewHeightStart = topViewHeight.constant
        draftButtonTopStart = draftButtonTop.constant
        
        // offset the top of the tableview with a clear headerview
        let headerView = UIView(frame: CGRectMake(0.0, 0.0, App.screenBounds.width, topViewHeight.constant - 76.0))
        tableView.tableHeaderView = headerView
        tableView.dataSource = self
        tableView.delegate = self
        
        // Add a white footer to the tableview
        let footerView = UIView(frame: CGRectMake(0.0, 0.0, App.screenBounds.width, 600.0))
        footerView.backgroundColor = .whiteColor()
        tableView.tableFooterView = footerView
        tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, -600.0, 0.0)
        
        // Register cell
        let bundle = NSBundle(forClass: self.dynamicType)
        let cellNib = UINib(nibName: "DraftboardDetailCell", bundle: bundle)
        tableView.registerNib(cellNib, forCellReuseIdentifier: detailCellIdentifier)
        
        if contestEntered {
            didEnterContest()
        } else {
            draftButton.addTarget(self, action: .handleButtonTap, forControlEvents: .TouchUpInside)
        }
     */
    }
    
    func createDraftButton() {
        draftButton = DraftboardArrowButton()
        draftButton.textBold = true
        draftButton.textValue = "ENTER CONTEST";
        
        tableView.addSubview(draftButton)
        draftButton.translatesAutoresizingMaskIntoConstraints = false
        draftButton.centerXRancor.constraintEqualToRancor(tableView.centerXRancor).active = true
        
        draftButtonHeight = draftButton.heightRancor.constraintEqualToConstant(50.0)
        draftButtonHeight.active = true
        
        draftButtonWidth = draftButton.widthRancor.constraintEqualToConstant(230.0)
        draftButtonWidth.active = true
        
        draftButtonTop = draftButton.topRancor.constraintEqualToRancor(tableView.topRancor, constant: topViewHeight.constant - 76.0 - 25.0)
        draftButtonTop.active = true
    }
    
    func createSegmentedControl() {
        segmentedControl = DraftboardSegmentedControl(
            choices: ["Payout", "Scoring", "Games", "Entries"],
            textColor: .blueDarker(),
            textSelectedColor: .greenDraftboard()
        )
        
        self.tableView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.leftRancor.constraintEqualToRancor(tableView.leftRancor, constant: 15.0).active = true
        segmentedControl.rightRancor.constraintEqualToRancor(tableView.rightRancor, constant: 15.0).active = true
        segmentedControl.centerXRancor.constraintEqualToRancor(tableView.centerXRancor).active = true
        
        segmentedHeight = segmentedControl.heightRancor.constraintEqualToConstant(97.0)
        segmentedHeight.active = true
        
        segmentedTop = segmentedControl.topRancor.constraintEqualToRancor(tableView.topRancor, constant: topViewHeight.constant - 76.0 + 25.0)
        segmentedTop.active = true
        
        segmentedControl.indexChangedHandler = { (index: Int) in
            // TODO: switch / reload data
            self.tableDataKey = ["payout", "scoring", "games", "entries"][index]
            self.tableView.reloadData()
        }
    }
    
    func handleButtonTap(sender: DraftboardButton) {
        /*
        API.lineupUpcoming().then { lineups -> Void in
            let eligible = lineups.filter { $0.draftGroup.id == self.contest.draftGroup.id }
            let choices = eligible.map {["title": $0.name, "subtitle": "In ? Contests"]}
            self.eligibleLineups = eligible
            let mcc = DraftboardModalChoiceController(title: "Choose an Eligible Lineup", choices: choices)
            RootViewController.sharedInstance.pushModalViewController(mcc)
        }
         */
    }
    
    override func didSelectModalChoice(index: Int) {
        guard let chosenLineup = self.eligibleLineups?[index] else { return }
        self.lineupChoice = chosenLineup
        confirmationModal = ContestConfirmationModal(nibName: "ContestConfirmationModal", bundle: nil)
        RootViewController.sharedInstance.pushModalViewController(confirmationModal!)
        confirmationModal!.enterContestButton.addTarget(self, action: .enterContestTap, forControlEvents: .TouchUpInside)
    }
    
    func enterContestTap(sender: DraftboardButton) {
        guard let chosenLineup = self.lineupChoice else { return }

        confirmationModal?.showSpinner()
        API.contestEnter(contest, lineup: chosenLineup).then { _ -> Void in
            self.confirmationModal?.showConfirmed()
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(dispatch_get_main_queue(),{
                    RootViewController.sharedInstance.popModalViewController()
                    self.didEnterContest()
                })
            }
        }
    }
    
    func disableContestEntry() {
        draftButton.userInteractionEnabled = false
        draftButton.backgroundColor = .greyCool()
        draftButton.iconImageView.alpha = 0
    }
    
    func didEnterContest() {
        disableContestEntry()
        draftButton.label.text = "Contest Entered".uppercaseString
    }
    
    override func didCancelModal() {
        RootViewController.sharedInstance.popModalViewController()
        lineupSelected = nil
    }
    
    // MARK: DraftboardViewController
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Back) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String? {
        return contest.name.uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ContestDetailViewControllerOld: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[tableDataKey]!.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0 || indexPath.row == tableData[tableDataKey]!.count + 1) {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "player_detail_empty_cell")
            cell.userInteractionEnabled = false
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(detailCellIdentifier, forIndexPath: indexPath) as! DraftboardDetailCell
        if let datum = tableData[tableDataKey]?[indexPath.row - 1] {
            cell.leftLabel.text = datum["left"] as? String
            cell.rightLabel.text = datum["right"] as? String
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 122.0
        }
        
        return 40.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: what happens here?
    }
}

// MARK: - UIScrollViewDelegate

extension ContestDetailViewControllerOld: UIScrollViewDelegate {
    
    func updateBackgroundForDelta(delta: CGFloat, total: CGFloat) {
        if (delta > total) {
            tableView.backgroundColor = .whiteColor()
        }
        else {
            tableView.backgroundColor = .clearColor()
        }
    }
    
    // Update top view
    func updateTopViewForDelta(delta: CGFloat, total: CGFloat) {
        if (delta < 0.0) {
            topViewHeight.constant = topViewHeightStart - delta;
            topView.alpha = 1.0
            return
        }
        
        topView.alpha = 1.0 - delta / total;
    }
    
    // Update draft button
    func updateDraftButtonForDelta(delta: CGFloat, total: CGFloat) {
        let adjDelta = 76.0 + delta + draftButtonHeight.constant / 2.0
        
        if (adjDelta >= total) {
            draftButtonTop.constant = draftButtonTopStart + adjDelta - total
            
            if (!stuck) {
                draftButtonWidth.constant = App.screenBounds.width
                draftButton.layer.removeAllAnimations()
                
                UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                
                stuck = true
            }
        }
        else if (stuck) {
            draftButtonTop.constant = draftButtonTopStart
            draftButtonWidth.constant = 230.0
            
            draftButton.layer.removeAllAnimations()
            UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }, completion: nil)
            
            stuck = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        let t = topViewHeight.constant
        
        // Update views
        updateTopViewForDelta(y, total: t)
        updateDraftButtonForDelta(y, total: t)
        updateBackgroundForDelta(y, total: t)
    }
}

private extension Selector {
    static let handleButtonTap = #selector(ContestDetailViewControllerOld.handleButtonTap(_:))
    static let enterContestTap = #selector(ContestDetailViewControllerOld.enterContestTap(_:))
}

/*
class ContestDetailViewController: DraftboardViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomInfoView: UIView!
    @IBOutlet weak var infoList: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var enterContestBtn: DraftboardArrowButton!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundHeightConstraight: NSLayoutConstraint!
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomInfoTopConstraint: NSLayoutConstraint!
    
    var contestName: String?
    var contestEntered = false
    var topViewHeightBase = CGFloat()
    var lineupSelected: Int?
    
    var confirmationModal: ContestConfirmationModal?

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        topViewHeightBase = topViewHeight.constant
        
        scrollView.bottomRancor.constraintEqualToRancor(bottomInfoView.bottomRancor, constant: 40).active = true
        
        let payoutList = [
            "1st place",
            "2nd place",
            "3rd place",
            "4th place",
            "5th place",
            "6th place",
            "7th place",
            "8th place",
            "9th place",
            "10th place",
        ]
        
        var previousCell: DraftboardDetailListItem?
        
        for (i, update) in payoutList.enumerate() {
            let payoutCell = DraftboardDetailListItem(showRightArrow: false)
            
            infoList.addSubview(payoutCell)
            payoutCell.leftText.text = update
            payoutCell.rightText.text = "$1"
            
            payoutCell.leadingRancor.constraintEqualToRancor(infoList.leadingRancor).active = true
            payoutCell.trailingRancor.constraintEqualToRancor(infoList.trailingRancor).active = true
            
            // we're the first!
            if previousCell == nil {
                payoutCell.topRancor.constraintEqualToRancor(infoList.topRancor).active = true
            }
            
            // we're not first :(
            if let previous = previousCell {
                payoutCell.topRancor.constraintEqualToRancor(previous.bottomRancor).active = true
            }
            
            // we're the last… but A(nchor) for effort?
            if i == payoutList.count - 1 {
                payoutCell.bottomRancor.constraintEqualToRancor(infoList.bottomRancor).active = true
            }
            
            previousCell = payoutCell
        }
        
        enterContestBtn.addTarget(self, action: "handleButtonTap:", forControlEvents: .TouchUpInside)
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
    
    // MARK: Handle the tap when someone wants to enter the contest
    // TODO: Actual logic...
    
    func handleButtonTap(sender: DraftboardButton) {
        var choices = [[String: String]]()
        choices.append(["title": "Warriors Stack", "subtitle": "In 3 Contests"])
        choices.append(["title": "Optimal", "subtitle": "In 0 Contests"])
        choices.append(["title": "Bulls Stack", "subtitle": "In 0 Contests"])
        
        let mcc = DraftboardModalChoiceController(title: "Choose an Eligible Lineup", choices: choices)
        RootViewController.sharedInstance.pushModalViewController(mcc)
    }
    
    override func didSelectModalChoice(index: Int) {
        confirmationModal = ContestConfirmationModal(nibName: "ContestConfirmationModal", bundle: nil)
        RootViewController.sharedInstance.pushModalViewController(confirmationModal!)
        confirmationModal!.enterContestButton.addTarget(self, action: "enterContestTap:", forControlEvents: .TouchUpInside)
    }
    
    func enterContestTap(sender: DraftboardButton) {
        confirmationModal?.showSpinner()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue(),{
                self.confirmationModal?.showConfirmed()
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    dispatch_async(dispatch_get_main_queue(),{
                        RootViewController.sharedInstance.popModalViewController()
                        self.didEnterContest()
                    })
                }
            })
        }
    }
    
    func didEnterContest() {
        enterContestBtn.userInteractionEnabled = false
        enterContestBtn.backgroundColor = .greyCool()
        enterContestBtn.label.text = "Contest Entered".uppercaseString
        enterContestBtn.iconImageView.alpha = 0
    }
    
    override func didCancelModal() {
        RootViewController.sharedInstance.popModalViewController()
        lineupSelected = nil
    }
}

// MARK: - UIScrollViewDelegate
extension ContestDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            topViewHeight.constant = topViewHeightBase + abs(scrollView.contentOffset.y)
        } else {
            topView.alpha = min(1 - (scrollView.contentOffset.y / 320), 1)
        }
        
        if scrollView.contentOffset.y > topViewHeightBase - 24 - 76 {
            buttonTopConstraint.constant = -(scrollView.contentOffset.y - bottomInfoTopConstraint.constant)
            
            self.view.layoutIfNeeded()
            buttonLeadingConstraint.constant = 0
            buttonTrailingConstraint.constant = 0
            UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            buttonTopConstraint.constant = 24
            
            self.view.layoutIfNeeded()
            buttonLeadingConstraint.constant = 45
            buttonTrailingConstraint.constant = -45
            UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
*/