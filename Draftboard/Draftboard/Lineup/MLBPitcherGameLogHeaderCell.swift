//
//  MLBPitcherGameLogHeaderCell.swift
//  Draftboard
//
//  Created by devguru on 5/12/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class MLBPitcherGameLogHeaderCell: UITableViewCell {
    
    let headerView = UIView()
    let dateLabel = DraftboardLabel()
    let oppLabel = DraftboardLabel()
    let resultLabel = DraftboardLabel()
    let ipLabel = DraftboardLabel()
    let hLabel = DraftboardLabel()
    let erLabel = DraftboardLabel()
    let bbLabel = DraftboardLabel()
    let soLabel = DraftboardLabel()
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
        headerView.addSubview(dateLabel)
        headerView.addSubview(oppLabel)
        headerView.addSubview(resultLabel)
        headerView.addSubview(ipLabel)
        headerView.addSubview(hLabel)
        headerView.addSubview(erLabel)
        headerView.addSubview(bbLabel)
        headerView.addSubview(soLabel)
        headerView.addSubview(fpLabel)
    }
    
    func setupSubviews() {
        headerView.backgroundColor = .greyCool()
        
        dateLabel.font = .openSans(weight: .Semibold, size: 8)
        dateLabel.textColor = .whiteColor()
        dateLabel.letterSpacing = 0.5
        dateLabel.text = "DATE"
        
        oppLabel.font = .openSans(weight: .Semibold, size: 8)
        oppLabel.textColor = .whiteColor()
        oppLabel.letterSpacing = 0.5
        oppLabel.text = "OPP"
        
        resultLabel.font = .openSans(weight: .Semibold, size: 8)
        resultLabel.textColor = .whiteColor()
        resultLabel.letterSpacing = 0.5
        resultLabel.text = "RESULT"
        
        ipLabel.font = .openSans(weight: .Semibold, size: 8)
        ipLabel.textColor = .whiteColor()
        ipLabel.letterSpacing = 0.5
        ipLabel.textAlignment = .Center
        ipLabel.text = "IP"
        
        hLabel.font = .openSans(weight: .Semibold, size: 8)
        hLabel.textColor = .whiteColor()
        hLabel.letterSpacing = 0.5
        hLabel.textAlignment = .Center
        hLabel.text = "H"
        
        erLabel.font = .openSans(weight: .Semibold, size: 8)
        erLabel.textColor = .whiteColor()
        erLabel.letterSpacing = 0.5
        erLabel.textAlignment = .Center
        erLabel.text = "ER"
        
        bbLabel.font = .openSans(weight: .Semibold, size: 8)
        bbLabel.textColor = .whiteColor()
        bbLabel.letterSpacing = 0.5
        bbLabel.textAlignment = .Center
        bbLabel.text = "BB"
        
        soLabel.font = .openSans(weight: .Semibold, size: 8)
        soLabel.textColor = .whiteColor()
        soLabel.letterSpacing = 0.5
        soLabel.textAlignment = .Center
        soLabel.text = "SO"
        
        fpLabel.font = .openSans(weight: .Semibold, size: 8)
        fpLabel.textColor = .whiteColor()
        fpLabel.letterSpacing = 0.5
        fpLabel.text = "FPPG"
    }
    
    func addConstraints() {
        let colWidth = ( UIScreen.mainScreen().bounds.size.width - 230 ) / 5
        let viewConstraints: [NSLayoutConstraint] = [
            headerView.centerXRancor.constraintEqualToRancor(centerXRancor),
            headerView.bottomRancor.constraintEqualToRancor(bottomRancor),
            headerView.widthRancor.constraintEqualToRancor(contentView.widthRancor, multiplier: 1.0, constant: -30),
            headerView.heightRancor.constraintEqualToConstant(18),
            dateLabel.leftRancor.constraintEqualToRancor(headerView.leftRancor, constant: 5),
            dateLabel.widthRancor.constraintEqualToConstant(50),
            dateLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            oppLabel.leftRancor.constraintEqualToRancor(dateLabel.rightRancor),
            oppLabel.widthRancor.constraintEqualToConstant(50),
            oppLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            resultLabel.leftRancor.constraintEqualToRancor(oppLabel.rightRancor),
            resultLabel.widthRancor.constraintEqualToConstant(40),
            resultLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            ipLabel.widthRancor.constraintEqualToConstant(colWidth),
            ipLabel.leftRancor.constraintEqualToRancor(resultLabel.rightRancor),
            ipLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            hLabel.widthRancor.constraintEqualToConstant(colWidth),
            hLabel.leftRancor.constraintEqualToRancor(ipLabel.rightRancor),
            hLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            erLabel.widthRancor.constraintEqualToConstant(colWidth),
            erLabel.leftRancor.constraintEqualToRancor(hLabel.rightRancor),
            erLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            bbLabel.widthRancor.constraintEqualToConstant(colWidth),
            bbLabel.leftRancor.constraintEqualToRancor(erLabel.rightRancor),
            bbLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            soLabel.widthRancor.constraintEqualToConstant(colWidth),
            soLabel.leftRancor.constraintEqualToRancor(bbLabel.rightRancor),
            soLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            fpLabel.widthRancor.constraintEqualToConstant(40),
            fpLabel.leftRancor.constraintEqualToRancor(soLabel.rightRancor, constant: 10),
            fpLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
        ]
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        oppLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        ipLabel.translatesAutoresizingMaskIntoConstraints = false
        hLabel.translatesAutoresizingMaskIntoConstraints = false
        erLabel.translatesAutoresizingMaskIntoConstraints = false
        bbLabel.translatesAutoresizingMaskIntoConstraints = false
        soLabel.translatesAutoresizingMaskIntoConstraints = false
        fpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
