//
//  LineupDraftSortMenuTableView.swift
//  Draftboard
//
//  Created by devguru on 7/15/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDraftSortMenuTableView: UITableView, CellAssociation {
    
    typealias Cell = LineupDraftSortMenuCell
    
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
        backgroundColor = UIColor.clearColor()
        registerCellClass()
    }
    
}
