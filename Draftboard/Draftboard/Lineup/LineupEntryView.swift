//
//  LineupEntryView.swift
//  Draftboard
//
//  Created by Anson Schall on 7/1/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupEntryView: UIView {
    
    let tempLabel = UILabel()
    
    var tapAction: () -> Void = {}
    
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
    
    func setup() {
        addSubviews()
        addConstraints()
        otherSetup()
    }
    
    func addSubviews() {
        addSubview(tempLabel)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            tempLabel.topRancor.constraintEqualToRancor(topRancor, constant: 30.0),
            tempLabel.leftRancor.constraintEqualToRancor(leftRancor),
            tempLabel.rightRancor.constraintEqualToRancor(rightRancor),
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        backgroundColor = .whiteColor()
        tempLabel.font = .openSans(size: 14.0)
        tempLabel.textAlignment = .Center
        tempLabel.textColor = .blackColor()
        tempLabel.text = "Contest entries will go here!"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }
    
    func tapped() {
        tapAction()
    }

}