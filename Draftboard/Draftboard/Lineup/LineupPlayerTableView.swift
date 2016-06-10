//
//  LineupPlayerTableView.swift
//  Draftboard
//
//  Created by Anson Schall on 5/19/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupPlayerTableView: UITableView, CellAssociation {
    
    typealias Cell = LineupPlayerCell
    
    init() {
        super.init(frame: CGRectZero, style: .Plain)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        rowHeight = 48
        separatorStyle = .None
        registerCellClass()
    }
    
//    func dequeueCellForIndexPath(indexPath: NSIndexPath) -> LineupPlayerCell {
//        return dequeueReusableCellWithIdentifier(LineupPlayerCell.reuseIdentifier, forIndexPath: indexPath) as! LineupPlayerCell
//    }

}

