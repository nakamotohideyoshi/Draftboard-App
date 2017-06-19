//
//  MLBHitterGameLogHeaderCell.swift
//  Draftboard
//
//  Created by devguru on 5/13/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class MLBHitterGameLogHeaderCell: UITableViewCell {
    
    let headerView = UIView()
    let dateLabel = DraftboardLabel()
    let oppLabel = DraftboardLabel()
    let abLabel = DraftboardLabel()
    let rLabel = DraftboardLabel()
    let hLabel = DraftboardLabel()
    let doublesLabel = DraftboardLabel()
    let triplesLabel = DraftboardLabel()
    let hrLabel = DraftboardLabel()
    let rbiLabel = DraftboardLabel()
    let bbLabel = DraftboardLabel()
    let sbLabel = DraftboardLabel()
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
        headerView.addSubview(abLabel)
        headerView.addSubview(rLabel)
        headerView.addSubview(hLabel)
        headerView.addSubview(doublesLabel)
        headerView.addSubview(triplesLabel)
        headerView.addSubview(hrLabel)
        headerView.addSubview(rbiLabel)
        headerView.addSubview(bbLabel)
        headerView.addSubview(sbLabel)
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
        
        abLabel.font = .openSans(weight: .Semibold, size: 8)
        abLabel.textColor = .whiteColor()
        abLabel.letterSpacing = 0.5
        abLabel.textAlignment = .Center
        abLabel.text = "AB"
        
        rLabel.font = .openSans(weight: .Semibold, size: 8)
        rLabel.textColor = .whiteColor()
        rLabel.letterSpacing = 0.5
        rLabel.textAlignment = .Center
        rLabel.text = "R"
        
        hLabel.font = .openSans(weight: .Semibold, size: 8)
        hLabel.textColor = .whiteColor()
        hLabel.letterSpacing = 0.5
        hLabel.textAlignment = .Center
        hLabel.text = "H"
        
        doublesLabel.font = .openSans(weight: .Semibold, size: 8)
        doublesLabel.textColor = .whiteColor()
        doublesLabel.letterSpacing = 0.5
        doublesLabel.textAlignment = .Center
        doublesLabel.text = "2B"
        
        triplesLabel.font = .openSans(weight: .Semibold, size: 8)
        triplesLabel.textColor = .whiteColor()
        triplesLabel.letterSpacing = 0.5
        triplesLabel.textAlignment = .Center
        triplesLabel.text = "3B"
        
        hrLabel.font = .openSans(weight: .Semibold, size: 8)
        hrLabel.textColor = .whiteColor()
        hrLabel.letterSpacing = 0.5
        hrLabel.textAlignment = .Center
        hrLabel.text = "HR"
        
        rbiLabel.font = .openSans(weight: .Semibold, size: 8)
        rbiLabel.textColor = .whiteColor()
        rbiLabel.letterSpacing = 0.5
        rbiLabel.textAlignment = .Center
        rbiLabel.text = "RBI"
        
        bbLabel.font = .openSans(weight: .Semibold, size: 8)
        bbLabel.textColor = .whiteColor()
        bbLabel.letterSpacing = 0.5
        bbLabel.textAlignment = .Center
        bbLabel.text = "BB"
        
        sbLabel.font = .openSans(weight: .Semibold, size: 8)
        sbLabel.textColor = .whiteColor()
        sbLabel.letterSpacing = 0.5
        sbLabel.textAlignment = .Center
        sbLabel.text = "SB"
        
        fpLabel.font = .openSans(weight: .Semibold, size: 8)
        fpLabel.textColor = .whiteColor()
        fpLabel.letterSpacing = 0.5
        fpLabel.text = "FP"
    }
    
    func addConstraints() {
        let colWidth = ( UIScreen.mainScreen().bounds.size.width - 190 ) / 9
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
            abLabel.leftRancor.constraintEqualToRancor(oppLabel.rightRancor),
            abLabel.widthRancor.constraintEqualToConstant(colWidth),
            abLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            rLabel.widthRancor.constraintEqualToConstant(colWidth),
            rLabel.leftRancor.constraintEqualToRancor(abLabel.rightRancor),
            rLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            hLabel.widthRancor.constraintEqualToConstant(colWidth),
            hLabel.leftRancor.constraintEqualToRancor(rLabel.rightRancor),
            hLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            doublesLabel.widthRancor.constraintEqualToConstant(colWidth),
            doublesLabel.leftRancor.constraintEqualToRancor(hLabel.rightRancor),
            doublesLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            triplesLabel.widthRancor.constraintEqualToConstant(colWidth),
            triplesLabel.leftRancor.constraintEqualToRancor(doublesLabel.rightRancor),
            triplesLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            hrLabel.widthRancor.constraintEqualToConstant(colWidth),
            hrLabel.leftRancor.constraintEqualToRancor(triplesLabel.rightRancor),
            hrLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            rbiLabel.widthRancor.constraintEqualToConstant(colWidth),
            rbiLabel.leftRancor.constraintEqualToRancor(hrLabel.rightRancor),
            rbiLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            bbLabel.widthRancor.constraintEqualToConstant(colWidth),
            bbLabel.leftRancor.constraintEqualToRancor(rbiLabel.rightRancor),
            bbLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            sbLabel.widthRancor.constraintEqualToConstant(colWidth),
            sbLabel.leftRancor.constraintEqualToRancor(bbLabel.rightRancor),
            sbLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            fpLabel.widthRancor.constraintEqualToConstant(40),
            fpLabel.leftRancor.constraintEqualToRancor(sbLabel.rightRancor, constant: 10),
            fpLabel.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
        ]
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        oppLabel.translatesAutoresizingMaskIntoConstraints = false
        abLabel.translatesAutoresizingMaskIntoConstraints = false
        rLabel.translatesAutoresizingMaskIntoConstraints = false
        hLabel.translatesAutoresizingMaskIntoConstraints = false
        doublesLabel.translatesAutoresizingMaskIntoConstraints = false
        triplesLabel.translatesAutoresizingMaskIntoConstraints = false
        hrLabel.translatesAutoresizingMaskIntoConstraints = false
        rbiLabel.translatesAutoresizingMaskIntoConstraints = false
        bbLabel.translatesAutoresizingMaskIntoConstraints = false
        sbLabel.translatesAutoresizingMaskIntoConstraints = false
        fpLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}

