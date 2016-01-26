//
//  LineupCardToggle.swift
//  Draftboard
//
//  Created by Wes Pearce on 1/25/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

protocol LineupCardToggleDelegate {
    func didTapToggleButton(index: Int)
}

class LineupCardToggle: UIView {
    var buttons: [DraftboardButton] = []
    var delegate: LineupCardToggleDelegate?
    var index: Int = 0

    init(options: [String]) {
        super.init(frame: CGRectZero)
        
        let count = CGFloat(options.count)
        for (i, option) in options.enumerate() {
            let b = buttonWithTitle(option)
            self.addSubview(b)
            
            b.addTarget(self, action: Selector("didTapButton:"), forControlEvents: .TouchUpInside)
            b.tag = i
            
            b.translatesAutoresizingMaskIntoConstraints = false
            b.widthRancor.constraintEqualToRancor(self.widthRancor, multiplier: 1.0 / count).active = true
            b.heightRancor.constraintEqualToConstant(20.0).active = true
            b.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
            
            if let lastButton = buttons.last {
                b.leftRancor.constraintEqualToRancor(lastButton.rightRancor).active = true
            }
            else {
                b.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
            }
            
            buttons.append(b)
        }
        
        buttons[0].disabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectButton(idx: Int) {
        if idx == index || buttons.count <= 0 {
            return
        }
        
        var i = min(idx, buttons.count - 1)
        i = max(i, 0)
        
        for (_, button) in buttons.enumerate() {
            button.disabled = false
        }
        
        buttons[i].disabled = true
        index = i
    }
    
    func didTapButton(button: DraftboardButton) {
        if (index == button.tag) {
            return
        }
        
        selectButton(button.tag)
        delegate?.didTapToggleButton(button.tag)
    }
    
    func buttonWithTitle(title: String) -> DraftboardButton {
        let b = DraftboardButton()
        b.bgColor = .clearColor()
        b.textColor = UIColor(0x6d718a, alpha: 0.8)
        b.textValue = title
        b.cornerRadius = 10.0
        
        b.bgDisabledColor = UIColor(0x495b78, alpha: 0.5)
        b.textDisabledColor = .whiteColor()
        
        return b
    }
}
