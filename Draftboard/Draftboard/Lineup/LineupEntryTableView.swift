//
//  LineupEntryTableView.swift
//  Draftboard
//
//  Created by devguru on 8/8/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class LineupEntryTableView: UITableView {

    init() {
        super.init(frame: CGRectZero, style: .Plain)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        rowHeight = 40
        separatorStyle = .None
        backgroundColor = UIColor(0x37414d)
        
        registerClass(LineupEntryUpcomingCell.self, forCellReuseIdentifier: String(LineupEntryUpcomingCell))
    }

}
