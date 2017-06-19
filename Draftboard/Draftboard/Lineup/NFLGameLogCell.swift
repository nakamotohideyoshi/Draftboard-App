//
//  NFLQBGameLogCell.swift
//  Draftboard
//
//  Created by devguru on 6/19/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class NFLGameLogCell: UITableViewCell {
    
    let wrapperView = UIView()
    let dateLabel = DraftboardLabel()
    let oppLabel = DraftboardLabel()
    let recRecLabel = DraftboardLabel()
    let recYdsLabel = DraftboardLabel()
    let recTdLabel = DraftboardLabel()
    let fpLabel = DraftboardLabel()
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
        setupSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(wrapperView)
        wrapperView.addSubview(dateLabel)
        wrapperView.addSubview(oppLabel)
        wrapperView.addSubview(recRecLabel)
        wrapperView.addSubview(recYdsLabel)
        wrapperView.addSubview(recTdLabel)
        wrapperView.addSubview(fpLabel)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        
        dateLabel.font = .openSans(weight: .Semibold, size: 10)
        dateLabel.textColor = UIColor(0x192436)
        dateLabel.letterSpacing = 0.5
        
        oppLabel.font = .openSans(weight: .Semibold, size: 10)
        oppLabel.textColor = UIColor(0x192436)
        oppLabel.letterSpacing = 0.5
        
        recRecLabel.font = .openSans(weight: .Semibold, size: 10)
        recRecLabel.textColor = UIColor(0x192436)
        recRecLabel.letterSpacing = 0.5
        recRecLabel.textAlignment = .Center
        
        recYdsLabel.font = .openSans(weight: .Semibold, size: 10)
        recYdsLabel.textColor = UIColor(0x192436)
        recYdsLabel.letterSpacing = 0.5
        recYdsLabel.textAlignment = .Center
        
        recTdLabel.font = .openSans(weight: .Semibold, size: 10)
        recTdLabel.textColor = UIColor(0x192436)
        recTdLabel.letterSpacing = 0.5
        recTdLabel.textAlignment = .Center
        
        fpLabel.font = .openSans(weight: .Semibold, size: 10)
        fpLabel.textColor = UIColor(0x192436)
        fpLabel.letterSpacing = 0.5
        
        borderView.backgroundColor = UIColor(0xe6e8ed)
    }
    
    func addConstraints() {
        let colWidth = ( UIScreen.mainScreen().bounds.size.width - 190 ) / 3
        let viewConstraints: [NSLayoutConstraint] = [
            wrapperView.centerXRancor.constraintEqualToRancor(centerXRancor),
            wrapperView.topRancor.constraintEqualToRancor(contentView.topRancor),
            wrapperView.widthRancor.constraintEqualToRancor(contentView.widthRancor, multiplier: 1.0, constant: -30),
            wrapperView.heightRancor.constraintEqualToConstant(39),
            wrapperView.bottomRancor.constraintEqualToRancor(borderView.topRancor),
            dateLabel.leftRancor.constraintEqualToRancor(wrapperView.leftRancor, constant: 5),
            dateLabel.widthRancor.constraintEqualToConstant(50),
            dateLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            oppLabel.leftRancor.constraintEqualToRancor(dateLabel.rightRancor),
            oppLabel.widthRancor.constraintEqualToConstant(50),
            oppLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            recRecLabel.widthRancor.constraintEqualToConstant(colWidth),
            recRecLabel.leftRancor.constraintEqualToRancor(oppLabel.rightRancor),
            recRecLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            recYdsLabel.widthRancor.constraintEqualToConstant(colWidth),
            recYdsLabel.leftRancor.constraintEqualToRancor(recRecLabel.rightRancor),
            recYdsLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            recTdLabel.widthRancor.constraintEqualToConstant(colWidth),
            recTdLabel.leftRancor.constraintEqualToRancor(recYdsLabel.rightRancor),
            recTdLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            fpLabel.widthRancor.constraintEqualToConstant(40),
            fpLabel.leftRancor.constraintEqualToRancor(recTdLabel.rightRancor, constant: 10),
            fpLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(fitToPixel(1.0))
        ]
        
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        oppLabel.translatesAutoresizingMaskIntoConstraints = false
        recRecLabel.translatesAutoresizingMaskIntoConstraints = false
        recYdsLabel.translatesAutoresizingMaskIntoConstraints = false
        recTdLabel.translatesAutoresizingMaskIntoConstraints = false
        fpLabel.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
