//
//  LineupsListController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class LineupListController: DraftboardViewController, UIActionSheetDelegate {
    
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var createViewButton: DraftboardRoundButton!
    @IBOutlet weak var createImageView: UIImageView!
    @IBOutlet weak var createIconImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var lineupCardViews : [LineupCardView] = []
    var lastConstraint : NSLayoutConstraint?
    
    var sportChoices: [NSDictionary]?
    var draftGroupChoices: [String: [NSDictionary]]?
//    var draftGroupChoicesBySportName: [String: [String: String]]?
    var selectedSport: Sport?
    var selectedDraftGroup: DraftGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clearColor()
        
        // Pre-fetch data required for lineup creation
        let _ = Data.draftGroupUpcoming
        let _ = Data.contestLobby
        
        // Create view tap
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "presentDraftGroupPrompt")
        self.createView.addGestureRecognizer(tapRecognizer)
        
        // Scroll view
        scrollView.clipsToBounds = false
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
        
        // Create goes on top
        view.bringSubviewToFront(self.createView)
    }
    
    // MARK: - Titlebar delegate methods
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Plus) {
            presentDraftGroupPrompt()
        }
        else if(buttonType == .Menu) {
            let gfvc = GlobalFilterViewController(nibName: "GlobalFilterViewController", bundle: nil)
            RootViewController.sharedInstance.pushModalViewController(gfvc)
        }
    }
    
    // MARK: - Modal delegate methods
    
    override func didSelectModalChoice(index: Int) {
        if (selectedSport == nil) {
            didSelectSport(index)
        }
        else if (selectedSport != nil && selectedDraftGroup == nil) {
            didSelectDraftGroup(index)
        }
    }
    
    override func didCancelModal() {
        RootViewController.sharedInstance.popModalViewController()
        selectedSport = nil
        selectedDraftGroup = nil
    }
    
    // MARK: - Data
    
    func collateDraftGroups(draftGroups: [DraftGroup], contests: [Contest]) {
        // https://gist.github.com/zachwood/3a048570e904e31143d7
        
        if self.sportChoices != nil && self.draftGroupChoices != nil {
            return
        }
        
        // Organize data
        var sportNames = [String]()
        for draftGroup in draftGroups {
            let s = draftGroup.sport.name
            if !sportNames.contains(s) {
                sportNames.append(s)
            }
        }
        
        var sportContestCounts = [String: Int]()
        var draftGroupContestCounts = [Int: Int]()
        for contest in contests {
            if contest.status == "completed" {
                continue
            }
            let s = contest.sport.name
            let sportCount = sportContestCounts[s] ?? 0
            sportContestCounts[s] = sportCount + 1
            let d = contest.draftGroup.id
            let draftGroupCount = draftGroupContestCounts[d] ?? 0
            draftGroupContestCounts[d] = draftGroupCount + 1
        }
        
        
        // Build choices
        var sportChoices = [NSDictionary]()
        for sportName in sportNames {
            let contestCount = sportContestCounts[sportName] ?? 0
            let contestNoun = (contestCount == 1) ? "Contest" : "Contests"
            let choice = [
                "title": sportName,
                "subtitle": "\(contestCount) \(contestNoun)",
                "object": Sport(name: sportName)!
            ]
            sportChoices.append(choice)
        }
        
        var draftGroupChoices = [String: [NSDictionary]]()
        for draftGroup in draftGroups {
            let s = draftGroup.sport.name
            let id = draftGroup.id
            // Start time
            let df = NSDateFormatter()
            df.dateFormat = "E, MMM dd, h:mm a"
            let start = df.stringFromDate(draftGroup.start)
            // Contest and game counts
            let contestCount = draftGroupContestCounts[id] ?? 0
            let contestNoun = (contestCount == 1) ? "Contest" : "Contests"
            let gameCount = draftGroup.numGames
            let gameNoun = (gameCount == 1) ? "Game" : "Games"
            let choice = [
                "title": "\(start)",
                "subtitle": "\(contestCount) \(contestNoun), \(gameCount) \(gameNoun)",
                "object": draftGroup
            ]
            var choices = draftGroupChoices[s] ?? [NSDictionary]()
            choices.append(choice)
            draftGroupChoices[s] = choices
        }
        
        self.sportChoices = sportChoices
        self.draftGroupChoices = draftGroupChoices
    }

    // MARK: - View presentation
    
    func presentDraftGroupPrompt() {
        when(Data.draftGroupUpcoming, Data.contestLobby).then { draftGroups, contests -> Void in
            self.collateDraftGroups(draftGroups, contests: contests)
            self.selectSport()
        }
    }
    
    func presentLineupCard(lineup: Lineup) {
        self.createView.hidden = true

        let cardView = LineupCardView()
        cardView.lineup = lineup
        scrollView.addSubview(cardView)
        
        // Set player detail action
        cardView.showPlayerDetailAction = showPlayerDetail
        cardView.editAction = editLineup
        cardView.contestsAction = showContestsForLineup
        
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
//        cardView.contentView.flashScrollIndicators()
    }
    
    // MARK: - DraftGroup selection
    
    func selectSport() {
        let choices = sportChoices!
        let title = (choices.count) > 0 ? "Choose a Sport" : "No DraftGroups Available!"
        let mcc = DraftboardModalChoiceController(title: title, choices: choices)
        RootViewController.sharedInstance.pushModalViewController(mcc)
    }
    
    func didSelectSport(index: Int) {
        let sportChoice = sportChoices![index]
        selectedSport = sportChoice["object"] as? Sport
        // Pre-fetch data required for showing player injury status
        _ = Data.sportsInjuries(selectedSport!.name)
        selectDraftGroup()
    }
    
    func selectDraftGroup() {
        let choices = draftGroupChoices![selectedSport!.name]!
        let mcc = DraftboardModalChoiceController(title: "Choose a Start Time", choices: choices)
        RootViewController.sharedInstance.pushModalViewController(mcc)
    }
    
    func didSelectDraftGroup(index: Int) {
        RootViewController.sharedInstance.popModalViewController()
        let choices = draftGroupChoices![selectedSport!.name]
        let draftGroupChoice = choices![index]
        selectedDraftGroup = draftGroupChoice["object"] as? DraftGroup
        createLineup()
    }
    
    // MARK: - View controller handoff
    
    func createLineup() {
        let draftGroup = selectedDraftGroup!
        selectedSport = nil
        selectedDraftGroup = nil
        
        // Pre-fetch data required for player selection
        let _ = Data.draftGroup(id: draftGroup.id)
        
        // Creating a lineup is editing an empty lineup
        let nvc = LineupEditViewController(nibName: "LineupEditViewController", bundle: nil)
        nvc.lineup.draftGroup = draftGroup
        nvc.saveLineupAction = { lineup in
            self.presentLineupCard(lineup)
            self.navController?.popViewControllerToCardView(self.lineupCardViews.last!, animated: true)
        }
        
        navController?.pushViewController(nvc)
    }
    
    func editLineup(lineupCard: LineupCardView) {
        let evc = LineupEditViewController(nibName: "LineupEditViewController", bundle: nil)
        evc.lineup = lineupCard.lineup
        evc.saveLineupAction = { lineup in
            lineupCard.lineup = lineup
            self.navController?.popViewControllerToCardView(self.lineupCardViews.last!, animated: true)
        }
        navController?.pushViewController(evc)
    }
    
    func showContestsForLineup(lineupCard: LineupCardView) {
        let tc = RootViewController.sharedInstance.tabController
        tc.tabBar.selectButtonAtIndex(1, animated: true)
    }
    
    func showPlayerDetail(player: Player, isLive: Bool, isDraftable: Bool = false) {
        let nvc = PlayerDetailViewController()
        nvc.player = player
        nvc.draftable = false
        
        self.navController?.pushViewController(nvc)
    }
    
    // MARK: - Titlebar datasource methods
    
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
