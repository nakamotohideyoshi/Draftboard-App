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
    let gamesView = LineupDraftGamesView()
    
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
        addSubview(gamesView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            tableView.topRancor.constraintEqualToRancor(topRancor, constant: 76.0),
            tableView.leftRancor.constraintEqualToRancor(leftRancor),
            tableView.rightRancor.constraintEqualToRancor(rightRancor),
            tableView.bottomRancor.constraintEqualToRancor(bottomRancor),
            
            loaderView.widthRancor.constraintEqualToConstant(42.0),
            loaderView.heightRancor.constraintEqualToConstant(42.0),
            loaderView.centerXRancor.constraintEqualToRancor(centerXRancor),
            loaderView.centerYRancor.constraintEqualToRancor(centerYRancor, constant: 36.0),
            
            gamesView.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 1),
            gamesView.centerXRancor.constraintEqualToRancor(centerXRancor, multiplierValue: 1),
            gamesView.topRancor.constraintEqualToRancor(topRancor, constant: 40.0),
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        gamesView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        searchBar.returnKeyType = .Done
        searchBar.frame.size.height = 50
        tableView.tableHeaderView = searchBar
    }
    
}
