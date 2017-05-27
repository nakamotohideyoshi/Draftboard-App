//
//  ContestDetailGDescriptionCell.swift
//  Draftboard
//
//  Created by devguru on 5/27/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailGDescriptionCell: DraftboardTableViewCell {

    let descriptionLabel = DraftboardLabel()
    
    let borderView = UIView()
    
    override func setup() {
        addSubviews()
        setupSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(descriptionLabel)
        
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        descriptionLabel.font = .openSans(weight: .Semibold, size: 10)
        descriptionLabel.textColor = UIColor(0x262a3b)
        descriptionLabel.letterSpacing = 0.5
        descriptionLabel.textAlignment = .Left
        descriptionLabel.numberOfLines = 0
        let desc = NSMutableAttributedString(string: " G   Your first entry is guaranteed to be placed in a contest.\n G   Subsequent entries are not guaranteed.\n G   Any entries not placed in contests will be refunded.")
        desc.addAttribute(NSBackgroundColorAttributeName, value: UIColor.greenDraftboard(), range: NSMakeRange(0, 3))
        desc.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, 3))
        desc.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(NSString(string: " G   Your first entry is guaranteed to be placed in a contest.").length, 3))
        desc.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(NSString(string: " G   Your first entry is guaranteed to be placed in a contest.").length + NSString(string: " G   Subsequent entries are not guaranteed.").length + 1, 6))
        descriptionLabel.attributedText = desc
        
        borderView.backgroundColor = UIColor(0xe6e8ed)
    }
    
    func addConstraints() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewConstraints: [NSLayoutConstraint] = [
            descriptionLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 20),
            descriptionLabel.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -20),
            descriptionLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(fitToPixel(1.0))
        ]
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
