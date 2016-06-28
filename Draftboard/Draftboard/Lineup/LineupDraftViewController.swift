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
    var tableView: UITableView { return lineupDraftView.tableView }
    var searchBar: UISearchBar { return lineupDraftView.searchBar }
    var loaderView: LoaderView { return lineupDraftView.loaderView }
    
//    var pickPlayerAction: ((Player) -> Void)?

    var lineup: Lineup!
    var slot: LineupSlot? { didSet { update() } }
    var allPlayers: [PlayerWithPosition]? { didSet { update() } }
    var players: [PlayerWithPosition]?
    
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
        return nil
    }

}

// MARK: -

private typealias TableViewDelegate = LineupDraftViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players?.count ?? 0
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lineupDraftView.tableView.dequeueCellForIndexPath(indexPath)
        
        let player = players![indexPath.row]
        cell.showAllInfo = true
        cell.showActionButton = .Add
        cell.contentView.alpha = (player.salary <= lineup.totalSalaryRemaining) ? 1.0 : 0.5
        cell.borderView.hidden = (player === players?.last)
        cell.setPlayer(player)
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
