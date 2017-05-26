//
//  ContestDetailEntryCell.swift
//  Draftboard
//
//  Created by devguru on 5/25/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailEntryCell: DraftboardTableViewCell {

    let usernameLabel = DraftboardLabel()
    let borderView = UIView()
    
    override func setup() {
        addSubviews()
        setupSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(usernameLabel)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        usernameLabel.font = .openSans(weight: .Semibold, size: 13)
        usernameLabel.textColor = UIColor(0x192436)
        usernameLabel.letterSpacing = 0.5
        usernameLabel.textAlignment = .Center
        
        borderView.backgroundColor = UIColor(0xe6e8ed)
    }
    
    func addConstraints() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewConstraints: [NSLayoutConstraint] = [
            usernameLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 20),
            usernameLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(fitToPixel(1.0))
        ]
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
