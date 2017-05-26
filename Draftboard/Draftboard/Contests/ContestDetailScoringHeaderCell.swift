//
//  ContestDetailScoringHeaderCell.swift
//  Draftboard
//
//  Created by devguru on 5/24/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailScoringHeaderCell: DraftboardTableViewCell {

    let titleLabel = DraftboardLabel()
    let borderView = UIView()
    
    override func setup() {
        addSubviews()
        setupSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        titleLabel.font = .openSans(weight: .Semibold, size: 9)
        titleLabel.textColor = UIColor(0x192436).colorWithAlphaComponent(0.6)
        titleLabel.letterSpacing = 0.5
        titleLabel.textAlignment = .Center
        
        borderView.backgroundColor = UIColor(0xe6e8ed)
    }
    
    func addConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewConstraints: [NSLayoutConstraint] = [
            titleLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 20),
            titleLabel.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -9),
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(fitToPixel(1.0))
        ]
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
