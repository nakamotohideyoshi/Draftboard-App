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
        
        passLabel.font = .openSans(weight: .Semibold, size: 8)
        passLabel.textColor = .whiteColor()
        passLabel.letterSpacing = 0.5
        passLabel.text = "passing".uppercaseString
        
        rushLabel.font = .openSans(weight: .Semibold, size: 8)
        rushLabel.textColor = .whiteColor()
        rushLabel.letterSpacing = 0.5
        rushLabel.text = "rushing".uppercaseString
        
        dateLabel.font = .openSans(weight: .Semibold, size: 8)
        dateLabel.textColor = .whiteColor()
        dateLabel.letterSpacing = 0.5
        dateLabel.text = "DATE"
        
        oppLabel.font = .openSans(weight: .Semibold, size: 8)
        oppLabel.textColor = .whiteColor()
        oppLabel.letterSpacing = 0.5
        oppLabel.text = "OPP"
        
        passYdsLabel.font = .openSans(weight: .Semibold, size: 8)
        passYdsLabel.textColor = .whiteColor()
        passYdsLabel.letterSpacing = 0.5
        passYdsLabel.textAlignment = .Center
        passYdsLabel.text = "YDS"
        
        passTdLabel.font = .openSans(weight: .Semibold, size: 8)
        passTdLabel.textColor = .whiteColor()
        passTdLabel.letterSpacing = 0.5
        passTdLabel.textAlignment = .Center
        passTdLabel.text = "TD"
        
        passIntLabel.font = .openSans(weight: .Semibold, size: 8)
        passIntLabel.textColor = .whiteColor()
        passIntLabel.letterSpacing = 0.5
        passIntLabel.textAlignment = .Center
        passIntLabel.text = "INT"
        
        rushYdsLabel.font = .openSans(weight: .Semibold, size: 8)
        rushYdsLabel.textColor = .whiteColor()
        rushYdsLabel.letterSpacing = 0.5
        rushYdsLabel.textAlignment = .Center
        rushYdsLabel.text = "YDS"
        
        rushTdLabel.font = .openSans(weight: .Semibold, size: 8)
        rushTdLabel.textColor = .whiteColor()
        rushTdLabel.letterSpacing = 0.5
        rushTdLabel.textAlignment = .Center
        rushTdLabel.text = "TD"
        
        fpLabel.font = .openSans(weight: .Semibold, size: 8)
        fpLabel.textColor = .whiteColor()
        fpLabel.letterSpacing = 0.5
        fpLabel.text = "FPPG"
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
            passLabel.leftRancor.constraintEqualToRancor(passYdsLabel.leftRancor, constant: colWidth / 2 - passYdsLabel.frame.size.width / 2),
            passLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 0.5),
            rushLabel.leftRancor.constraintEqualToRancor(rushYdsLabel.leftRancor, constant: colWidth / 2 - rushYdsLabel.frame.size.width / 2),
            rushLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 0.5),
        ]
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
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
