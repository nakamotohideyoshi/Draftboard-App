//
//  NFLRBGameLogHeaderCell.swift
//  Draftboard
//
//  Created by devguru on 6/20/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class NFLGameLogHeaderCell: UITableViewCell {
    
    let headerView = UIView()
    let greyBackgroundView = UIView()
    let columnLabel = DraftboardLabel()
    let recLabel = DraftboardLabel()
    let dateLabel = DraftboardLabel()
    let oppLabel = DraftboardLabel()
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
        headerView.addSubview(greyBackgroundView)
        headerView.addSubview(columnLabel)
        headerView.addSubview(recLabel)
        headerView.addSubview(dateLabel)
        headerView.addSubview(oppLabel)
        headerView.addSubview(recRecLabel)
        headerView.addSubview(recYdsLabel)
        headerView.addSubview(recTdLabel)
        headerView.addSubview(fpLabel)
    }
    
    func setupSubviews() {
        headerView.backgroundColor = .greyCool()
        greyBackgroundView.backgroundColor = UIColor(0xe4e5e7)
        
        columnLabel.font = .openSans(weight: .Semibold, size: 9)
        columnLabel.textColor = .whiteColor()
        columnLabel.letterSpacing = 0.5
        columnLabel.text = "game log".uppercaseString
        
        recLabel.font = .openSans(weight: .Semibold, size: 9)
        recLabel.textColor = .whiteColor()
        recLabel.letterSpacing = 0.5
        recLabel.text = "receiving".uppercaseString
        
        dateLabel.font = .openSans(weight: .Semibold, size: 8)
        dateLabel.textColor = UIColor(0x192436)
        dateLabel.letterSpacing = 0.5
        dateLabel.text = "DATE"
        
        oppLabel.font = .openSans(weight: .Semibold, size: 8)
        oppLabel.textColor = UIColor(0x192436)
        oppLabel.letterSpacing = 0.5
        oppLabel.text = "OPP"
        
        recRecLabel.font = .openSans(weight: .Semibold, size: 8)
        recRecLabel.textColor = UIColor(0x192436)
        recRecLabel.letterSpacing = 0.5
        recRecLabel.textAlignment = .Center
        recRecLabel.text = "rec".uppercaseString
        
        recYdsLabel.font = .openSans(weight: .Semibold, size: 8)
        recYdsLabel.textColor = UIColor(0x192436)
        recYdsLabel.letterSpacing = 0.5
        recYdsLabel.textAlignment = .Center
        recYdsLabel.text = "yds".uppercaseString
        
        recTdLabel.font = .openSans(weight: .Semibold, size: 8)
        recTdLabel.textColor = UIColor(0x192436)
        recTdLabel.letterSpacing = 0.5
        recTdLabel.textAlignment = .Center
        recTdLabel.text = "td".uppercaseString
        
        fpLabel.font = .openSans(weight: .Semibold, size: 8)
        fpLabel.textColor = UIColor(0x192436)
        fpLabel.letterSpacing = 0.5
        fpLabel.text = "FP"
    }
    
    func addConstraints() {
        let colWidth = ( UIScreen.mainScreen().bounds.size.width - 190 ) / 3
        recRecLabel.sizeToFit()
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
            recRecLabel.widthRancor.constraintEqualToConstant(colWidth),
            recRecLabel.leftRancor.constraintEqualToRancor(oppLabel.rightRancor),
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
            columnLabel.leftRancor.constraintEqualToRancor(dateLabel.leftRancor),
            columnLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 0.5),
            recLabel.leftRancor.constraintEqualToRancor(recRecLabel.leftRancor, constant: colWidth / 2 - recRecLabel.frame.size.width / 2),
            recLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor, multiplierValue: 0.5),
            
        ]
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        greyBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        columnLabel.translatesAutoresizingMaskIntoConstraints = false
        recLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        oppLabel.translatesAutoresizingMaskIntoConstraints = false
        recRecLabel.translatesAutoresizingMaskIntoConstraints = false
        recYdsLabel.translatesAutoresizingMaskIntoConstraints = false
        recTdLabel.translatesAutoresizingMaskIntoConstraints = false
        fpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
