//
//  ContestListView.swift
//  Draftboard
//
//  Created by Anson Schall on 7/26/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class ContestListView: DraftboardView {
    
    let sportFilter = UIView()
    let skillFilter = UIView()
    let tableView = UITableView()
    let loaderView = LoaderView()
    let tableFooterView = UIView()
    
    override func setup() {
        super.setup()
        
        // Add subviews
        addSubview(sportFilter)
        addSubview(skillFilter)
        addSubview(tableView)
        addSubview(loaderView)
        
        // Configure subviews
        tableView.backgroundColor = .clearColor()
        tableView.indicatorStyle = .White
        tableView.sectionHeaderHeight = 23
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor.blueDarker().colorWithAlphaComponent(0.5)
        
        sportFilter.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        skillFilter.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.2)
        
        loaderView.thickness = 2.0
        loaderView.spinning = true
    }
    
    override func layoutSubviews() {
        let tabBarHeight = CGFloat(50)
        let filterHeight = CGFloat(50)
        
        sportFilter.frame = CGRectMake(0, 0, bounds.width / 2, filterHeight)
        skillFilter.frame = CGRectMake(bounds.width / 2, 0, bounds.width / 2, filterHeight)
        tableView.frame = CGRectMake(0, filterHeight, bounds.width, bounds.height - filterHeight - tabBarHeight)
        tableView.tableFooterView?.frame.size = tableView.frame.size
        loaderView.frame = CGRectMake(bounds.width / 2 - 42 / 2, bounds.height / 2 - 42 / 2 - tabBarHeight, 42, 42)
    }
    
}
