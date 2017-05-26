//
//  ContestDetailMyEntryCell.swift
//  Draftboard
//
//  Created by devguru on 5/25/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

protocol MyEntryCellDelegate: class {
    func updateData()
}

class ContestDetailMyEntryCell: DraftboardTableViewCell {

    let lineupNameLabel = DraftboardLabel()
    let removeButton = DraftboardTextButton()
    let borderView = UIView()
    
    var entry: ContestPoolEntry? {
        didSet {
            setupContestPoolEntry()
        }
    }
    
    var delegate: MyEntryCellDelegate? = nil
    
    override func setup() {
        addSubviews()
        setupSubviews()
        addConstraints()
    }
    
    func addSubviews() {
        contentView.addSubview(lineupNameLabel)
        contentView.addSubview(removeButton)
        contentView.addSubview(borderView)
    }
    
    func setupSubviews() {
        lineupNameLabel.font = .openSans(weight: .Semibold, size: 13)
        lineupNameLabel.textColor = UIColor(0x192436)
        lineupNameLabel.letterSpacing = 0.5
        lineupNameLabel.textAlignment = .Center
        
        removeButton.label.text = "Remove Entry"
        removeButton.label.textColor = UIColor.greenDraftboard()
        removeButton.label.kern = 0.5
        removeButton.backgroundColor = UIColor.clearColor()
        removeButton.addTarget(self, action: #selector(removeButtonTapped), forControlEvents: .TouchUpInside)
        
        borderView.backgroundColor = UIColor(0xe6e8ed)
    }
    
    func addConstraints() {
        lineupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewConstraints: [NSLayoutConstraint] = [
            lineupNameLabel.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 20),
            lineupNameLabel.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            removeButton.widthRancor.constraintEqualToConstant(97),
            removeButton.heightRancor.constraintEqualToConstant(27),
            removeButton.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -20),
            removeButton.centerYRancor.constraintEqualToRancor(contentView.centerYRancor),
            borderView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 15),
            borderView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -15),
            borderView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor),
            borderView.heightRancor.constraintEqualToConstant(fitToPixel(1.0))
        ]
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupContestPoolEntry() {
        lineupNameLabel.text = entry?.lineupName
        removeButton.label.text = "Remove Entry"
        removeButton.label.textColor = UIColor.greenDraftboard()
        removeButton.label.kern = 0.5
        removeButton.backgroundColor = UIColor.clearColor()
    }
    
    func removeButtonTapped() {
        removeButton.label.text = "Removing..."
        removeButton.label.textColor = UIColor.whiteColor()
        removeButton.backgroundColor = UIColor.greenDraftboard()
        entry!.unregister().then { result -> Void in
            let res = result as! NSDictionary
            let status: String = try res.get("status")
            if status == "SUCCESS" {
                self.delegate?.updateData()
            }
        }
    }
}
