//
//  LineupPlayerTableView.swift
//  Draftboard
//
//  Created by Anson Schall on 5/19/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupPlayerTableView: UITableView {
    
    init() {
        super.init(frame: CGRectZero, style: .Plain)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        allowsSelection = false
        contentInset = UIEdgeInsetsMake(68, 0, 68, 0)
        contentOffset = CGPointMake(0, -68)
        rowHeight = 44
        scrollIndicatorInsets = contentInset
        separatorStyle = .None

        registerClass(LineupPlayerCell.self, forCellReuseIdentifier: LineupPlayerCell.reuseIdentifier)
    }
    
    func dequeueCellForIndexPath(indexPath: NSIndexPath) -> LineupPlayerCell {
        return dequeueReusableCellWithIdentifier(LineupPlayerCell.reuseIdentifier, forIndexPath: indexPath) as! LineupPlayerCell
    }

}