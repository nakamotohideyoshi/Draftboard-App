//
//  LineupsListController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupListController: DraftboardViewController, UIActionSheetDelegate {
    
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var createViewButton: DraftboardRoundButton!
    @IBOutlet weak var createImageView: UIImageView!
    @IBOutlet weak var createIconImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var lineupCardViews : [LineupCardView] = []
    var lastConstraint : NSLayoutConstraint?
    
    var sportIndex: Int?
    var timeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = Data.draftGroupUpcoming
        
        self.view.backgroundColor = .clearColor()
        
        // Create view tap
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapCreateView:")
        self.createView.addGestureRecognizer(tapRecognizer)
        
        // Scroll view
        scrollView.clipsToBounds = false
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
        
        // Create goes on top
        view.bringSubviewToFront(self.createView)
        
//        // Fake lineup
//        let playerData = [
//            "player_id": 0,
//            "name": "Kyle Korver",
//            "position": "PG",
//            "fppg": 0.25,
//            "team_alias": "ABC",
//            "salary": 5000.0
//        ]
//        
//        self.didSaveLineup([
//            Player(data: playerData),
//            Player(data: playerData),
//            Player(data: playerData),
//            Player(data: playerData),
//            Player(data: playerData),
//            Player(data: playerData),
//            Player(data: playerData),
//            Player(data: playerData),
//        ])
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Plus) {
            promptCreate()
        }
        else if(buttonType == .Menu) {
            let gfvc = GlobalFilterViewController(nibName: "GlobalFilterViewController", bundle: nil)
            RootViewController.sharedInstance.pushModalViewController(gfvc)
        }
    }
    
    override func didSelectModalChoice(index: Int) {
        if (sportIndex == nil) {
            sportIndex = index
            
            Data.draftGroupUpcoming.then { draftGroups -> Void in
                var choices = [[String: String]]()
                var sports = [String]()
                for draftGroup in draftGroups {
                    let s = draftGroup.sport.name
                    if !sports.contains(s) {
                        sports.append(s)
                    }
                }
                let sport = sports[index]
                for draftGroup in draftGroups {
                    let df = NSDateFormatter()
                    df.dateFormat = "MMM dd, h:mm a"
                    let t = df.stringFromDate(draftGroup.start)
                    
                    if draftGroup.sport.name == sport {
                        choices.append(["title": "\(t)", "subtitle": "X Contests"])
                    }
                }
                let mvc = DraftboardModalChoiceController(title: "Choose a Contest Time", choices: choices)
                RootViewController.sharedInstance.pushModalViewController(mvc)
            }
        }
            
        else if (sportIndex != nil && timeIndex == nil) {
            timeIndex = index
            
            Data.draftGroupUpcoming.then { draftGroups -> Void in
                var sports = [String]()
                var times = [NSDate]()
                for draftGroup in draftGroups {
                    let s = draftGroup.sport.name
                    if !sports.contains(s) {
                        sports.append(s)
                    }
                }
                let sport = sports[index]
                for draftGroup in draftGroups {
                    if draftGroup.sport.name == sport {
                        let t = draftGroup.start
                        times.append(t)
                        if times.count == index + 1 {
                            RootViewController.sharedInstance.popModalViewController()
                            self.createNewLineup(draftGroup: draftGroup)
                            
                            // TODO: remove these when data is connected
                            self.sportIndex = nil
                            self.timeIndex = nil
                            break
                        }
                    }
                }
            }

        }
    }
    
    override func didCancelModal() {
        RootViewController.sharedInstance.popModalViewController()
        sportIndex = nil
        timeIndex = nil
    }
    
    func didTapCreateView(gestureRecognizer: UITapGestureRecognizer) {
        promptCreate()
    }
    
    func promptCreate() {
        Data.draftGroupUpcoming.then { draftGroups -> Void in
            var choices = [[String: String]]()
            var sports = [String]()
            for draftGroup in draftGroups {
                let s = draftGroup.sport.name
                if !sports.contains(s) {
                    sports.append(s)
                    choices.append(["title": s, "subtitle": "X Contests"])
                }
            }
            let mcc = DraftboardModalChoiceController(title: "Choose a Sport", choices: choices)
            RootViewController.sharedInstance.pushModalViewController(mcc)
        }
    }
    
    func createNewLineup(draftGroup draftGroup: DraftGroup) {
        let _ = Data.draftGroup(id: draftGroup.id)
        let nvc = LineupEditViewController(nibName: "LineupEditViewController", bundle: nil)
        nvc.draftGroup = draftGroup
        nvc.saveLineupAction = { (lineup: [Player]) in
            self.didSaveLineup(lineup)
            self.navController?.popViewControllerToCardView(self.lineupCardViews.last!, animated: true)
        }
        
        navController?.pushViewController(nvc)
    }
    
    func didSaveLineup(lineup: [Player]) {
        self.createView.hidden = true
        addLineup(lineup)
    }
    
    func addLineup(lineup: [Player]) {
        let cardView = LineupCardView()
        cardView.lineup = lineup
        scrollView.addSubview(cardView)
        
        // Set player detail action
        cardView.showPlayerDetailAction = showPlayerDetail
        
        // Set card dimensions
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.widthRancor.constraintEqualToRancor(scrollView.widthRancor).active = true
        cardView.heightRancor.constraintEqualToRancor(scrollView.heightRancor).active = true
        cardView.topRancor.constraintEqualToRancor(scrollView.topRancor).active = true
        
        // Position card horizontally
        if let lastCardView = lineupCardViews.last {
            cardView.leftRancor.constraintEqualToRancor(lastCardView.rightRancor).active = true
        } else {
            cardView.leftRancor.constraintEqualToRancor(scrollView.leftRancor).active = true
        }
        
        // Attach to right edge / end of scrollView
        lastConstraint?.active = false
        lastConstraint = cardView.rightRancor.constraintEqualToRancor(scrollView.rightRancor)
        lastConstraint?.active = true
        
        // Store card
        self.lineupCardViews.append(cardView)
        
        // Scroll to card
        self.view.layoutIfNeeded()
        scrollView.setContentOffset(cardView.frame.origin, animated: false)
        cardView.contentView.flashScrollIndicators() // TODO: Maybe someday...
    }
    
    func showPlayerDetail(player: Player, isLive: Bool, isDraftable: Bool = false) {
        if isLive {
            let nvc = PlayerDetailLiveViewController()
            nvc.player = player
            self.navController?.pushViewController(nvc)
        } else {
            let nvc = PlayerDetailViewController()
            nvc.player = player
            nvc.draftable = false
            self.navController?.pushViewController(nvc)
        }
    }
    
    override func titlebarTitle() -> String {
        return "Lineups".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Menu
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType {
        return .Plus
    }
}

// MARK: - UIScrollViewDelegate

extension LineupListController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let pageOffset = Double(scrollView.contentOffset.x / scrollView.frame.size.width)
        let views: [UIView] = (lineupCardViews.count > 0) ? lineupCardViews : [createView]
        
        for (pageIndex, card) in views.enumerate() {
            // Page delta is number of pages from perfect center and can be negative
            let pageDelta = Double(pageIndex) - pageOffset
            // Clamp values from -1.0 to 1.0
            let magnitude = min(Double.abs(pageDelta), 1.0)
            let direction = (pageDelta < 0) ? -1.0 : 1.0
            // Lame attempt to fix a visual glitch in fake carousel rotation
            let m = max(magnitude - 0.05, 0.0) * 1.1
            card.rotate(m * direction)
            card.fade(magnitude)
        }
    }
}
