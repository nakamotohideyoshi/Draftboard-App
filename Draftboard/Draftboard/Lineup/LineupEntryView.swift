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
    
    override func layoutSubviews() {
        tempLabel.frame = bounds
    }
    
    func setup() {
        addSubviews()
        otherSetup()
    }
    
    func addSubviews() {
        addSubview(tempLabel)
    }
    
    func otherSetup() {
        backgroundColor = .whiteColor()
        tempLabel.font = .openSans(size: 14.0)
        tempLabel.textAlignment = .Center
        tempLabel.textColor = .blackColor()
        tempLabel.text = "Contest entries will go here!"
    }
    
}