//
//  LineupCardToggle.swift
//  Draftboard
//
//  Created by Wes Pearce on 1/25/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

enum LineupCardToggleOption {
    case Points
    case FantasyPoints
    case Salary
    
    static let allValues = [Points, FantasyPoints, Salary]
    
    func toggleText() -> String {
        switch self {
            case .Points:
                return "POINTS"
            case .FantasyPoints:
                return "AVG FPPG"
            case .Salary:
                return "SALARY"
        }
    }
}

protocol LineupCardToggleDelegate {
    func didSelectToggleOption(option: LineupCardToggleOption)
}

class LineupCardToggle: UIView {
    var buttons: [DraftboardToggleButton] = []
    var delegate: LineupCardToggleDelegate?
    var selectedOption: LineupCardToggleOption
    
    init(option: LineupCardToggleOption) {
        selectedOption = option
        super.init(frame: CGRectZero)
        
        // Loop over toggle options
        let count = CGFloat(LineupCardToggleOption.allValues.count)
        for (_, option) in LineupCardToggleOption.allValues.enumerate() {
            
            // Create button
            let b = buttonWithOption(option)
            b.disabled = (option == selectedOption)
            b.addTarget(self, action: Selector("didTapButton:"), forControlEvents: .TouchUpInside)
            addSubview(b)
            
            // Constrain button
            b.translatesAutoresizingMaskIntoConstraints = false
            b.widthRancor.constraintEqualToRancor(self.widthRancor, multiplier: 1.0 / count).active = true
            b.heightRancor.constraintEqualToConstant(20.0).active = true
            b.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
            
            // Constrain to last button
            if let lastButton = buttons.last {
                b.leftRancor.constraintEqualToRancor(lastButton.rightRancor).active = true
            }
            else {
                b.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
            }
            
            // Keep button
            buttons.append(b)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectOption(option: LineupCardToggleOption) {
        if option == selectedOption {
            return
        }
        
        for (_, button) in buttons.enumerate() {
            if button.option == option {
                button.disabled = true
                continue
            }
            
            button.disabled = false
        }
        
        selectedOption = option
    }
    
    func didTapButton(button: DraftboardToggleButton) {
        let option = button.option
        
        if (selectedOption == option) {
            return
        }
        
        selectOption(option)
        delegate?.didSelectToggleOption(option)
    }
    
    func buttonWithOption(option: LineupCardToggleOption) -> DraftboardToggleButton {
        let b = DraftboardToggleButton(option: option)
        b.textValue = option.toggleText()
        return b
    }
}
