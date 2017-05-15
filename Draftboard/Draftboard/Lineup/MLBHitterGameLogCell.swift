//
//  MLBHitterGameLogCell.swift
//  Draftboard
//
//  Created by devguru on 5/13/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class MLBHitterGameLogCell: UITableViewCell {
    
    let wrapperView = UIView()
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
        wrapperView.addSubview(abLabel)
        wrapperView.addSubview(rLabel)
        wrapperView.addSubview(hLabel)
        wrapperView.addSubview(doublesLabel)
        wrapperView.addSubview(triplesLabel)
        wrapperView.addSubview(hrLabel)
        wrapperView.addSubview(rbiLabel)
        wrapperView.addSubview(bbLabel)
        wrapperView.addSubview(sbLabel)
        wrapperView.addSubview(fpLabel)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        dateLabel.font = .openSans(weight: .Semibold, size: 8)
        dateLabel.textColor = UIColor(0x192436)
        dateLabel.letterSpacing = 0.5
        
        oppLabel.font = .openSans(weight: .Semibold, size: 8)
        oppLabel.textColor = UIColor(0x192436)
        oppLabel.letterSpacing = 0.5
        
        abLabel.font = .openSans(weight: .Semibold, size: 8)
        abLabel.textColor = UIColor(0x192436)
        abLabel.letterSpacing = 0.5
        abLabel.textAlignment = .Center
        
        rLabel.font = .openSans(weight: .Semibold, size: 8)
        rLabel.textColor = UIColor(0x192436)
        rLabel.letterSpacing = 0.5
        rLabel.textAlignment = .Center
        
        hLabel.font = .openSans(weight: .Semibold, size: 8)
        hLabel.textColor = UIColor(0x192436)
        hLabel.letterSpacing = 0.5
        hLabel.textAlignment = .Center
        
        doublesLabel.font = .openSans(weight: .Semibold, size: 8)
        doublesLabel.textColor = UIColor(0x192436)
        doublesLabel.letterSpacing = 0.5
        doublesLabel.textAlignment = .Center
        
        triplesLabel.font = .openSans(weight: .Semibold, size: 8)
        triplesLabel.textColor = UIColor(0x192436)
        triplesLabel.letterSpacing = 0.5
        triplesLabel.textAlignment = .Center
        
        hrLabel.font = .openSans(weight: .Semibold, size: 8)
        hrLabel.textColor = UIColor(0x192436)
        hrLabel.letterSpacing = 0.5
        hrLabel.textAlignment = .Center
        
        rbiLabel.font = .openSans(weight: .Semibold, size: 8)
        rbiLabel.textColor = UIColor(0x192436)
        rbiLabel.letterSpacing = 0.55
        rbiLabel.textAlignment = .Center
        
        bbLabel.font = .openSans(weight: .Semibold, size: 8)
        bbLabel.textColor = UIColor(0x192436)
        bbLabel.letterSpacing = 0.5
        bbLabel.textAlignment = .Center
        
        sbLabel.font = .openSans(weight: .Semibold, size: 8)
        sbLabel.textColor = UIColor(0x192436)
        sbLabel.letterSpacing = 0.5
        sbLabel.textAlignment = .Center
        
        fpLabel.font = .openSans(weight: .Semibold, size: 8)
        fpLabel.textColor = UIColor(0x192436)
        fpLabel.letterSpacing = 0.5
        
        borderView.backgroundColor = UIColor(0xe6e8ed)
    }
    
    func addConstraints() {
        let colWidth = ( UIScreen.mainScreen().bounds.size.width - 190 ) / 9
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
            abLabel.leftRancor.constraintEqualToRancor(oppLabel.rightRancor),
            abLabel.widthRancor.constraintEqualToConstant(colWidth),
            abLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            rLabel.widthRancor.constraintEqualToConstant(colWidth),
            rLabel.leftRancor.constraintEqualToRancor(abLabel.rightRancor),
            rLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            hLabel.widthRancor.constraintEqualToConstant(colWidth),
            hLabel.leftRancor.constraintEqualToRancor(rLabel.rightRancor),
            hLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            doublesLabel.widthRancor.constraintEqualToConstant(colWidth),
            doublesLabel.leftRancor.constraintEqualToRancor(hLabel.rightRancor),
            doublesLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            triplesLabel.widthRancor.constraintEqualToConstant(colWidth),
            triplesLabel.leftRancor.constraintEqualToRancor(doublesLabel.rightRancor),
            triplesLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            hrLabel.widthRancor.constraintEqualToConstant(colWidth),
            hrLabel.leftRancor.constraintEqualToRancor(triplesLabel.rightRancor),
            hrLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            rbiLabel.widthRancor.constraintEqualToConstant(colWidth),
            rbiLabel.leftRancor.constraintEqualToRancor(hrLabel.rightRancor),
            rbiLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            bbLabel.widthRancor.constraintEqualToConstant(colWidth),
            bbLabel.leftRancor.constraintEqualToRancor(rbiLabel.rightRancor),
            bbLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            sbLabel.widthRancor.constraintEqualToConstant(colWidth),
            sbLabel.leftRancor.constraintEqualToRancor(bbLabel.rightRancor),
            sbLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            fpLabel.widthRancor.constraintEqualToConstant(40),
            fpLabel.leftRancor.constraintEqualToRancor(sbLabel.rightRancor, constant: 10),
            fpLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(fitToPixel(1.0))
        ]
        
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
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
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
