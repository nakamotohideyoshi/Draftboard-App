//
//  LineupDraftView.swift
//  Draftboard
//
//  Created by Anson Schall on 6/10/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDraftView: UIView {
    
    let tableView = LineupPlayerTableView()
    
    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    override convenience init(frame: CGRect) {
        self.init()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        addSubviews()
        addConstraints()
        otherSetup()
    }
    
    func addSubviews() {
        addSubview(tableView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            tableView.topRancor.constraintEqualToRancor(topRancor),
            tableView.leftRancor.constraintEqualToRancor(leftRancor),
            tableView.rightRancor.constraintEqualToRancor(rightRancor),
            tableView.bottomRancor.constraintEqualToRancor(bottomRancor),
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
//        tableView.backgroundColor = .whiteColor()
    }
    
}
