//
//  ContestListViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 7/26/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class ContestListViewController: DraftboardViewController {
    
    var contestListView: ContestListView { return view as! ContestListView }
    var sportControl: DraftboardSegmentedControl { return contestListView.sportControl }
    var skillControl: DraftboardSegmentedControl { return contestListView.skillControl }
    var tableView: UITableView { return contestListView.tableView }
    var loaderView: LoaderView { return contestListView.loaderView }
    
    var allContests: [Contest]?
    var contests: [Contest]?
    var lineups: [Lineup]?
    var contestLineups: [Int: [Lineup]]?
    var contestEntryCount: [Int: Int]?
    
    override func loadView() {
        self.view = ContestListView()
        tableView.dataSource = self
        tableView.delegate = self
        sportControl.indexChangedHandler = { [weak self] (_: Int) in self?.filterContests() }
        skillControl.indexChangedHandler = { [weak self] (_: Int) in self?.filterContests() }
        update()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Reload what's already there
        tableView.reloadData()
        // Get lineups
        Data.contests.get().then { contests -> Void in
            let contestSports = Set(contests.map { $0.sportName })
            self.sportControl.choices = ["mlb", "nfl", "nba", "nhl"].filter { contestSports.contains($0) }
            self.allContests = contests
            self.filterContests()
            self.update()
        }
        
        when(Data.contests.get(), Data.contestPoolEntries.get()).then { contests, entries -> Void in
            let contestEntries = entries.groupBy { $0.contestPoolID }
            self.allContests = contests.map { $0.withEntries(contestEntries[$0.id] ?? []) }
            self.filterContests()
            self.update()
        }
        
        when(Data.contests.get(), Data.upcomingLineups.get()).then { contests, lineups -> Void in
            let draftGroupLineups = lineups.groupBy { $0.draftGroupID }
            self.contestLineups = contests.transform([Int: [Lineup]]()) { result, contest in
                result[contest.id] = draftGroupLineups[contest.draftGroupID]
                return result
            }
            self.filterContests()
            self.update()
        }
    }
    
    func filterContests() {
        let sportName = sportControl.choices[sportControl.currentIndex]
        let skillLevel = skillControl.choices[skillControl.currentIndex]
        contests = allContests?.filter { $0.sportName == sportName && $0.skillLevelName == skillLevel }
        tableView.reloadData()
    }
    
    func update() {
        loaderView.hidden = (allContests != nil)
        tableView.hidden = (allContests == nil)
        sportControl.hidden = (allContests == nil)
        skillControl.hidden = (allContests == nil)
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return nil
    }
    
    override func titlebarTitle() -> String? {
        return "Contests".uppercaseString
    }
    
}

private typealias TableViewDelegate = ContestListViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate, ContestCellActionButtonDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contests?.count ?? 0
    }

    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = ContestCell()
        let contest = contests?[safe: indexPath.item]
        let eligibleLineups = contestLineups?[contest!.id]

        cell.showBottomBorder = contest !== contests?.last
        cell.enableActionButton = eligibleLineups != nil
        cell.configure(for: contest)
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // ContestCellActionButtonDelegate
    
    func actionButtonTappedForCell(cell: ContestCell) {
        let indexPath = tableView.indexPathForCell(cell)!
        let contest = contests?[safe: indexPath.item]
        // Enter lineup into contest
        
    }

    
}


