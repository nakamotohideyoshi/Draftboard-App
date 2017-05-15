//
//  MLBPitcherGameLogCell.swift
//  Draftboard
//
//  Created by devguru on 5/12/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class MLBPitcherGameLogCell: UITableViewCell {
    
    let wrapperView = UIView()
    let dateLabel = DraftboardLabel()
    let oppLabel = DraftboardLabel()
    let resultLabel = DraftboardLabel()
    let ipLabel = DraftboardLabel()
    let hLabel = DraftboardLabel()
    let erLabel = DraftboardLabel()
    let bbLabel = DraftboardLabel()
    let soLabel = DraftboardLabel()
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
        wrapperView.addSubview(resultLabel)
        wrapperView.addSubview(ipLabel)
        wrapperView.addSubview(hLabel)
        wrapperView.addSubview(erLabel)
        wrapperView.addSubview(bbLabel)
        wrapperView.addSubview(soLabel)
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
        
        resultLabel.font = .openSans(weight: .Semibold, size: 10)
        resultLabel.textColor = UIColor(0x192436)
        resultLabel.letterSpacing = 0.5
        
        ipLabel.font = .openSans(weight: .Semibold, size: 10)
        ipLabel.textColor = UIColor(0x192436)
        ipLabel.letterSpacing = 0.5
        ipLabel.textAlignment = .Center
        
        hLabel.font = .openSans(weight: .Semibold, size: 10)
        hLabel.textColor = UIColor(0x192436)
        hLabel.letterSpacing = 0.5
        hLabel.textAlignment = .Center
        
        erLabel.font = .openSans(weight: .Semibold, size: 10)
        erLabel.textColor = UIColor(0x192436)
        erLabel.letterSpacing = 0.5
        erLabel.textAlignment = .Center
        
        bbLabel.font = .openSans(weight: .Semibold, size: 10)
        bbLabel.textColor = UIColor(0x192436)
        bbLabel.letterSpacing = 0.5
        bbLabel.textAlignment = .Center
        
        soLabel.font = .openSans(weight: .Semibold, size: 10)
        soLabel.textColor = UIColor(0x192436)
        soLabel.letterSpacing = 0.5
        soLabel.textAlignment = .Center
        
        fpLabel.font = .openSans(weight: .Semibold, size: 10)
        fpLabel.textColor = UIColor(0x192436)
        fpLabel.letterSpacing = 0.5
        
        borderView.backgroundColor = UIColor(0xe6e8ed)
    }
    
    func addConstraints() {
        let colWidth = ( UIScreen.mainScreen().bounds.size.width - 230 ) / 5
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
            resultLabel.leftRancor.constraintEqualToRancor(oppLabel.rightRancor),
            resultLabel.widthRancor.constraintEqualToConstant(40),
            resultLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            ipLabel.widthRancor.constraintEqualToConstant(colWidth),
            ipLabel.leftRancor.constraintEqualToRancor(resultLabel.rightRancor),
            ipLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            hLabel.widthRancor.constraintEqualToConstant(colWidth),
            hLabel.leftRancor.constraintEqualToRancor(ipLabel.rightRancor),
            hLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            erLabel.widthRancor.constraintEqualToConstant(colWidth),
            erLabel.leftRancor.constraintEqualToRancor(hLabel.rightRancor),
            erLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            bbLabel.widthRancor.constraintEqualToConstant(colWidth),
            bbLabel.leftRancor.constraintEqualToRancor(erLabel.rightRancor),
            bbLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            soLabel.widthRancor.constraintEqualToConstant(colWidth),
            soLabel.leftRancor.constraintEqualToRancor(bbLabel.rightRancor),
            soLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            fpLabel.widthRancor.constraintEqualToConstant(40),
            fpLabel.leftRancor.constraintEqualToRancor(soLabel.rightRancor, constant: 10),
            fpLabel.centerYRancor.constraintEqualToRancor(wrapperView.centerYRancor),
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(fitToPixel(1.0))
        ]
        
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        oppLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        ipLabel.translatesAutoresizingMaskIntoConstraints = false
        hLabel.translatesAutoresizingMaskIntoConstraints = false
        erLabel.translatesAutoresizingMaskIntoConstraints = false
        bbLabel.translatesAutoresizingMaskIntoConstraints = false
        soLabel.translatesAutoresizingMaskIntoConstraints = false
        fpLabel.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
}
