//
//  LineupStatView.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupStatView: UIView {
    let titleLabel = DraftboardLabel()
    let valueLabel = DraftboardLabel()
    
    var titleText: String!
    var valueText: String!
    
    init(titleText _titleText: String, valueText _valueText: String) {
        super.init(frame: CGRectZero)
        titleText = _titleText
        valueText = _valueText
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleText = "Title"
        valueText = "Value"
        setup()
    }
    
    func setup() {
        titleLabel.font = .draftboardLineupStatTitleFont()
        titleLabel.textColor = .lineupStatTitleColor()
        titleLabel.text = titleText.uppercaseString
        
        valueLabel.font = .draftboardLineupStatValueFont()
        valueLabel.textColor = .lineupStatValueColor()
        valueLabel.text = valueText.uppercaseString
        
        self.addSubview(titleLabel)
        self.addSubview(valueLabel)
        
        constrainLabels()
    }
    
    func constrainLabels() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        valueLabel.centerYRancor.constraintEqualToRancor(self.centerYRancor, constant: 4.0).active = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        titleLabel.bottomRancor.constraintEqualToRancor(valueLabel.topRancor).active = true
    }
}
