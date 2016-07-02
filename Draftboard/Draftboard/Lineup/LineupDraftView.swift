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
    let searchBar = UISearchBar()
    let loaderView = LoaderView()

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
        addSubview(loaderView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            tableView.topRancor.constraintEqualToRancor(topRancor),
            tableView.leftRancor.constraintEqualToRancor(leftRancor),
            tableView.rightRancor.constraintEqualToRancor(rightRancor),
            tableView.bottomRancor.constraintEqualToRancor(bottomRancor),
            
            loaderView.widthRancor.constraintEqualToConstant(42.0),
            loaderView.heightRancor.constraintEqualToConstant(42.0),
            loaderView.centerXRancor.constraintEqualToRancor(centerXRancor),
            loaderView.centerYRancor.constraintEqualToRancor(centerYRancor),
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        searchBar.returnKeyType = .Done
        searchBar.frame.size.height = 50
        tableView.tableHeaderView = searchBar
    }
    
}
