//
//  LineupEntryStandingCell.swift
//  Draftboard
//
//  Created by devguru on 8/25/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class LineupEntryStandingCell: UITableViewCell {
    
    let rankLabel = UILabel()
    let usernameLabel = UILabel()
    let winningsLabel = UILabel()
    let pointsLabel = UILabel()
    let pmrLabel = UILabel()
    let dividerView = UIView()
    let borderView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        addSubviews()
        addConstraints()
        setupSubviews()
    }
    
    func addSubviews() {
        contentView.addSubview(rankLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(winningsLabel)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(pmrLabel)
        contentView.addSubview(dividerView)
        contentView.addSubview(borderView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            rankLabel.leftRancor.constraintEqualToRancor(leftRancor, constant: 10),
            rankLabel.centerYRancor.constraintEqualToRancor(centerYRancor),
            usernameLabel.leftRancor.constraintEqualToRancor(leftRancor, constant: 25),
            usernameLabel.centerYRancor.constraintEqualToRancor(centerYRancor),
            winningsLabel.rightRancor.constraintEqualToRancor(rightRancor, constant: -123),
            winningsLabel.centerYRancor.constraintEqualToRancor(centerYRancor),
            pointsLabel.rightRancor.constraintEqualToRancor(rightRancor, constant: -60),
            pointsLabel.centerYRancor.constraintEqualToRancor(centerYRancor),
            pmrLabel.rightRancor.constraintEqualToRancor(rightRancor, constant: -12),
            pmrLabel.centerYRancor.constraintEqualToRancor(centerYRancor),
            dividerView.leftRancor.constraintEqualToRancor(leftRancor, constant: 5),
            dividerView.rightRancor.constraintEqualToRancor(rightRancor, constant: -5),
            dividerView.heightRancor.constraintEqualToConstant(1),
            dividerView.bottomRancor.constraintEqualToRancor(bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(1.0),
            borderView.widthRancor.constraintEqualToRancor(contentView.widthRancor),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.centerXRancor.constraintEqualToRancor(contentView.centerXRancor),
        ]
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        winningsLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        pmrLabel.translatesAutoresizingMaskIntoConstraints = false
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupSubviews() {
        backgroundColor = .clearColor()
        
        rankLabel.font = .oswald(size: 9)
        rankLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        
        usernameLabel.font = .openSans(size: 10)
        usernameLabel.textColor = .whiteColor()
        
        winningsLabel.font = .oswald(size: 10)
        winningsLabel.textColor = .greenDraftboard()
        
        dividerView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        
        borderView.backgroundColor = UIColor(0x5f626d)
    }
}
