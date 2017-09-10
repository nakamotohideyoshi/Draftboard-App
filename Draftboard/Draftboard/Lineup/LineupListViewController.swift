//
//  LineupListViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit
import PusherSwift

class LineupListViewController: DraftboardViewController, UIActionSheetDelegate {
    
    var lineupListView: LineupListView { return view as! LineupListView }
    var loaderView: LoaderView { return lineupListView.loaderView }
    var cardCollectionView: LineupCardCollectionView { return lineupListView.cardCollectionView }
    
    var lineups: [LineupWithStart]? { didSet { didSetLineups() } }
    var cardState: [LineupCardCellState] = []
    
    var timer = NSTimer()
    
    override func loadView() {
        view = LineupListView()
    }
    
    override func viewDidLoad() {
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        
        // Hide pagination to start
        lineupListView.paginationHeight.constant = 20.0
        lineupListView.paginationView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        // Reload what's already there
        update()
        // Get lineups
        DerivedData.allLineupsWithStarts().then { lineups -> Void in
            self.lineups = lineups
        }.error { err in
           print("error")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        timer.invalidate()
    }
    
    func didSetLineups() {
        cardState = [LineupCardCellState](count: lineups?.count ?? 0, repeatedValue: LineupCardCellState())
        update()
        timer = NSTimer.scheduledTimerWithTimeInterval(300.0, target: self, selector: #selector(LineupListViewController.updateLineupStats), userInfo: nil, repeats: true)
    }
    
    func update() {
        loaderView.hidden = (lineups != nil)
        loaderView.resumeSpinning()
        cardCollectionView.hidden = (lineups == nil)
        cardCollectionView.reloadData()
        updateSubtitle()
    }
    
    func updateLineupStats() {
        
        let currentPage = Int(self.cardCollectionView.contentOffset.x / self.cardCollectionView.cardSize.width)
        if lineups != nil {
            if self.cardCollectionView.cellForItemAtIndexPath(NSIndexPath.init(forItem: currentPage, inSection: 0)) != nil {
                let currentCell = self.cardCollectionView.cellForItemAtIndexPath(NSIndexPath.init(forItem: currentPage, inSection: 0)) as! LineupCardCell
                currentCell.detailViewController.viewWillAppear(false)
                currentCell.entryViewController.viewWillAppear(false)
            }
        }
        updateSubtitle()
    }
    
    // MARK: - Modals

    func pickDraftGroup() -> Promise<DraftGroup> {
        // Use two modal choice controllers to pick an upcoming draft group
//        return firstly {
//            let mcc = DraftboardModalChoiceController<String>(title: "CHOOSE A SPORT", choices: nil)
//            DerivedData.upcomingSportChoices().then { mcc.choiceData = $0 }
//            return mcc.promise()
//        }.then { (sportName: String) -> Promise<DraftGroup> in
        return firstly { () -> Promise<DraftGroup> in
            let mcc = DraftboardModalChoiceController<DraftGroup>(title: "CHOOSE A START TIME", choices: nil)
            DerivedData.upcomingDraftGroupChoices(self.lineups!).then { mcc.choiceData = $0 }
            mcc.titleText = "Create or Edit Lineups"
            return mcc.promise()
        }.then { draftGroup -> DraftGroup in
            RootViewController.sharedInstance.popModalViewController()
            return draftGroup
        }
    }

    // MARK: - Create/Edit/Contests
    
    func createLineup() {
        pickDraftGroup().then { draftGroup -> Void in
            let vc = LineupDetailViewController()
            let existingLineup = self.lineups!.filter { $0.sportName == draftGroup.sportName && $0.isLive == false }.last
            if (existingLineup != nil) {
                vc.lineup = existingLineup
            } else {
                vc.lineup = LineupWithStart(draftGroup: draftGroup)
            }
            vc.editing = true
            self.navController?.pushViewController(vc)
        }
    }
    
    func editLineup(lineup: LineupWithStart) {
        let vc = LineupDetailViewController()
        vc.lineup = lineup
        vc.editing = true
        self.navController?.pushViewController(vc)
    }
    
    func showPlayer(player: Player, sportName: String) {
        let playerDetailViewController = PlayerDetailViewController()
        playerDetailViewController.sportName = sportName
        playerDetailViewController.player = player
        playerDetailViewController.showAddButton = false
        playerDetailViewController.showRemoveButton = false
        navController?.pushViewController(playerDetailViewController)
    }
// MARK: -

    // DraftboardTitlebarDelegate
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Plus) {
            if lineups != nil {
                createLineup()
            }
        }
    }
    
    // DraftboardTitlebarDatasource
    
    override func titlebarTitle() -> String {
        return "LINEUPS"
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return nil
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType? {
        return .Plus
    }
    
    func updateSubtitle() {
        let currentPage = Int(self.cardCollectionView.contentOffset.x / self.cardCollectionView.cardSize.width)
        let lineup = lineups?[safe: currentPage]
        
        if lineups != nil {
            if lineup == nil {
                self.navController?.titlebar.setSubtitle("No lineups", color: UIColor(0x8f9195))
            } else {
                if lineup?.isLive == true {
                    self.navController?.titlebar.setSubtitle("", color: .clearColor())
                    lineup?.isFinished().then { finished -> Void in
                        if (finished) {
                            self.navController?.titlebar.setSubtitle("Finished", color: UIColor(0x8f9195))
                        } else {
                            self.navController?.titlebar.setSubtitle("Live", color: .greenDraftboard())
                        }
                    }
                } else {
                    self.navController?.titlebar.setSubtitle("Upcoming", color: UIColor(0x8f9195))
                }
            }
        }
    }
}

private typealias ScrollViewDelegate = LineupListViewController
extension ScrollViewDelegate: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == cardCollectionView {
            updateSubtitle()
//            let currentPage = Int(self.cardCollectionView.contentOffset.x / self.cardCollectionView.cardSize.width)
//            let currentCell = self.cardCollectionView.cellForItemAtIndexPath(NSIndexPath.init(forItem: currentPage, inSection: 0)) as! LineupCardCell
//            currentCell.lineup = lineups?[safe: currentPage]
        }
    }
}

private typealias CollectionViewDelegate = LineupListViewController
extension CollectionViewDelegate: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // UICollectionViewDataSource
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // At least one
        return max(1, lineups?.count ?? 0)
    }
    
    func collectionView(_: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = lineupListView.cardCollectionView.dequeueReusableCellForIndexPath(indexPath)
        let lineup = lineups?[safe: indexPath.item]
        
        cell.lineup = lineup
        cell.createAction = { [weak self] in self?.createLineup() }
        cell.entryFlipAction = { [weak cell] in cell?.showDetail() }
        cell.detailFlipAction = { [weak cell] in cell?.showEntry() }
        cell.detailEditAction = (lineup == nil) ? {} : { [weak self] in self?.editLineup(lineup!) }
        cell.showPlayerAction = { player, sportName in self.showPlayer(player, sportName: sportName) }
        if let state = cardState[safe: indexPath.item] { cell.state = state }
        
        return cell
    }
    
    // UICollectionViewDelegate
    
    func collectionView(_: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if lineups?.count ?? 0 != 0 {
            let cell = cell as! LineupCardCell
            cardState[indexPath.item] = cell.state
        }
    }

    // UICollectionViewDelegateFlowLayout
    
    func collectionView(_: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return lineupListView.cardCollectionView.cardSize
    }
    
}

// MARK: -
 
extension Array {
    subscript (safe index: Int) -> Element? {
        return (0 <= index && index < count) ? self[index] : nil
    }
}
