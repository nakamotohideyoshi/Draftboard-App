//
//  LineupsListController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class LineupListController: DraftboardViewController, UIActionSheetDelegate, LineupCardViewDelegate {
    
    var downcastedView: LineupListControllerView { return view as! LineupListControllerView }
    
    var lineupCardViews: [LineupCardView] = []
    var lastConstraint: NSLayoutConstraint?
    
    var draftGroupChoices: [String: [NSDictionary]]?
    var sportChoices: [NSDictionary]?
    
    var selectedDraftGroup: DraftGroup?
    var selectedSport: Sport?
    
    var lineups: [Lineup] = []
    var reusableCardViews: [LineupCardView] = []
    var cardIndicesInView: Set<Int> = Set()
    
    var toggleOption: LineupCardToggleOption = .Salary
    var noLoad: Bool = false
    var loaded: Bool = false
    
    override func loadView() {
        self.view = LineupListControllerView()
        let view = downcastedView

        // Create view tap
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: .presentDraftGroupPrompt)
        view.createView.addGestureRecognizer(tapRecognizer)
        
        // Configure scroll view
        view.scrollView.delegate = self
        view.scrollView.alpha = 0

        // Hide pagination to start
        view.paginationHeight.constant = 20.0
        view.paginationView.hidden = true
        
        // Create reusable cards
        createReusableCardViews()
        view.createView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // TODO: remove this stupid fix
        if noLoad {
            noLoad = false
            return
        }
        
        // Get lineups
        Data.lineups().then { cached, fresh -> Promise<[Lineup]> in
            if let cachedLineups = cached {
                if self.lineups.count == 0 {
                    self.gotLineups(cachedLineups)
                }
            }
            
            return fresh
        }.then { lineups in
            self.gotLineups(lineups)
        }
    }
    
    // MARK: - Setup stuff
    
    func createReusableCardViews() {
        let view = downcastedView
        
        for _ in 1...3 {
            
            // Create card view
            let cardView = LineupCardView(frame: CGRectMake(0, 0, 500, 500), cellCount: 8)
            cardView.delegate = self
            cardView.hidden = true
            
            // Set card dimensions
            view.scrollView.addSubview(cardView)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            cardView.topRancor.constraintEqualToRancor(view.scrollView.topRancor).active = true
            cardView.widthRancor.constraintEqualToRancor(view.scrollView.widthRancor).active = true
            cardView.heightRancor.constraintEqualToRancor(view.scrollView.heightRancor).active = true
            
            // Position card view
            cardView.left = cardView.leftRancor.constraintEqualToRancor(view.scrollView.leftRancor, constant: 0.0)
            cardView.left!.active = true
            
            // Configure card actions
            cardView.editAction = editLineup
            cardView.contestsAction = showContestsForLineup
            cardView.showPlayerDetailAction = showPlayerDetail
            
            // Hang onto it
            reusableCardViews.append(cardView)
        }
    }
    
    // MARK: - LineupCardViewDelegate methods
    
    func didSelectToggleOption(option: LineupCardToggleOption) {
        for (_, cardView) in reusableCardViews.enumerate() {
            cardView.selectToggleOption(option)
        }
        
        toggleOption = option
    }
    
    // MARK: - Modals
    
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
    
    func gotLineups(newLineups: [Lineup]) {
        let view = downcastedView
        
        // Got lineups
        view.loaderView.hidden = true
        UIView.animateWithDuration(0.25) {
            view.scrollView.alpha = 1.0
        }
        
        // Update scroll view
        let b = view.scrollView.bounds
        view.scrollView.contentSize = CGSizeMake(CGFloat(newLineups.count) * b.size.width, 0)
        
        // Save scroll positions
        for newLineup in newLineups {
            for lineup in lineups {
                if lineup.id == newLineup.id {
                    newLineup.cardScrollPos = lineup.cardScrollPos
                }
            }
        }
        
        // New lineups
        lineups = newLineups
        updatePagination()
        
        // Show create view if necessary
        if lineups.count == 0 {
            view.createView.hidden = false
            return
        }
        
        // Hide create view
        view.createView.hidden = true
        
        // Load lineup players
        for lineup in lineups {
            
            // Save scroll positions
            for newLineup in newLineups {
                if lineup.id == newLineup.id {
                    newLineup.cardScrollPos = lineup.cardScrollPos
                }
            }
            
            // Start up
            if !loaded {
                loaded = true
                for cardView in reusableCardViews {
                    cardView.contentView.contentOffset = CGPointMake(0, 44.0)
                }
            }
            
            // Update cards one by one
            API.draftGroup(id: lineup.draftGroup.id).then { draftGroup -> Void in
                lineup.draftGroup = draftGroup
                
                if let idx = self.lineups.indexOf({$0.id == lineup.id}) {
                    if self.cardIndicesInView.contains(idx) {
                        let modIndex = idx % self.reusableCardViews.count
                        let cardView = self.reusableCardViews[modIndex]
                        
                        // Update scroll position
                        if let cardLineup = cardView.lineup {
                            if cardLineup.id == lineup.id {
                                lineup.cardScrollPos = cardLineup.cardScrollPos
                            }
                        }
                        
                        cardView.lineup = lineup
                        cardView.reloadContent(self.toggleOption, updateScrollPos: false)
                    }
                }
            }
        }
        
        scrollViewDidScroll(view.scrollView)
    }
    
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
    
    // MARK: - Modals
    
    func presentDraftGroupPrompt() {
        let mcc = DraftboardModalChoiceController(title: "CHOOSE A SPORT", choices: nil)
        RootViewController.sharedInstance.pushModalViewController(mcc)
        
        when(API.draftGroupUpcoming(), API.contestLobby()).then { draftGroups, contests -> Void in
            self.collateDraftGroups(draftGroups, contests: contests)
            
            let choices = self.sportChoices!
            if (choices.count == 0) {
                mcc.titleLabel.text = "No DraftGroups Available!"
            }
            
            mcc.choiceData = choices
            mcc.reloadChoiceViews()
        }
    }
    
    func didSelectSport(index: Int) {
        let sportChoice = sportChoices![index]
        selectedSport = sportChoice["object"] as? Sport
        // Pre-fetch data required for showing player injury status
        // _ = Data.sportsInjuries(selectedSport!.name)
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
    
    // MARK: - Create/Edit/Contests
    
    func createLineup() {
        let view = downcastedView
        
        let draftGroup = selectedDraftGroup!
        selectedSport = nil
        selectedDraftGroup = nil
        
        // Creating a lineup is editing an empty lineup
        let nvc = LineupEditViewController(nibName: "LineupEditViewController", bundle: nil)
        nvc.lineup.draftGroup = draftGroup
        nvc.saveLineupAction = { lineup in
            
            // Add lineup, sort by date
            self.lineups.append(lineup)
            self.lineups.sortInPlace { (element1, element2) -> Bool in
                let result = element1.draftGroup.start.compare(element2.draftGroup.start)
                return result == NSComparisonResult.OrderedAscending
            }
            
            // Get index of added lineup
            var idx = 0
            for lp in self.lineups {
                if lp.id == lineup.id {
                    break
                }
                idx += 1
            }
            
            // Update content size, pagination
            let b = view.scrollView.bounds
            view.scrollView.contentSize = CGSizeMake(CGFloat(self.lineups.count) * b.size.width, 0)
            self.updatePagination()
            
            // Move to new lineup
            self.noLoad = true
            self.setLineupIndex(idx)
            self.navController?.popViewController()
            
            // Save lineup
            API.lineupCreate(lineup)
            view.createView.hidden = true
            self.scrollViewDidScroll(view.scrollView)
        }
        
        navController?.pushViewController(nvc)
    }
    
    func editLineup(lineupCard: LineupCardView) {
        let evc = LineupEditViewController(nibName: "LineupEditViewController", bundle: nil)
        evc.lineup = lineupCard.lineup!
        
        evc.saveLineupAction = { lineup in
            lineupCard.lineup = lineup
            lineupCard.reloadContent(self.toggleOption)
            
            self.navController?.popViewController()
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
    
    // MARK: - Controls
    
    func setLineupIndex(index: Int, animated: Bool = true) {
        let view = downcastedView
        
        if lineups.count <= 0 {
            return
        }
        
        // Bound index
        let idx = min(index, lineups.count - 1)
//        let lineup = lineups[idx]
        
        // Update scroll position
        let x = CGFloat(idx) * view.scrollView.bounds.size.width
        view.scrollView.setContentOffset(CGPointMake(x, 0), animated: animated)
        
        // Update pagination page
        view.paginationView.selectPage(idx)
    }
    
    func updatePagination() {
        let view = downcastedView
        
        view.paginationView.pages = lineups.count
        
        if lineups.count > 1 {
            view.paginationHeight.constant = 36.0
            view.paginationView.hidden = false
        }
        else {
            view.paginationHeight.constant = 20.0
            view.paginationView.hidden = true
        }
    }
    
    // MARK: - DraftboardTitlebarDelegate methods
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Plus) {
            presentDraftGroupPrompt()
        }
        else if(buttonType == .Menu) {
            let gfvc = GlobalFilterViewController(nibName: "GlobalFilterViewController", bundle: nil)
            RootViewController.sharedInstance.pushModalViewController(gfvc)
        }
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
    
    func updateCardsInView(indices: Set<Int>) {
        let view = downcastedView
        
        let indicesToUpdate = indices.subtract(cardIndicesInView)
        let bounds = view.scrollView.bounds
        
        for (_, index) in indicesToUpdate.enumerate() {
            let modIndex = index % reusableCardViews.count
            let cardView = reusableCardViews[modIndex]
            
            cardView.left?.constant = CGFloat(index) * bounds.size.width
            cardView.hidden = false
            
            let lineup = lineups[index]
            cardView.lineup = lineup
            cardView.reloadContent(toggleOption)
        }
    }
    
    func updateCardIndicesInView(pageOffset: Double) {
        let view = downcastedView

        var indices: Set<Int> = Set()
        let bounds = view.scrollView.bounds
        let cardFrame = CGRectMake(0, 0, bounds.size.width, bounds.size.height)
        let adjustedBounds = CGRectMake(bounds.origin.x - 20.0, bounds.origin.y, bounds.size.width + 40.0, bounds.size.height)
        
        for index in 0...lineups.count - 1 {
            let frame = CGRectOffset(cardFrame, CGFloat(index) * cardFrame.size.width, 0)
            if CGRectIntersectsRect(frame, adjustedBounds) {
                indices.insert(index)
            }
        }
        
        if indices != cardIndicesInView {
            updateCardsInView(indices)
            cardIndicesInView = indices
        }
    }
    
    func updateTransforms(pageOffset: Double) {
        for (_, pageIndex) in cardIndicesInView.enumerate() {
            let modIndex = pageIndex % reusableCardViews.count
            let cardView = reusableCardViews[modIndex]
            
            // Page delta is number of pages from perfect center and can be negative
            let pageDelta = Double(pageIndex) - pageOffset
            
            // Clamp values from -1.0 to 1.0
            let magnitude = min(Double.abs(pageDelta), 1.0)
            let direction = (pageDelta < 0) ? -1.0 : 1.0
            
            // Lame attempt to fix a visual glitch in fake carousel rotation
            let m = max(magnitude - 0.05, 0.0) * 1.1
            cardView.rotate(m * direction)
            cardView.fade(magnitude)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let view = downcastedView
        
        if lineups.count <= 0 {
            return
        }
        
        let pageOffset = Double(scrollView.contentOffset.x / scrollView.frame.size.width)
        view.paginationView.selectPage(Int(round(pageOffset)))
        
        updateCardIndicesInView(pageOffset)
        updateTransforms(pageOffset)
    }
}

private extension Selector {
    static let presentDraftGroupPrompt = #selector(LineupListController.presentDraftGroupPrompt)
}