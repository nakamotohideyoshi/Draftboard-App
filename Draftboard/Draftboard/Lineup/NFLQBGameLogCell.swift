//
//  NFLQBGameLogCell.swift
//  Draftboard
//
//  Created by devguru on 6/19/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class NFLQBGameLogCell: UITableViewCell {
    
    let wrapperView = UIView()
    let dateLabel = DraftboardLabel()
    let oppLabel = DraftboardLabel()
    let passYdsLabel = DraftboardLabel()
    let passTdLabel = DraftboardLabel()
    let passIntLabel = DraftboardLabel()
    let rushYdsLabel = DraftboardLabel()
    let rushTdLabel = DraftboardLabel()
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
        wrapperView.addSubview(passYdsLabel)
        wrapperView.addSubview(passTdLabel)
        wrapperView.addSubview(passIntLabel)
        wrapperView.addSubview(rushYdsLabel)
        wrapperView.addSubview(rushTdLabel)
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
        
        passYdsLabel.font = .openSans(weight: .Semibold, size: 10)
        passYdsLabel.textColor = UIColor(0x192436)
        passYdsLabel.letterSpacing = 0.5
        passYdsLabel.textAlignment = .Center
        
        passTdLabel.font = .openSans(weight: .Semibold, size: 10)
        passTdLabel.textColor = UIColor(0x192436)
        passTdLabel.letterSpacing = 0.5
        passTdLabel.textAlignment = .Center
        
        passIntLabel.font = .openSans(weight: .Semibold, size: 10)
        passIntLabel.textColor = UIColor(0x192436)
        passIntLabel.letterSpacing = 0.5
        passIntLabel.textAlignment = .Center
        
        rushYdsLabel.font = .openSans(weight: .Semibold, size: 10)
        rushYdsLabel.textColor = UIColor(0x192436)
        rushYdsLabel.letterSpacing = 0.5
        rushYdsLabel.textAlignment = .Center
        
        rushTdLabel.font = .openSans(weight: .Semibold, size: 10)
        rushTdLabel.textColor = UIColor(0x192436)
        rushTdLabel.letterSpacing = 0.5
        rushTdLabel.textAlignment = .Center
        
        fpLabel.font = .openSans(weight: .Semibold, size: 10)
        fpLabel.textColor = UIColor(0x192436)
        fpLabel.letterSpacing = 0.5
        
        borderView.backgroundColor = UIColor(0xe6e8ed)
    }
    
    func addConstraints() {
        let colWidth = ( UIScreen.mainScreen().bounds.size.width - 190 ) / 5
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
            passYdsLabel.widthRancor.constraintEqualToConstant(colWidth),
            passYdsLabel.leftRancor.constraintEqualToRancor(oppLabel.rightRancor),
            passYdsLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            passTdLabel.widthRancor.constraintEqualToConstant(colWidth),
            passTdLabel.leftRancor.constraintEqualToRancor(passYdsLabel.rightRancor),
            passTdLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            passIntLabel.widthRancor.constraintEqualToConstant(colWidth),
            passIntLabel.leftRancor.constraintEqualToRancor(passTdLabel.rightRancor),
            passIntLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            rushYdsLabel.widthRancor.constraintEqualToConstant(colWidth),
            rushYdsLabel.leftRancor.constraintEqualToRancor(passIntLabel.rightRancor),
            rushYdsLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            rushTdLabel.widthRancor.constraintEqualToConstant(colWidth),
            rushTdLabel.leftRancor.constraintEqualToRancor(rushYdsLabel.rightRancor),
            rushTdLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            fpLabel.widthRancor.constraintEqualToConstant(40),
            fpLabel.leftRancor.constraintEqualToRancor(rushTdLabel.rightRancor, constant: 10),
            fpLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(fitToPixel(1.0))
        ]
        
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        oppLabel.translatesAutoresizingMaskIntoConstraints = false
        passYdsLabel.translatesAutoresizingMaskIntoConstraints = false
        passTdLabel.translatesAutoresizingMaskIntoConstraints = false
        passIntLabel.translatesAutoresizingMaskIntoConstraints = false
        rushYdsLabel.translatesAutoresizingMaskIntoConstraints = false
        rushTdLabel.translatesAutoresizingMaskIntoConstraints = false
        fpLabel.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
