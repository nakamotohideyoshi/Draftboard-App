//
//  LineupDraftGamesView.swift
//  Draftboard
//
//  Created by devguru on 7/10/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDraftGamesView: UIView {
    
    let bgImageView = UIImageView()
    let tableView = LineupDraftGamesTableView()
    
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
        addSubview(bgImageView)
        addSubview(tableView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            bgImageView.topRancor.constraintEqualToRancor(topRancor),
            bgImageView.leftRancor.constraintEqualToRancor(leftRancor),
            bgImageView.rightRancor.constraintEqualToRancor(rightRancor),
            bgImageView.bottomRancor.constraintEqualToRancor(bottomRancor),
            tableView.topRancor.constraintEqualToRancor(topRancor, constant: 56),
            tableView.leftRancor.constraintEqualToRancor(leftRancor, constant: 55),
            tableView.rightRancor.constraintEqualToRancor(rightRancor, constant: -55),
            tableView.bottomRancor.constraintEqualToRancor(bottomRancor, constant: -56),
        ]

        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        backgroundColor = UIColor.clearColor()
        alpha = 0
        
        bgImageView.image = UIImage(named: "games-view-bg")?.resizableImageWithCapInsets(UIEdgeInsetsMake(100, 100, 100, 100), resizingMode: .Stretch)
        bgImageView.contentMode = .ScaleToFill
        
    }
    
    func toggleView() {
        UIView.animateWithDuration(0.3, animations: {
            self.alpha = 1 - self.alpha
        }, completion: { (value: Bool) in
                
        })
    }
}
