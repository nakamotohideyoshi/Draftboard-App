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
        // Players
        tableView.delegate = self
        tableView.dataSource = self
        update()
    }
    
    func update() {
        loaderView.hidden = (allPlayers != nil)
        tableView.hidden = (allPlayers == nil)
        players = allPlayers?.filter { slot?.positions.contains($0.position) ?? false }
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
        
        cell.showAllInfo = true
        
        if let player = players?[indexPath.row] {
            cell.setPlayer(player)
            cell.contentView.alpha = (player.salary <= lineup.totalSalaryRemaining) ? 1.0 : 0.5
            cell.borderView.hidden = (player === players?.last)
        }
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        slot?.player = players?[indexPath.row]
        navController?.popViewController()
//        if let player = players?[indexPath.row] {
//            pickPlayerAction?(player)
//        }
    }
}
