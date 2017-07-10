//
//  LineupDraftGamesTableView.swift
//  Draftboard
//
//  Created by devguru on 7/11/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDraftGamesTableView: UITableView, CellAssociation {
    
    typealias Cell = LineupDraftGameCell
    
    init() {
        super.init(frame: CGRectZero, style: .Plain)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        rowHeight = 72
        separatorStyle = .None
        backgroundColor = UIColor.clearColor()
        registerCellClass()
    }
    
}
