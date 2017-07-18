//
//  LineupDraftSortMenuCell.swift
//  Draftboard
//
//  Created by devguru on 7/15/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDraftSortMenuCell: UITableViewCell {

    let optionLabel = DraftboardLabel()
    let iconCheck = UIImageView()
    
    let borderView = UIView()
    
    var selectedOption: Bool = false { didSet { toggleIconCheck() } }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        addSubviews()
        setupSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(optionLabel)
        contentView.addSubview(iconCheck)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        optionLabel.font = UIFont.openSans(weight: .Semibold, size: 9)
        optionLabel.textColor = UIColor.whiteColor()
        optionLabel.letterSpacing = 0.5
        
        iconCheck.image = UIImage(named: "icon-check")
        iconCheck.contentMode = .ScaleAspectFit
        iconCheck.hidden = !selectedOption
        
        borderView.backgroundColor = UIColor(0x5c656f)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            optionLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 20),
            optionLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            iconCheck.widthRancor.constraintEqualToConstant(12),
            iconCheck.heightRancor.constraintEqualToConstant(10),
            iconCheck.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            iconCheck.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -20),
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 10),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -10),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(1),
        ]
        
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        iconCheck.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func toggleIconCheck() {
        iconCheck.hidden = !selectedOption
    }
}
