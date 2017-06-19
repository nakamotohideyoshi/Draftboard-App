//
//  NFLRBGameLogHeaderCell.swift
//  Draftboard
//
//  Created by devguru on 6/20/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class NFLRBGameLogHeaderCell: UITableViewCell {
    
    let headerView = UIView()
    let rushLabel = DraftboardLabel()
    let recLabel = DraftboardLabel()
    let dateLabel = DraftboardLabel()
    let oppLabel = DraftboardLabel()
    let rushYdsLabel = DraftboardLabel()
    let rushTdLabel = DraftboardLabel()
    let recRecLabel = DraftboardLabel()
    let recYdsLabel = DraftboardLabel()
    let recTdLabel = DraftboardLabel()
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
        headerView.addSubview(recLabel)
        headerView.addSubview(rushLabel)
        headerView.addSubview(dateLabel)
        headerView.addSubview(oppLabel)
        headerView.addSubview(rushYdsLabel)
        headerView.addSubview(rushTdLabel)
        headerView.addSubview(recRecLabel)
        headerView.addSubview(recYdsLabel)
        headerView.addSubview(recTdLabel)
        headerView.addSubview(fpLabel)
    }
    
    func setupSubviews() {
        headerView.backgroundColor = .greyCool()
        
        rushLabel.font = .openSans(weight: .Semibold, size: 8)
        rushLabel.textColor = .whiteColor()
        rushLabel.letterSpacing = 0.5
        rushLabel.text = "rushing".uppercaseString
        
        recLabel.font = .openSans(weight: .Semibold, size: 8)
        recLabel.textColor = .whiteColor()
        recLabel.letterSpacing = 0.5
        recLabel.text = "receiving".uppercaseString
        
        dateLabel.font = .openSans(weight: .Semibold, size: 8)
        dateLabel.textColor = .whiteColor()
        dateLabel.letterSpacing = 0.5
        dateLabel.text = "DATE"
        
        oppLabel.font = .openSans(weight: .Semibold, size: 8)
        oppLabel.textColor = .whiteColor()
        oppLabel.letterSpacing = 0.5
        oppLabel.text = "OPP"
        
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
        
        recRecLabel.font = .openSans(weight: .Semibold, size: 8)
        recRecLabel.textColor = .whiteColor()
        recRecLabel.letterSpacing = 0.5
        recRecLabel.textAlignment = .Center
        recRecLabel.text = "rec".uppercaseString
        
        recYdsLabel.font = .openSans(weight: .Semibold, size: 8)
        recYdsLabel.textColor = .whiteColor()
        recYdsLabel.letterSpacing = 0.5
        recYdsLabel.textAlignment = .Center
        recYdsLabel.text = "yds".uppercaseString
        
        recTdLabel.font = .openSans(weight: .Semibold, size: 8)
        recTdLabel.textColor = .whiteColor()
        recTdLabel.letterSpacing = 0.5
        recTdLabel.textAlignment = .Center
        recTdLabel.text = "td".uppercaseString
        
        fpLabel.font = .openSans(weight: .Semibold, size: 8)
        fpLabel.textColor = .whiteColor()
        fpLabel.letterSpacing = 0.5
        fpLabel.text = "FP"
    }
    
    func addConstraints() {
        let colWidth = ( UIScreen.mainScreen().bounds.size.width - 190 ) / 5
        rushYdsLabel.sizeToFit()
        recRecLabel.sizeToFit()
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
            rushYdsLabel.widthRancor.constraintEqualToConstant(colWidth),
            rushYdsLabel.leftRancor.constraintEqualToRancor(oppLabel.rightRancor),
            rushYdsLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            rushTdLabel.widthRancor.constraintEqualToConstant(colWidth),
            rushTdLabel.leftRancor.constraintEqualToRancor(rushYdsLabel.rightRancor),
            rushTdLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            recRecLabel.widthRancor.constraintEqualToConstant(colWidth),
            recRecLabel.leftRancor.constraintEqualToRancor(rushTdLabel.rightRancor),
            recRecLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            recYdsLabel.widthRancor.constraintEqualToConstant(colWidth),
            recYdsLabel.leftRancor.constraintEqualToRancor(recRecLabel.rightRancor),
            recYdsLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            recTdLabel.widthRancor.constraintEqualToConstant(colWidth),
            recTdLabel.leftRancor.constraintEqualToRancor(recYdsLabel.rightRancor),
            recTdLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            fpLabel.widthRancor.constraintEqualToConstant(40),
            fpLabel.leftRancor.constraintEqualToRancor(recTdLabel.rightRancor, constant: 10),
            fpLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 1.5),
            rushLabel.leftRancor.constraintEqualToRancor(rushYdsLabel.leftRancor, constant: colWidth / 2 - rushYdsLabel.frame.size.width / 2),
            rushLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 0.5),
            recLabel.leftRancor.constraintEqualToRancor(recRecLabel.leftRancor, constant: colWidth / 2 - recRecLabel.frame.size.width / 2),
            recLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 0.5),

        ]
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        recLabel.translatesAutoresizingMaskIntoConstraints = false
        rushLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        oppLabel.translatesAutoresizingMaskIntoConstraints = false
        recRecLabel.translatesAutoresizingMaskIntoConstraints = false
        recYdsLabel.translatesAutoresizingMaskIntoConstraints = false
        recTdLabel.translatesAutoresizingMaskIntoConstraints = false
        rushYdsLabel.translatesAutoresizingMaskIntoConstraints = false
        rushTdLabel.translatesAutoresizingMaskIntoConstraints = false
        fpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
