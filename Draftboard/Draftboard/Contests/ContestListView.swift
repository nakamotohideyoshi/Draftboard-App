//
//  ContestListView.swift
//  Draftboard
//
//  Created by Anson Schall on 7/26/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class ContestListView: DraftboardView {
    
    let sportControl = DraftboardSegmentedControl(choices: ["mlb", "nfl"], textColor: .greyCool(), textSelectedColor: .whiteColor())
    let skillControl = DraftboardSegmentedControl(choices: ["rookie", "veteran"], textColor: .greyCool(), textSelectedColor: .whiteColor())
    let tableView = UITableView()
    let loaderView = LoaderView()
    
    override func setup() {
        super.setup()
        
        // Add subviews
        addSubview(sportControl)
        addSubview(skillControl)
        addSubview(tableView)
        addSubview(loaderView)
        
        // Configure subviews
        tableView.backgroundColor = UIColor.blueDarker().colorWithAlphaComponent(0.5)
        tableView.indicatorStyle = .White
        tableView.rowHeight = 66
        tableView.separatorStyle = .None
        
        loaderView.thickness = 2.0
        loaderView.spinning = true
    }
    
    override func layoutSubviews() {
        let titleBarHeight = CGFloat(76)
        let tabBarHeight = CGFloat(50)
        let filterHeight = CGFloat(50)
        
        sportControl.frame = CGRectMake(0, titleBarHeight, bounds.width / 3, filterHeight)
        skillControl.frame = CGRectMake(bounds.width / 2, titleBarHeight, bounds.width / 2, filterHeight)
        tableView.frame = CGRectMake(0, titleBarHeight + filterHeight, bounds.width, bounds.height - titleBarHeight - filterHeight - tabBarHeight)
        loaderView.frame = CGRectMake(bounds.width / 2 - 42 / 2, titleBarHeight / 2 + bounds.height / 2 - 42 / 2 - tabBarHeight, 42, 42)
    }
    
}
