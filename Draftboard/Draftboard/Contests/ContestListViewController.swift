//
//  ContestListViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 7/26/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class ContestListViewController: DraftboardViewController {
    
    var contestListView: ContestListView { return view as! ContestListView }
    var sportControl: DraftboardSegmentedControl { return contestListView.sportControl }
    var skillControl: DraftboardSegmentedControl { return contestListView.skillControl }
    var tableView: UITableView { return contestListView.tableView }
    var loaderView: LoaderView { return contestListView.loaderView }
    
    var allContests: [Contest]?
    var contests: [Contest]?
    
    override func loadView() {
        self.view = ContestListView()
        tableView.dataSource = self
        tableView.delegate = self
        sportControl.indexChangedHandler = { [weak self] (_: Int) in print("fart 1"); self?.filterContests() }
        skillControl.indexChangedHandler = { [weak self] (_: Int) in print("fart 2"); self?.filterContests() }
    }
    
    override func viewWillAppear(animated: Bool) {
        // Reload what's already there
        tableView.reloadData()
        // Get lineups
        Data.contests.get().then { contests -> Void in
            self.allContests = contests
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
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return nil
    }
    
    override func titlebarTitle() -> String? {
        return "Contests".uppercaseString
    }
    
}

private typealias TableViewDelegate = ContestListViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contests?.count ?? 0
    }

    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let contest = contests?[safe: indexPath.item]
        
        cell.backgroundColor = .clearColor()
        cell.textLabel?.font = .openSans(size: 13)
        cell.textLabel?.textColor = .whiteColor()
        cell.textLabel?.text = contest?.name
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
