//
//  LineupNewViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupSearchViewController: DraftboardViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var remSalaryLabel: DraftboardLabel!
    @IBOutlet weak var avgSalaryLabel: DraftboardLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchCellIdentifier = "searchCellIdentifier"
    var playerSelectedAction:((Player) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clearColor()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LineupSearchCellView", bundle: bundle)
        
        tableView.registerNib(nib, forCellReuseIdentifier: searchCellIdentifier)
        tableView.separatorStyle = .None
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clearColor()
        tableView.separatorInset = UIEdgeInsetsZero
        
        tableView.setContentOffset(CGPointMake(0, searchBar.bounds.size.height), animated: false)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let player = Player(data: [
            "first_name": "Steven",
            "last_name": "Adams",
            "id": 2,
            "team_id": 2
        ])
        
        playerSelectedAction?(player)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 32
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(searchCellIdentifier, forIndexPath: indexPath) as! LineupSearchCellView
        cell.infoButton.addTarget(self, action: Selector("didTapPlayerInfo:"), forControlEvents: .TouchUpInside)
        cell.backgroundColor = .clearColor()
        return cell
    }
    
    func didTapPlayerInfo(sender: DraftboardButton) {
        let pdvc = PlayerDetailViewController(nibName: "PlayerDetailViewController", bundle: nil)
        self.navController?.pushViewController(pdvc)
    }
    
    override func titlebarTitle() -> String? {
        return "Search".uppercaseString
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Value) {
            navController?.popViewController()
        }
        else if(buttonType == .Back) {
            navController?.popViewController()
        }
        else if (buttonType == .Search) {
            self.tableView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Back
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType {
        return .Search
    }
    
    override func titlebarBgHidden() -> Bool {
        return false
    }
}
