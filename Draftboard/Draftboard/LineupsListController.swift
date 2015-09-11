//
//  LineupsListController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupsListController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    let tableView = UITableView()
    var lineups : [UIViewController] = []
    
    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        
        // Properties for navigation
        self.title = "Lineups"
        let filterButton = UIBarButtonItem(title: "Sport: All", style: .Plain, target: self, action: "filterLineups")
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addLineup")
        self.navigationItem.leftBarButtonItem = filterButton
        self.navigationItem.rightBarButtonItem = addButton
        
        // Scrollview
        self.tableView.frame = self.view.bounds
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.pagingEnabled = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        
        self.addLineup()
    }
    
    func filterLineups() {
        let sheet = UIActionSheet()
        sheet.title = "Filter by sport:"
        sheet.delegate = self
        var options = ["All sports", "NBA", "NFL"]
//        options.enumerate()
        for (i, option) in options.enumerate() {
            let selected = (i == 0)
            let title = (selected ? "    " + option + " ✔︎" : option)
            sheet.addButtonWithTitle(title)
        }
        sheet.showInView(self.view)
    }
    
    func addLineup() {
        self.lineups.append(LineupsDetailController())
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lineups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = "Lineup name"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.lineups[indexPath.row]
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
