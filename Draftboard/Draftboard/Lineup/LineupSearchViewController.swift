//
//  LineupNewViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupSearchViewController: DraftboardViewController, UITableViewDataSource {
    @IBOutlet weak var remSalaryLabel: DraftboardLabel!
    @IBOutlet weak var avgSalaryLabel: DraftboardLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchCellIdentifier = "searchCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clearColor()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LineupSearchCellView", bundle: bundle)
        
        tableView.registerNib(nib, forCellReuseIdentifier: searchCellIdentifier)
        tableView.separatorStyle = .None
        tableView.dataSource = self
        tableView.backgroundColor = .clearColor()
        tableView.separatorInset = UIEdgeInsetsZero
        
        tableView.setContentOffset(CGPointMake(0, searchBar.bounds.size.height), animated: false)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 32
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(searchCellIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = .clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
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
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Back
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType {
        return .Value
    }
    
    override func titlebarRightButtonText() -> String? {
        return "Save".uppercaseString
    }
    
    override func titlebarBgHidden() -> Bool {
        return false
    }
}
