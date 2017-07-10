//
//  LineupDraftViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 6/10/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDraftViewController: DraftboardViewController {
    
    override var overlapsTabBar: Bool { return true }

    var lineupDraftView: LineupDraftView { return view as! LineupDraftView }
    var tableView: LineupPlayerTableView { return lineupDraftView.tableView }
    var searchBar: UISearchBar { return lineupDraftView.searchBar }
    var loaderView: LoaderView { return lineupDraftView.loaderView }
    var gamesView: LineupDraftGamesView { return lineupDraftView.gamesView }
    var gamesTableView: LineupDraftGamesTableView { return gamesView.tableView }
    var gamesViewHeight: NSLayoutConstraint!
//    var pickPlayerAction: ((Player) -> Void)?

    var lineup: Lineup!
    var slot: LineupSlot? { didSet { update() } }
    var allPlayers: [PlayerWithPosition]? { didSet { update() } }
    var players: [PlayerWithPosition]?
    var games: [Game]?
    var selectedGame: Game?
    
    var scrollingToSearchBar: Bool = false
    
    override func loadView() {
        self.view = LineupDraftView()
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
        searchBar.delegate = self
        update()
    }
    
    override func viewWillAppear(animated: Bool) {
        searchBar.text = nil
        update()
        scrollToFirstAffordablePlayer()
        DerivedData.games(sportName: lineup.sportName, draftGroupID: lineup.draftGroupID).then { games -> Void in
            self.games = games
            let cellCount = min(5, games.count)
            self.gamesViewHeight = self.gamesView.heightRancor.constraintEqualToConstant(165 + CGFloat(cellCount * 72))
            self.gamesViewHeight.active = true
            self.gamesTableView.reloadData()
        }
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
            if selectedGame != nil && ($0 as? HasGame)?.game.srid != selectedGame?.srid { return false }
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
            searchBar.resignFirstResponder()
            navController?.popViewController()
        }
        if buttonType == .Search {
            // See scrollViewDidEndScrollingAnimation where searchBar becomes firstResponder
            if (tableView.contentOffset.y == 0) && !searchBar.isFirstResponder() {
                searchBar.becomeFirstResponder()
                return
            }
            if scrollingToSearchBar {
                return
            }
            scrollingToSearchBar = true
            tableView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    override func didTapSubtitle() {
        gamesView.hidden = !gamesView.hidden
    }

    // DraftboardTitlebarDatasource
    
    override func titlebarTitle() -> String {
        let slotName = slot?.description ?? "Player"
        return "Select \(slotName)".uppercaseString
    }
    
    override func titlebarSubtitle() -> String? {
        return "All Games".uppercaseString
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
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate, PlayerDetailDraftButtonDelegate {
    
    // UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView === gamesTableView) {
            if games == nil {
                return 0
            } else {
                return games!.count + 1
            }
        } else {
            return players?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView === gamesTableView {
            if indexPath.row == 0 {
                return 53
            } else {
                return 72
            }
        } else {
            return 48
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView === gamesTableView) {
            let cell = gamesTableView.dequeueCellForIndexPath(indexPath)
            
            let game = indexPath.row == 0 ? nil : games![safe: indexPath.row - 1]
            cell.setGame(game)
            if indexPath.row == 0 {
                cell.selectedGame = selectedGame === nil
            } else {
                cell.selectedGame = selectedGame === game
            }
            
            
            return cell
        } else {
            let cell = lineupDraftView.tableView.dequeueCellForIndexPath(indexPath)
            
            let player = players![indexPath.row]
            cell.showAllInfo = true
            cell.showAddButton = true
            cell.showBottomBorder = player !== players?.last
            cell.actionButtonDelegate = self
            cell.withinBudget = (player.salary <= lineup.totalSalaryRemaining)
            cell.setPlayer(player)
            
            return cell
        }
    }
    
    // UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView === gamesTableView {
            selectedGame = indexPath.row == 0 ? nil : games![safe: indexPath.row - 1]
            gamesTableView.reloadData()
            gamesView.hidden = !gamesView.hidden
            update()
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            if let player = players?[indexPath.row] {
                let playerDetailViewController = PlayerDetailViewController()
                playerDetailViewController.sportName = lineup?.sportName
                playerDetailViewController.player = player
                playerDetailViewController.showAddButton = true
                playerDetailViewController.indexPath = indexPath
                playerDetailViewController.draftButtonDelegate = self
                self.navController?.pushViewController(playerDetailViewController)
            }
        }
    }
    
    func draftButtonTapped(indexPath: NSIndexPath) {
        slot?.player = players?[indexPath.row]
        searchBar.resignFirstResponder()
        navController?.popViewController()
        navController?.popViewController()
    }
}

private typealias ActionButtonDelegate = LineupDraftViewController
extension ActionButtonDelegate: LineupPlayerCellActionButtonDelegate {

    // LineupPlayerCellActionButtonDelegate
    
    func actionButtonTappedForCell(cell: LineupPlayerCell) {
        let indexPath = tableView.indexPathForCell(cell)!
        slot?.player = players?[indexPath.row]
        searchBar.resignFirstResponder()
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
    
    func scrollViewDidEndDragging(_: UIScrollView, willDecelerate decelerate: Bool) {
        scrollingToSearchBar = false
    }
    
}


private typealias SearchBarDelegate = LineupDraftViewController
extension SearchBarDelegate: UISearchBarDelegate {
    
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        update()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
