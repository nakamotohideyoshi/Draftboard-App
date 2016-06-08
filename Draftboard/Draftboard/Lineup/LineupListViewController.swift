//
//  LineupListViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class LineupListViewController: DraftboardViewController, UIActionSheetDelegate {
    
    var lineupListView: LineupListView { return view as! LineupListView }
    var lineupDetailViewControllers: [LineupDetailViewController]? { didSet { update() } }
    
    override func loadView() {
        view = LineupListView()
    }
    
    override func viewDidLoad() {
        lineupListView.cardCollectionView.delegate = self
        lineupListView.cardCollectionView.dataSource = self
        
        // Hide pagination to start
        lineupListView.paginationHeight.constant = 20.0
        lineupListView.paginationView.hidden = true
        
        update()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Get lineups
        DerivedData.upcomingLineupsWithStarts().then { lineups in
            self.lineupDetailViewControllers = lineups.map { LineupDetailViewController(lineup: $0) }
        }
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

    func pickDraftGroup() -> Promise<DraftGroup> {
        // Use two modal choice controllers to pick an upcoming draft group
        return firstly {
            let mcc = DraftboardModalChoiceController<String>(title: "CHOOSE A SPORT", choices: nil)
            DerivedData.upcomingSportChoices().then { mcc.choiceData = $0 }
            return mcc.promise()
        }.then { (sportName: String) -> Promise<DraftGroup> in
            let mcc = DraftboardModalChoiceController<DraftGroup>(title: "CHOOSE A START TIME", choices: nil)
            DerivedData.upcomingDraftGroupChoices(sportName: sportName).then { mcc.choiceData = $0 }
            return mcc.promise()
        }.then { draftGroup -> DraftGroup in
            RootViewController.sharedInstance.popModalViewController()
            return draftGroup
        }
    }

    // MARK: - Create/Edit/Contests
    
    func createLineup() {
        // FIXME: push vc immediately, assign lineup on data ready
        pickDraftGroup().then { draftGroup -> Void in
            let lineup = LineupWithStart(draftGroup: draftGroup)
            let vc = LineupDetailViewController(lineup: lineup)
            vc.editing = true
            self.navController?.pushViewController(vc)
        }
    }
    
    func editLineup(lineup: LineupWithStart) {
        let vc = LineupDetailViewController(lineup: lineup)
        vc.editing = true
        self.navController?.pushViewController(vc)
    }

// MARK: -

    // DraftboardTitlebarDelegate
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Plus) {
            createLineup()
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
}

extension LineupListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // UICollectionViewDataSource
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // At least one
        return max(1, lineupDetailViewControllers?.count ?? 0)
    }
    
    func collectionView(_: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = lineupListView.cardCollectionView.dequeueReusableCellForIndexPath(indexPath)
        
        // Draft lineup CTA, alternative to titlebar button
        if cell.createAction == nil {
            cell.createAction = { self.createLineup() }
        }

        // Set lineup
        let vc = lineupDetailViewControllers?[safe: indexPath.row]
        cell.lineupDetailView = vc?.lineupDetailView
        
        // Edit lineup action
        if let detailView = vc?.lineupDetailView, lineup = vc?.lineup {
            detailView.editAction = {
                self.editLineup(lineup)
            }
        }
        
        // Flip card action
        
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
 
extension Array {
    subscript (safe index: Int) -> Element? {
        return (0 <= index && index < count) ? self[index] : nil
    }
}