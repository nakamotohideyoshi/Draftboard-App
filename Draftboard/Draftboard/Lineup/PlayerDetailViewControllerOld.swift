//
//  PlayerDetailViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 10/29/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class PlayerDetailViewControllerOld: DraftboardViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewTop: NSLayoutConstraint!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var avatarImageView: BigAvatarImageView!
    
    var draftButton: DraftboardArrowButton!
    var draftButtonTop: NSLayoutConstraint!
    var draftButtonWidth: NSLayoutConstraint!
    var draftButtonHeight: NSLayoutConstraint!
    
    var segmentedControl: DraftboardSegmentedControl!
    var segmentedHeight: NSLayoutConstraint!
    var segmentedTop: NSLayoutConstraint!

    var topViewTopStart: CGFloat = 0.0
    var draftButtonTopStart: CGFloat = 0.0
    
    var stuck = true
    var draftable = true
    
    var player: Player?
    var playerUpdates = [String]()
    
    let detailCellIdentifier = "player_detail_cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create UI
        createSegmentedControl()
        createDraftButton()
        
        // Remove background colors from nib
        topView.backgroundColor = .clearColor()
        tableView.backgroundColor = .clearColor()
        
        // Need these for scrollViewDidScroll
        topViewTopStart = topViewTop.constant
        draftButtonTopStart = draftButtonTop.constant
        
        // offset the top of the tableview with a clear headerview
        let headerView = UIView(frame: CGRectMake(0.0, 0.0, App.screenBounds.width, topViewHeight.constant))
        tableView.tableHeaderView = headerView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 60.0, 0.0)
        
        // Register cell
        let bundle = NSBundle(forClass: self.dynamicType)
        let cellNib = UINib(nibName: "DraftboardDetailCell", bundle: bundle)
        tableView.registerNib(cellNib, forCellReuseIdentifier: detailCellIdentifier)
        
        // Fake data
        playerUpdates = [
            "John Lackey beats Royals for ninth win",
            "Matthew Berry dishes out his player advice",
            "McHale firing signals revisions in coach's job",
            "Ford/Pelton: Was Russell right for Lakers?",
            "Drummond best center in the NBA?",
            "Surprising pace leaders",
            "DeRozan's career-best start",
            "Finding fantasy NBA studs with usage rate",
            "John Lackey beats Royals for ninth win",
            "Matthew Berry dishes out his player advice",
            "McHale firing signals revisions in coach's job",
            "Ford/Pelton: Was Russell right for Lakers?",
            "Drummond best center in the NBA?",
            "Surprising pace leaders",
            "DeRozan's career-best start",
            "Finding fantasy NBA studs with usage rate",
        ]
        
        // Update avatar image
        avatarImageView.player = player
        
        if (!draftable) {
            segmentedHeight.constant = 97.0;
            segmentedTop.constant = topViewHeight.constant;
            draftButton.hidden = true
        }
    }
    
    func createDraftButton() {
        draftButton = DraftboardArrowButton()
        draftButton.textBold = true
        draftButton.textValue = "DRAFT PLAYER";
        
        tableView.addSubview(draftButton)
        draftButton.translatesAutoresizingMaskIntoConstraints = false
        draftButton.centerXRancor.constraintEqualToRancor(tableView.centerXRancor).active = true
        
        draftButtonHeight = draftButton.heightRancor.constraintEqualToConstant(50.0)
        draftButtonHeight.active = true
        
        draftButtonWidth = draftButton.widthRancor.constraintEqualToConstant(230.0)
        draftButtonWidth.active = true
        
        draftButtonTop = draftButton.topRancor.constraintEqualToRancor(tableView.topRancor, constant: topViewHeight.constant - 25.0)
        draftButtonTop.active = true
    }
    
    func createSegmentedControl() {
        segmentedControl = DraftboardSegmentedControl(
            choices: ["Points", "Game Log"],
            textColor: .blueDarker(),
            textSelectedColor: .greenDraftboard()
        )
        
        self.tableView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.widthRancor.constraintEqualToConstant(170.0).active = true
        segmentedControl.centerXRancor.constraintEqualToRancor(tableView.centerXRancor).active = true
        
        segmentedHeight = segmentedControl.heightRancor.constraintEqualToConstant(97.0)
        segmentedHeight.active = true
        
        segmentedTop = segmentedControl.topRancor.constraintEqualToRancor(tableView.topRancor, constant: topViewHeight.constant + 25.0)
        segmentedTop.active = true
        
        segmentedControl.indexChangedHandler = { (index: Int) in
            // TODO: switch / reload data
        }
    }
    
    // MARK: DraftboardViewController
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Back) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String? {
        if player == nil {
            return "Kyle Korver".uppercaseString
        }
        return player?.name.uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
    
    override func titlebarBgHidden() -> Bool {
        return false
    }
    
    override func footerType() -> FooterType {
        if (draftable) {
            return .Stats
        }
        
        return .None
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PlayerDetailViewControllerOld: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerUpdates.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "player_detail_empty_cell")
            cell.userInteractionEnabled = false
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(detailCellIdentifier, forIndexPath: indexPath) as! DraftboardDetailCell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            if (!draftable) {
                return 97.0
            }
            
            return 122.0
        }
        
        return 40.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: what happens here?
    }
}

// MARK: - UIScrollViewDelegate

extension PlayerDetailViewControllerOld: UIScrollViewDelegate {
    
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
            topViewTop.constant = topViewTopStart - delta / 2.0
            topView.alpha = 1.0
            return
        }
        
        topView.alpha = 1.0 - delta / total;
    }
    
    // Update draft button
    func updateDraftButtonForDelta(delta: CGFloat, total: CGFloat) {
        let adjDelta = delta + draftButtonHeight.constant / 2.0
        
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
