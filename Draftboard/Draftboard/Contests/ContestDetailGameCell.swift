//
//  ContestDetailGameCell.swift
//  Draftboard
//
//  Created by devguru on 5/24/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailGameCell: DraftboardTableViewCell {

    let teamLabel = DraftboardLabel()
    let timeLabel = DraftboardLabel()
    let borderView = UIView()
    
    var game: Game? {
        didSet {
            setupGame()
        }
    }
    override func setup() {
        addSubviews()
        setupSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(teamLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        teamLabel.font = .openSans(weight: .Semibold, size: 13)
        teamLabel.textColor = UIColor(0x192436)
        teamLabel.letterSpacing = 0.5
        teamLabel.textAlignment = .Center
        
        timeLabel.font = .openSans(size: 13)
        timeLabel.textColor = UIColor(0x192436).colorWithAlphaComponent(0.56)
        timeLabel.letterSpacing = 0.5
        
        borderView.backgroundColor = UIColor(0xe6e8ed)
    }
    
    func addConstraints() {
        teamLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewConstraints: [NSLayoutConstraint] = [
            teamLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 20),
            teamLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            timeLabel.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -20),
            timeLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(fitToPixel(1.0))
        ]
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupGame() {
        teamLabel.text = (game?.away.alias)! + " @ " + (game?.home.alias)!
        
        let df = NSDateFormatter()
        df.dateFormat = "h:mm a"
        timeLabel.text = df.stringFromDate(game!.start)
    }
}
