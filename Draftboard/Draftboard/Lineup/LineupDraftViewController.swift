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

    var slot: LineupSlot? {
        didSet {
            players = allPlayers?.filter { slot?.positions.contains($0.position) ?? false }
            tableView.reloadData()
        }
    }
    var allPlayers: [PlayerWithPosition]?
    var players: [PlayerWithPosition]?
    
    override func loadView() {
        self.view = LineupDraftView()
    }
    
    override func viewDidLoad() {
        
        // Players
        tableView.delegate = self
        tableView.dataSource = self

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
        
        if let player = players?[indexPath.row] {
            cell.setPlayer(player)
            cell.borderView.hidden = (slot === players?.last)
        }
        
        return cell
    }
    
    // UITableViewDelegate
    
}
