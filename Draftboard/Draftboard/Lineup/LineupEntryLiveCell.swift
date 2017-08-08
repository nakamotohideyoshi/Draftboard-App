//
//  LineupEntryLiveCell.swift
//  Draftboard
//
//  Created by devguru on 8/9/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class LineupEntryLiveCell: UITableViewCell {

    let nameLabel = UILabel()
    let posLabel = UILabel()
    let slashLabel = UILabel()
    let winningLabel = UILabel()
    let posBarContainer = UIView()
    let firstHHPosBar = UIView()
    let secondHHPosBar = UIView()
    let borderView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    override func layoutSubviews() {
        var startX = CGFloat(0.0)
        let rangeBarWidth = (bounds.width - 51) / 10
        for subview in posBarContainer.subviews {
            subview.frame = CGRectMake(startX, 0 / 2, rangeBarWidth, 4)
            startX += rangeBarWidth + 4
        }
    }
    
    func setup() {
        addSubviews()
        addConstraints()
        setupSubviews()
    }
    
    func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(posLabel)
        contentView.addSubview(slashLabel)
        contentView.addSubview(winningLabel)
        contentView.addSubview(posBarContainer)
        contentView.addSubview(firstHHPosBar)
        contentView.addSubview(secondHHPosBar)
        contentView.addSubview(borderView)
        for _ in 1...10 {
            let rangeBar = UIView()
            posBarContainer.addSubview(rangeBar)
        }
        
    }
    
    func addConstraints() {
        let firstHHPostBarWidth = (bounds.width - 15) / 2
        
        let viewConstraints: [NSLayoutConstraint] = [
            nameLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 10),
            nameLabel.topRancor.constraintEqualToRancor(contentView.topRancor, constant: 10),
            posLabel.rightRancor.constraintEqualToRancor(slashLabel.leftRancor, constant: -2),
            posLabel.centerYRancor.constraintEqualToRancor(nameLabel.centerYRancor),
            slashLabel.rightRancor.constraintEqualToRancor(winningLabel.leftRancor, constant: -2),
            slashLabel.centerYRancor.constraintEqualToRancor(nameLabel.centerYRancor),
            winningLabel.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -5),
            winningLabel.centerYRancor.constraintEqualToRancor(nameLabel.centerYRancor),
            posBarContainer.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 10),
            posBarContainer.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -5),
            posBarContainer.heightRancor.constraintEqualToConstant(4.0),
            posBarContainer.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -15),
            firstHHPosBar.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 10),
            firstHHPosBar.widthRancor.constraintEqualToConstant(firstHHPostBarWidth),
            firstHHPosBar.heightRancor.constraintEqualToConstant(4.0),
            firstHHPosBar.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -15),
            secondHHPosBar.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -5),
            secondHHPosBar.widthRancor.constraintEqualToConstant(firstHHPostBarWidth),
            secondHHPosBar.heightRancor.constraintEqualToConstant(4.0),
            secondHHPosBar.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -15),
            borderView.heightRancor.constraintEqualToConstant(1.0),
            borderView.widthRancor.constraintEqualToRancor(contentView.widthRancor),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.centerXRancor.constraintEqualToRancor(contentView.centerXRancor),
        ]
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        posLabel.translatesAutoresizingMaskIntoConstraints = false
        slashLabel.translatesAutoresizingMaskIntoConstraints = false
        winningLabel.translatesAutoresizingMaskIntoConstraints = false
        posBarContainer.translatesAutoresizingMaskIntoConstraints = false
        firstHHPosBar.translatesAutoresizingMaskIntoConstraints = false
        secondHHPosBar.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupSubviews() {
        backgroundColor = UIColor(0x37414d)
        
        nameLabel.font = .openSans(size: 12)
        nameLabel.textColor = .whiteColor()
        
        posLabel.font = UIFont.oswald(size: 12)
        posLabel.textColor = .whiteColor()
        posLabel.textAlignment = .Right
        
        slashLabel.font = UIFont.oswald(size: 12)
        slashLabel.textColor = UIColor(0x777d87)
        slashLabel.textAlignment = .Center
        slashLabel.text = "/"
        
        winningLabel.font = UIFont.oswald(size: 12)
        winningLabel.textColor = .whiteColor()
        winningLabel.textAlignment = .Right
        
        for subview in posBarContainer.subviews {
            subview.layer.cornerRadius = 2
            subview.clipsToBounds = true
        }
        
        firstHHPosBar.layer.cornerRadius = 2
        firstHHPosBar.clipsToBounds = true
        
        secondHHPosBar.layer.cornerRadius = 2
        secondHHPosBar.clipsToBounds = true
        
        borderView.backgroundColor = UIColor(0x5f626d)
        
    }

}
