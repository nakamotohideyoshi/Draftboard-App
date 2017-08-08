//
//  LineupEntryView.swift
//  Draftboard
//
//  Created by Anson Schall on 7/1/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupEntryView: UIView {
    
    let tableView = LineupEntryTableView()
    let headerView = UIView()
    let footerView = LineupFooterView()
    
    // Header stuff
    let sportIcon = UIImageView()
    let nameLabel = UILabel()
    let flipButton = UIButton()
    let columnLabel1 = DraftboardLabel()
    let columnLabel2 = DraftboardLabel()
    let columnLabel3 = DraftboardLabel()
    let headerBorderView = UIView()
    
    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    override convenience init(frame: CGRect) {
        self.init()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    override func layoutSubviews() {
        tableView.frame = bounds
        headerView.frame = CGRectMake(0, 0, bounds.width, 68)
        footerView.frame = CGRectMake(0, bounds.height - 68, bounds.width, 68)
        
        sportIcon.frame = CGRectMake(17, headerView.bounds.height * 0.5 - 13 * 0.5, 13, 13)
        nameLabel.frame = CGRectInset(headerView.bounds, 44, 0)
        flipButton.frame = CGRectMake(headerView.bounds.width - 44, 0, 44, headerView.bounds.height)
        headerBorderView.frame = CGRectMake(0, headerView.bounds.height - 1, headerView.bounds.width, 1)
    }
    
    func setup() {
        addSubviews()
        addConstraints()
        otherSetup()
    }
    
    func addSubviews() {
        addSubview(tableView)
        addSubview(footerView)
        addSubview(headerView)
        
        headerView.addSubview(sportIcon)
        headerView.addSubview(nameLabel)
        headerView.addSubview(flipButton)
        headerView.addSubview(columnLabel1)
        headerView.addSubview(columnLabel2)
        headerView.addSubview(columnLabel3)
        headerView.addSubview(headerBorderView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            columnLabel1.bottomRancor.constraintEqualToRancor(headerView.bottomRancor, constant: -2),
            columnLabel1.leftRancor.constraintEqualToRancor(headerView.leftRancor, constant: 7),
            columnLabel2.bottomRancor.constraintEqualToRancor(headerView.bottomRancor, constant: -2),
            columnLabel2.leftRancor.constraintEqualToRancor(headerView.leftRancor, constant: 50),
            columnLabel3.bottomRancor.constraintEqualToRancor(headerView.bottomRancor, constant: -2),
            columnLabel3.rightRancor.constraintEqualToRancor(headerView.rightRancor, constant: -7),
        ]
        
        columnLabel1.translatesAutoresizingMaskIntoConstraints = false
        columnLabel2.translatesAutoresizingMaskIntoConstraints = false
        columnLabel3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {

        headerView.backgroundColor = UIColor(0x4b545f)
        headerView.alpha = 0.9
        footerView.backgroundColor = UIColor(0x4b545f)
        footerView.alpha = 0.9
        footerView.userInteractionEnabled = false
        
        for subview in footerView.subviews {
            if let statView = subview as? StatView {
                if let countdownView = statView as? CountdownStatView {
                    countdownView.countdownView.color = .whiteColor()
                } else {
                    statView.valueLabel.textColor = .whiteColor()
                }
                statView.rightBorderView.backgroundColor = UIColor(0x5f626d)
            }
        }
        
        sportIcon.image = UIImage(named: "icon-baseball")
        sportIcon.tintColor = .whiteColor()
        
        flipButton.setImage(UIImage(named: "icon-flip-back"), forState: .Normal)
        flipButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 4)
        
        nameLabel.font = UIFont.openSans(size: 16)
        nameLabel.textColor = .whiteColor()
        
        columnLabel1.font = .openSans(weight: .Semibold, size: 7)
        columnLabel1.textColor = .whiteColor()
        columnLabel1.letterSpacing = 0.5
        columnLabel1.text = "Remove".uppercaseString
        
        columnLabel2.font = .openSans(weight: .Semibold, size: 7)
        columnLabel2.textColor = .whiteColor()
        columnLabel2.letterSpacing = 0.5
        columnLabel2.text = "Contest".uppercaseString
        
        columnLabel3.font = .openSans(weight: .Semibold, size: 7)
        columnLabel3.textColor = .whiteColor()
        columnLabel3.letterSpacing = 0.5
        columnLabel3.text = "Fee".uppercaseString
        
        headerBorderView.backgroundColor = UIColor(0x5f626d)
        footerView.topBorderView.backgroundColor = UIColor(0x5f626d)

        tableView.contentInset = UIEdgeInsetsMake(68, 0, 68, 0)
        tableView.contentOffset = CGPointMake(0, -68)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
}
