//
//  LineupsListController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class LineupListViewController: DraftboardViewController, UIActionSheetDelegate {
    
    var lineupListView: LineupListView { return view as! LineupListView }
    var myTitle: String = "Lineups"
    var draftGroupChoices: [String: [NSDictionary]]?
    var sportChoices: [NSDictionary]?
    
    var selectedDraftGroup: DraftGroup?
    var selectedSport: Sport?
    
//    var lineups: [Lineup]? { didSet { update() } }
    var lineupDetailViewControllers: [LineupDetailViewController]? { didSet { update() } }
    
    override func loadView() {
        view = LineupListView()
        
        lineupListView.cardCollectionView.delegate = self
        lineupListView.cardCollectionView.dataSource = self
        
        // Hide pagination to start
        lineupListView.paginationHeight.constant = 20.0
        lineupListView.paginationView.hidden = true
        
        update()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Get lineups
        Data.upcomingLineups.get().then { lineups in
            return lineups.sortedByDate()
        }.then { sortedLineups -> Void in
            if self.lineupDetailViewControllers?.count != sortedLineups.count {
                self.lineupDetailViewControllers = sortedLineups.map { LineupDetailViewController(lineup: $0) }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func update() {
        lineupListView.loaderView.hidden = (lineupDetailViewControllers != nil)
        lineupListView.loaderView.resumeSpinning()
        lineupListView.cardCollectionView.hidden = (lineupDetailViewControllers == nil)
        lineupListView.cardCollectionView.reloadData()
        lineupListView.cardCollectionView.setContentOffset(CGPointMake(1, 0), animated: false)
        lineupListView.cardCollectionView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    // MARK: - Modals
    /*
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
        
        // Load lineup players
        for lineup in lineups {
            
            // Save scroll positions
            for newLineup in newLineups {
                if lineup.id == newLineup.id {
                    newLineup.cardScrollPos = lineup.cardScrollPos
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
        Data.draftGroup(id: draftGroup.id).then { draftGroupWithPlayers in
            nvc.draftGroup = draftGroupWithPlayers
        }
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
            self.setLineupIndex(idx)
            self.navController?.popViewController()
            
            // Save lineup
            API.lineupCreate(lineup)
        }
        
        navController?.pushViewController(nvc)
    }
    
    func editLineup(lineupCard: LineupCardView) {
        let evc = LineupEditViewController(nibName: "LineupEditViewController", bundle: nil)
        evc.lineup = lineupCard.lineup!
        
        evc.saveLineupAction = { lineup in
            lineupCard.lineup = lineup
            
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
 */
    
    // MARK: - Titlebar datasource methods
    
    override func titlebarTitle() -> String {
        return myTitle.uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return nil
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType? {
        return .Plus
    }
}

// MARK: -

extension LineupListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // UICollectionViewDataSource
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // At least one
        return max(1, lineupDetailViewControllers?.count ?? 0)
    }
    
    func collectionView(_: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = lineupListView.cardCollectionView.dequeueReusableCellForIndexPath(indexPath)
        let vc = lineupDetailViewControllers?[safe: indexPath.row]
        cell.lineupDetailView = vc?.lineupDetailView
        
        /*
        for subview in cell.lineupView.subviews {
//            subview.removeConstraints(subview.constraints)
            subview.removeFromSuperview()
        }
        if let newView = lineupDetailViewControllers?[safe: indexPath.row]?.view {
            cell.lineupView.userInteractionEnabled = true
            cell.lineupView.addSubview(newView)
            newView.topRancor.constraintEqualToRancor(cell.lineupView.topRancor).active = true
            newView.leftRancor.constraintEqualToRancor(cell.lineupView.leftRancor).active = true
            newView.rightRancor.constraintEqualToRancor(cell.lineupView.rightRancor).active = true
            newView.bottomRancor.constraintEqualToRancor(cell.lineupView.bottomRancor).active = true
            newView.translatesAutoresizingMaskIntoConstraints = false
        } else {
            cell.lineupView.userInteractionEnabled = false
        }
         */
        
        /*
        cell.lineupView.editAction = {
//            print(cell.lineupView.convertRect(cell.bounds, toView: self.view))
//            cell.hidden = true
            self.myTitle = "Edit Lineup"
            self.navController?.updateTitlebar()
            let fart = LineupDetailView()
            fart.tableView.contentOffset = cell.lineupView.tableView.contentOffset
            self.view.addSubview(fart)
            fart.translatesAutoresizingMaskIntoConstraints = false
            let left = fart.leftRancor.constraintEqualToRancor(self.view.leftRancor, constant: 26)
            let right = fart.rightRancor.constraintEqualToRancor(self.view.rightRancor, constant: -26)
            let top = fart.topRancor.constraintEqualToRancor(self.view.topRancor, constant: 78.0)
            let bottom = fart.bottomRancor.constraintEqualToRancor(self.view.bottomRancor, constant: -22)
            NSLayoutConstraint.activateConstraints([left, right, top, bottom])
            self.view.layoutIfNeeded()
//            UIView.animateKeyframesWithDuration(0.25, delay: 0, options: [.CalculationModeLinear], animations: {
//                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/3, animations: {
//                    left.constant = 26
//                    right.constant = -26
//                    bottom.constant = -22
//                    self.view.layoutIfNeeded()
//                    var transform = CATransform3DIdentity
////                    transform.m34 = -1/500
////                    transform = CATransform3DRotate(transform, CGFloat(-M_PI / 12), 1, 0, 0)
//                    fart.layer.transform = transform
//                })
//                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 1/3, animations: {
//                    var transform = CATransform3DIdentity
//                    transform.m34 = -1/500
//                    transform = CATransform3DRotate(transform, CGFloat(-M_PI / 12), 1, 0, 0)
//                    fart.layer.transform = transform
//                })

            UIView.animateWithDuration(0.25, animations: { 
                
//                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: {
                    var transform = CATransform3DIdentity
                    transform = CATransform3DScale(transform, 0.95, 0.95, 1.0)
                    transform = CATransform3DTranslate(transform, 0, 10, 0)
                    self.downcastedView.collectionView.layer.transform = transform
                    self.downcastedView.collectionView.layer.opacity = 0
                    left.constant = 0
                    right.constant = 0
                    bottom.constant = 50
                    self.view.layoutIfNeeded()
                })
                /*
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: {
                    var transform = CATransform3DIdentity
//                    transform.m34 = -1/500
                    transform = CATransform3DTranslate(transform, 0, 15, 0)
//                    transform = CATransform3DTranslate(transform, 0, -fart.bounds.height/2, 0)
//                    transform = CATransform3DRotate(transform, CGFloat(-M_PI / 12), 1, 0, 0)
//                    transform = CATransform3DTranslate(transform, 0, fart.bounds.height/2, 0)
                    fart.layer.transform = transform
                })
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: {
//                    var transform = CATransform3DIdentity
//                    transform.m34 = -1/500
//                    transform = CATransform3DRotate(transform, CGFloat(-M_PI / 12), 1, 0, 0)
                    fart.layer.transform = CATransform3DIdentity
                })
                 */

//            }, completion: nil)
            fart.tableView.setEditing(true, animated: true)
            

//            UIView.animateWithDuration(0.2, delay: 0, options: [.CurveEaseOut], animations: {
//                left.constant = 0
//                right.constant = 0
//                bottom.constant = 50
//                self.view.layoutIfNeeded()
//                var transform = CATransform3DIdentity
//                transform.m34 = -1/500
//                transform = CATransform3DRotate(transform, CGFloat(-M_PI / 12), 1, 0, 0)
//                fart.layer.transform = transform
//            }, completion: nil)
 
            fart.editAction = {
                self.myTitle = "Lineups"
                self.navController?.updateTitlebar()
                fart.tableView.setEditing(false, animated: true)
                
                UIView.animateWithDuration(0.25, delay: 0, options: [.CurveEaseOut], animations: {
                    
                    left.constant = 26
                    right.constant = -26
                    bottom.constant = -22
                    self.view.layoutIfNeeded()
                    self.downcastedView.collectionView.layer.transform = CATransform3DIdentity
                    self.downcastedView.collectionView.layer.opacity = 1
                    fart.layer.transform = CATransform3DIdentity
 
                }, completion: { _ in
                    cell.lineupView.tableView.contentOffset = fart.tableView.contentOffset
                    fart.removeFromSuperview()
//                    cell.hidden = false
                })
                
            }

//            UIView.animateWithDuration(0.25, animations: {
//                left.constant = 0
//                right.constant = 0
//                bottom.constant = 50
//                self.view.layoutIfNeeded()
//            })
//            [UIView animateWithDuration:0.5 animations:^{[self.view layoutIfNeeded];}];

//            cell.lineupView.tableView.backgroundColor = .purpleColor()
        }
         */
        return cell
    }

    // UICollectionViewDelegateFlowLayout
    
    func collectionView(_: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return lineupListView.cardCollectionView.cardSize
    }
    
}

extension LineupListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_: UIScrollView) {
        lineupListView.cardCollectionView.updateCellTransforms()
    }
}
 
// MARK: -
 
private extension Array {
    subscript (safe index: Int) -> Element? {
        return (0 <= index && index < count) ? self[index] : nil
    }
}

private extension Selector {
//    static let presentDraftGroupPrompt = #selector(LineupListViewController.presentDraftGroupPrompt)
}