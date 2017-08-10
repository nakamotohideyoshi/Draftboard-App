//
//  NFLQBGameLogHeaderCell.swift
//  Draftboard
//
//  Created by devguru on 6/19/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class NFLQBGameLogHeaderCell: UITableViewCell {
    
    let headerView = UIView()
    let greyBackgroundView = UIView()
    let columnLabel = DraftboardLabel()
    let passLabel = DraftboardLabel()
    let rushLabel = DraftboardLabel()
    let dateLabel = DraftboardLabel()
    let oppLabel = DraftboardLabel()
    let passYdsLabel = DraftboardLabel()
    let passTdLabel = DraftboardLabel()
    let passIntLabel = DraftboardLabel()
    let rushYdsLabel = DraftboardLabel()
    let rushTdLabel = DraftboardLabel()
    let fpLabel = DraftboardLabel()
    
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
        contentView.addSubview(headerView)
        headerView.addSubview(greyBackgroundView)
        headerView.addSubview(columnLabel)
        headerView.addSubview(passLabel)
        headerView.addSubview(rushLabel)
        headerView.addSubview(dateLabel)
        headerView.addSubview(oppLabel)
        headerView.addSubview(passYdsLabel)
        headerView.addSubview(passTdLabel)
        headerView.addSubview(passIntLabel)
        headerView.addSubview(rushYdsLabel)
        headerView.addSubview(rushTdLabel)
        headerView.addSubview(fpLabel)
    }
    
    func setupSubviews() {
        headerView.backgroundColor = .greyCool()
        greyBackgroundView.backgroundColor = UIColor(0xe4e5e7)
        
        columnLabel.font = .openSans(weight: .Semibold, size: 9)
        columnLabel.textColor = .whiteColor()
        columnLabel.letterSpacing = 0.5
        columnLabel.text = "game log".uppercaseString
        
        passLabel.font = .openSans(weight: .Semibold, size: 9)
        passLabel.textColor = .whiteColor()
        passLabel.letterSpacing = 0.5
        passLabel.text = "passing".uppercaseString
        
        rushLabel.font = .openSans(weight: .Semibold, size: 9)
        rushLabel.textColor = .whiteColor()
        rushLabel.letterSpacing = 0.5
        rushLabel.text = "rushing".uppercaseString
        
        dateLabel.font = .openSans(weight: .Semibold, size: 8)
        dateLabel.textColor = UIColor(0x192436)
        dateLabel.letterSpacing = 0.5
        dateLabel.text = "DATE"
        
        oppLabel.font = .openSans(weight: .Semibold, size: 8)
        oppLabel.textColor = UIColor(0x192436)
        oppLabel.letterSpacing = 0.5
        oppLabel.text = "OPP"
        
        passYdsLabel.font = .openSans(weight: .Semibold, size: 8)
        passYdsLabel.textColor = UIColor(0x192436)
        passYdsLabel.letterSpacing = 0.5
        passYdsLabel.textAlignment = .Center
        passYdsLabel.text = "YDS"
        
        passTdLabel.font = .openSans(weight: .Semibold, size: 8)
        passTdLabel.textColor = UIColor(0x192436)
        passTdLabel.letterSpacing = 0.5
        passTdLabel.textAlignment = .Center
        passTdLabel.text = "TD"
        
        passIntLabel.font = .openSans(weight: .Semibold, size: 8)
        passIntLabel.textColor = UIColor(0x192436)
        passIntLabel.letterSpacing = 0.5
        passIntLabel.textAlignment = .Center
        passIntLabel.text = "INT"
        
        rushYdsLabel.font = .openSans(weight: .Semibold, size: 8)
        rushYdsLabel.textColor = UIColor(0x192436)
        rushYdsLabel.letterSpacing = 0.5
        rushYdsLabel.textAlignment = .Center
        rushYdsLabel.text = "YDS"
        
        rushTdLabel.font = .openSans(weight: .Semibold, size: 8)
        rushTdLabel.textColor = UIColor(0x192436)
        rushTdLabel.letterSpacing = 0.5
        rushTdLabel.textAlignment = .Center
        rushTdLabel.text = "TD"
        
        fpLabel.font = .openSans(weight: .Semibold, size: 8)
        fpLabel.textColor = UIColor(0x192436)
        fpLabel.letterSpacing = 0.5
        fpLabel.text = "FP"
    }
    
    func addConstraints() {
        let colWidth = ( UIScreen.mainScreen().bounds.size.width - 190 ) / 5
        passYdsLabel.sizeToFit()
        rushYdsLabel.sizeToFit()
        let viewConstraints: [NSLayoutConstraint] = [
            headerView.centerXRancor.constraintEqualToRancor(centerXRancor),
            headerView.bottomRancor.constraintEqualToRancor(bottomRancor),
            headerView.widthRancor.constraintEqualToRancor(contentView.widthRancor, multiplier: 1.0, constant: -30),
            headerView.heightRancor.constraintEqualToConstant(39),
            greyBackgroundView.centerXRancor.constraintEqualToRancor(centerXRancor),
            greyBackgroundView.bottomRancor.constraintEqualToRancor(bottomRancor),
            greyBackgroundView.widthRancor.constraintEqualToRancor(contentView.widthRancor, multiplier: 1.0, constant: -30),
            greyBackgroundView.heightRancor.constraintEqualToConstant(19),
            dateLabel.leftRancor.constraintEqualToRancor(headerView.leftRancor, constant: 5),
            dateLabel.widthRancor.constraintEqualToConstant(50),
            dateLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            oppLabel.leftRancor.constraintEqualToRancor(dateLabel.rightRancor),
            oppLabel.widthRancor.constraintEqualToConstant(50),
            oppLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            passYdsLabel.widthRancor.constraintEqualToConstant(colWidth),
            passYdsLabel.leftRancor.constraintEqualToRancor(oppLabel.rightRancor),
            passYdsLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            passTdLabel.widthRancor.constraintEqualToConstant(colWidth),
            passTdLabel.leftRancor.constraintEqualToRancor(passYdsLabel.rightRancor),
            passTdLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            passIntLabel.widthRancor.constraintEqualToConstant(colWidth),
            passIntLabel.leftRancor.constraintEqualToRancor(passTdLabel.rightRancor),
            passIntLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            rushYdsLabel.widthRancor.constraintEqualToConstant(colWidth),
            rushYdsLabel.leftRancor.constraintEqualToRancor(passIntLabel.rightRancor),
            rushYdsLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            rushTdLabel.widthRancor.constraintEqualToConstant(colWidth),
            rushTdLabel.leftRancor.constraintEqualToRancor(rushYdsLabel.rightRancor),
            rushTdLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            fpLabel.widthRancor.constraintEqualToConstant(40),
            fpLabel.leftRancor.constraintEqualToRancor(rushTdLabel.rightRancor, constant: 10),
            fpLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            columnLabel.leftRancor.constraintEqualToRancor(dateLabel.leftRancor),
            columnLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 0.5),
            passLabel.leftRancor.constraintEqualToRancor(passYdsLabel.leftRancor, constant: colWidth / 2 - passYdsLabel.frame.size.width / 2),
            passLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 0.5),
            rushLabel.leftRancor.constraintEqualToRancor(rushYdsLabel.leftRancor, constant: colWidth / 2 - rushYdsLabel.frame.size.width / 2),
            rushLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 0.5),
        ]
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        greyBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        columnLabel.translatesAutoresizingMaskIntoConstraints = false
        passLabel.translatesAutoresizingMaskIntoConstraints = false
        rushLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        oppLabel.translatesAutoresizingMaskIntoConstraints = false
        passYdsLabel.translatesAutoresizingMaskIntoConstraints = false
        passTdLabel.translatesAutoresizingMaskIntoConstraints = false
        passIntLabel.translatesAutoresizingMaskIntoConstraints = false
        rushYdsLabel.translatesAutoresizingMaskIntoConstraints = false
        rushTdLabel.translatesAutoresizingMaskIntoConstraints = false
        fpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
