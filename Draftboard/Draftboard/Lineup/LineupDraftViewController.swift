//
//  LineupDraftViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 6/10/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDraftViewController: DraftboardViewController {
    

    var lineupDraftView: LineupDraftView { return view as! LineupDraftView }
    var tableView: LineupPlayerTableView { return lineupDraftView.tableView }
    var searchBar: UISearchBar { return lineupDraftView.searchBar }
    var loaderView: LoaderView { return lineupDraftView.loaderView }
    
//    var pickPlayerAction: ((Player) -> Void)?

    var lineup: Lineup!
    var slot: LineupSlot? { didSet { update() } }
    var allPlayers: [PlayerWithPosition]? { didSet { update() } }
    var players: [PlayerWithPosition]?
    
    var scrollingToSearchBar: Bool = false
    
    override func loadView() {
        self.view = LineupDraftView()
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        update()
    }
    
    override func viewWillAppear(animated: Bool) {
        update()
        scrollToFirstAffordablePlayer()
    }
    
    func update() {
        if !isViewLoaded() { return }
        
        loaderView.hidden = (allPlayers != nil)
        tableView.hidden = (allPlayers == nil)
        
        let okPositions = Set(slot!.positions)
        let draftedPlayers = Set(lineup.filledSlots.map { $0.player! })
        let searchPattern = searchBar.text?.searchPattern ?? ""
        players = allPlayers?.filter {
            if draftedPlayers.contains($0) { return false }
            if !okPositions.contains($0.position) { return false }
            if !$0.name.matchesSearchPattern(searchPattern) { return false }
            return true
        }
        tableView.reloadData()
    }
    
    func scrollToFirstAffordablePlayer() {
        guard let players = self.players else { return }

        let index = players.indexOf { $0.salary <= lineup.totalSalaryRemaining } ?? (players.count - 1)
        let row = max(index - 1, 0)
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
        tableView.flashScrollIndicators()
    }

    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if buttonType == .Back {
            searchBar.text = nil
            navController?.popViewController()
        }
        if buttonType == .Search {
            // See scrollViewDidEndScrollingAnimation where searchBar becomes firstResponder
            scrollingToSearchBar = true
            tableView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }

    // DraftboardTitlebarDatasource
    
    override func titlebarTitle() -> String {
        let slotName = slot?.description ?? "Player"
        return "Select \(slotName)".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Back
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType? {
        return .Search
    }

}

// MARK: -

private typealias TableViewDelegate = LineupDraftViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate, LineupPlayerCellActionButtonDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players?.count ?? 0
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lineupDraftView.tableView.dequeueCellForIndexPath(indexPath)
        
        let player = players![indexPath.row]
        cell.showAllInfo = true
        cell.showAddButton = true
        cell.contentView.alpha = (player.salary <= lineup.totalSalaryRemaining) ? 1.0 : 0.5
        cell.showBottomBorder = player !== players?.last
        cell.actionButtonDelegate = self
        cell.setPlayer(player)
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // LineupPlayerCellActionButtonDelegate
    
    func actionButtonTappedForCell(cell: LineupPlayerCell) {
        let indexPath = tableView.indexPathForCell(cell)!
        slot?.player = players?[indexPath.row]
        searchBar.text = nil
        navController?.popViewController()
    }
    
}

private typealias ScrollViewDelegate = LineupDraftViewController
extension ScrollViewDelegate: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_: UIScrollView) {
        if (tableView.contentOffset.y >= searchBar.frame.size.height) && searchBar.isFirstResponder() {
            searchBar.resignFirstResponder()
        }
    }

    func scrollViewDidEndScrollingAnimation(_: UIScrollView) {
        if (tableView.contentOffset.y == 0) && scrollingToSearchBar && !searchBar.isFirstResponder() {
            searchBar.becomeFirstResponder()
        }
        scrollingToSearchBar = false
    }
    
}


private typealias SearchBarDelegate = LineupDraftViewController
extension SearchBarDelegate: UISearchBarDelegate {
    
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        update()
    }
    
}

private extension String {
    
    var searchString: String {
        return lowercaseString.stringByReplacingOccurrencesOfString("[^a-z ]", withString: "", options: .RegularExpressionSearch)
    }
    
    var searchPattern: String {
        guard characters.count > 0 else { return "" }
        return searchString.stringByReplacingOccurrencesOfString("^| +", withString: ".*\\\\b", options: .RegularExpressionSearch)
    }
    
    func matchesSearchPattern(pattern: String) -> Bool {
        guard pattern.characters.count > 0 else { return true }
        return searchString.rangeOfString(pattern, options: .RegularExpressionSearch) != nil
    }
    
}
