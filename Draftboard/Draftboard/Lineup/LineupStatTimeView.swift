//
//  LineupStatView.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupStatTimeView: LineupStatView {
    
    init(style _style: LineupStatStyle, titleText _titleText: String?, date _date: NSDate?) {
        super.init(style: _style, titleText: _titleText, valueText: nil)
        
        date = _date
        let size: CGFloat = (style == .Large) ? 20.0 : 12.0
        let constant: CGFloat = (style == .Large) ? 7.0 : 4.0
        
        valueLabel.removeFromSuperview()
        valueLabel = CountdownView(date: _date ?? NSDate(), size: size, color: .whiteColor())

        addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        valueLabel.centerYRancor.constraintEqualToRancor(self.centerYRancor, constant: constant).active = true
        
        titleLabel.bottomRancor.constraintEqualToRancor(valueLabel.topRancor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var date: NSDate? {
        didSet {
            if let date = date {
                (self.valueLabel as! CountdownView).date = date
            }
        }
    }
    
}
