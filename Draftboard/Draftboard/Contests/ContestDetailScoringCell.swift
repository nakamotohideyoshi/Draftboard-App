//
//  ContestDetailScoringCell.swift
//  Draftboard
//
//  Created by devguru on 5/20/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailScoringCell: DraftboardTableViewCell {
    
    let statNameLabel = DraftboardLabel()
    let pointLabel = DraftboardLabel()
    var score: NSDictionary? {
        didSet {
            setupScore()
        }
    }
    override func setup() {
        addSubviews()
        setupSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(statNameLabel)
        contentView.addSubview(pointLabel)
    }
    
    func setupSubviews() {
        statNameLabel.font = .openSans(size: 15)
        statNameLabel.textColor = UIColor(0x192436)
        statNameLabel.letterSpacing = 0.5
        statNameLabel.textAlignment = .Center
        
        pointLabel.font = .oswald(size: 15)
        pointLabel.textColor = UIColor(0x192436)
        pointLabel.letterSpacing = 0.5
    }
    
    func addConstraints() {
        statNameLabel.translatesAutoresizingMaskIntoConstraints = false
        pointLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let viewConstraints: [NSLayoutConstraint] = [
            statNameLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 20),
            statNameLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            pointLabel.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -20),
            pointLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
        ]
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupScore() {
        let point:Int = ((score!["point"] as? NSNumber)?.integerValue)!
        statNameLabel.text = score!["stat"] as? String
        if point > 0 {
            let value = NSString(format: "%d", point) as String + "pts"
            pointLabel.text = "+" + value
            pointLabel.textColor = UIColor(0x192436)
        } else {
            pointLabel.text = NSString(format: "%d", point) as String + "pts"
            pointLabel.textColor = UIColor(0xe42e2f)
        }
    }
}
