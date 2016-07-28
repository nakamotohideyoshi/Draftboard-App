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
    var sportFilter: UIView { return contestListView.sportFilter }
    var skillFilter: UIView { return contestListView.skillFilter }
    var tableView: UITableView { return contestListView.tableView }
    var loaderView: LoaderView { return contestListView.loaderView }
    
    var contests: [Contest]? { didSet { didSetContests() } }
    
    override func loadView() {
        self.view = ContestListView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        // Reload what's already there
        tableView.reloadData()
        // Get lineups
        Data.contests.get().then { contests -> Void in
            self.contests = contests
        }
    }
    
    func didSetContests() {
        update()
    }
    
    func update() {
        loaderView.hidden = (contests != nil)
        tableView.hidden = (contests == nil)
        tableView.reloadData()
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

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        headerView.addSubview(headerLabel)

        headerView.frame = CGRectMake(0, 0, tableView.frame.width, tableView.sectionHeaderHeight)
        headerView.backgroundColor = .greyCool()
        
        headerLabel.frame = headerView.bounds
        headerLabel.textAlignment = .Center
        headerLabel.textColor = .whiteColor()
        headerLabel.font = .openSans(weight: .Semibold, size: 10)
        headerLabel.text = "Contest Header".uppercaseString

        return headerView
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let contest = contests?[safe: indexPath.item]
        
        cell.backgroundColor = UIColor.blueDarker().colorWithAlphaComponent(0.5)
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

private typealias ScrollViewDelegate = ContestListViewController
extension ScrollViewDelegate: UIScrollViewDelegate {
    func scrollViewDidScroll(_: UIScrollView) {
        if tableView.contentOffset.y < 0 {
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-tableView.contentOffset.y, 0, 0, 0)
        } else {
            tableView.scrollIndicatorInsets = UIEdgeInsetsZero
        }
    }
}

