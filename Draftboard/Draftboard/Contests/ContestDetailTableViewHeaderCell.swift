//
//  ContestDetailTableViewHeaderCell.swift
//  Draftboard
//
//  Created by devguru on 5/24/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailTableViewHeaderCell: DraftboardTableViewCell {

    let headerView = UIView()
    let leftLabel = DraftboardLabel()
    let rightLabel = DraftboardLabel()
    
    override func setup() {
        addSubviews()
        setupSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(headerView)
        headerView.addSubview(leftLabel)
        headerView.addSubview(rightLabel)
    }
    
    func setupSubviews() {
        headerView.backgroundColor = .greyCool()
        
        leftLabel.font = .openSans(weight: .Semibold, size: 8)
        leftLabel.textColor = .whiteColor()
        leftLabel.letterSpacing = 0.5
        
        rightLabel.font = .openSans(weight: .Semibold, size: 8)
        rightLabel.textColor = .whiteColor()
        rightLabel.letterSpacing = 0.5
        
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            headerView.centerXRancor.constraintEqualToRancor(centerXRancor),
            headerView.bottomRancor.constraintEqualToRancor(bottomRancor),
            headerView.widthRancor.constraintEqualToRancor(contentView.widthRancor, multiplier: 1.0, constant: -30),
            headerView.heightRancor.constraintEqualToConstant(18),
            leftLabel.leftRancor.constraintEqualToRancor(headerView.leftRancor, constant: 5),
            leftLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            rightLabel.rightRancor.constraintEqualToRancor(headerView.rightRancor, constant: -5),
            rightLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
        ]
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }


}
