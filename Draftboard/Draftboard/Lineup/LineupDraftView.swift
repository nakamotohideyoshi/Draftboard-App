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
    let filterView = LineupDraftFilterView()
    let gamesView = LineupDraftGamesView()
    let sortView = LineupDraftSortMenuView()
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
        addSubview(filterView)
        addSubview(gamesView)
        addSubview(sortView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            filterView.topRancor.constraintEqualToRancor(topRancor, constant: 76.0),
            filterView.leftRancor.constraintEqualToRancor(leftRancor),
            filterView.rightRancor.constraintEqualToRancor(rightRancor),
            filterView.heightRancor.constraintEqualToConstant(25.0),
            tableView.topRancor.constraintEqualToRancor(filterView.bottomRancor),
            tableView.leftRancor.constraintEqualToRancor(leftRancor),
            tableView.rightRancor.constraintEqualToRancor(rightRancor),
            tableView.bottomRancor.constraintEqualToRancor(bottomRancor),
            
            loaderView.widthRancor.constraintEqualToConstant(42.0),
            loaderView.heightRancor.constraintEqualToConstant(42.0),
            loaderView.centerXRancor.constraintEqualToRancor(centerXRancor),
            loaderView.centerYRancor.constraintEqualToRancor(centerYRancor, constant: 36.0),
            
            gamesView.leftRancor.constraintEqualToRancor(leftRancor),
            gamesView.topRancor.constraintEqualToRancor(topRancor),
            gamesView.rightRancor.constraintEqualToRancor(rightRancor),
            gamesView.bottomRancor.constraintEqualToRancor(bottomRancor),
            
            sortView.leftRancor.constraintEqualToRancor(leftRancor),
            sortView.topRancor.constraintEqualToRancor(topRancor),
            sortView.rightRancor.constraintEqualToRancor(rightRancor),
            sortView.bottomRancor.constraintEqualToRancor(bottomRancor),
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        gamesView.translatesAutoresizingMaskIntoConstraints = false
        filterView.translatesAutoresizingMaskIntoConstraints = false
        sortView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        searchBar.returnKeyType = .Done
        searchBar.frame.size.height = 50
        tableView.tableHeaderView = searchBar
    }
    
}
