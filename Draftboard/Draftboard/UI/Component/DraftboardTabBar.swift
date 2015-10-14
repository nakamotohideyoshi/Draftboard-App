//
//  DraftboardTabBar.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

protocol DraftboardTabBarDelegate {
    func didTapTabButton(buttonType: TabBarButtonType)
}

protocol DraftboardTabBarDataSource {
    func tabBarButtons() -> TabBarButtonType
}

@IBDesignable
class DraftboardTabBar: UIView {

    var lineLeftConstraint: NSLayoutConstraint?
    var lineRightConstraint: NSLayoutConstraint?
    var selectionLine: UIView!
    
    var delegate: DraftboardTabBarDelegate?
    var dataSource: DraftboardTabBarDataSource?
    
    var buttons = [DraftboardTabBarButton]()
    var selectedIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createButtons([.Lineups, .Contests, .Profile])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createButtons([.Lineups, .Contests, .Profile])
    }
    
    func createButtons(buttonTypes: TabBarButtonType) {
        self.backgroundColor = UIColor(0x192436)
        
        // Create buttons
        if (buttonTypes.contains(.Lineups)) {
            buttons.append(DraftboardTabBarButton(type: .Lineups))
        }
        if (buttonTypes.contains(.Contests)) {
            buttons.append(DraftboardTabBarButton(type: .Contests))
        }
        if (buttonTypes.contains(.Profile)) {
            buttons.append(DraftboardTabBarButton(type: .Profile))
        }
        
        // Constrain buttons
        let buttonWidthRatio = 1.0 / CGFloat(buttons.count)
        
        for (i, button) in buttons.enumerate() {
            self.addSubview(button)
            button.addTarget(self, action: "buttonTap:", forControlEvents: .TouchUpInside)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.topRancor.constraintEqualToRancor(self.topRancor).active = true
            button.widthRancor.constraintEqualToRancor(self.widthRancor, multiplier: buttonWidthRatio).active = true
            button.heightRancor.constraintEqualToRancor(self.heightRancor).active = true
            
            if (i == 0) { // First button
                button.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
            }
            else if (i > 0 && i < buttons.count-1) { // Middle buttons
                let previousButton = buttons[i-1]
                button.leftRancor.constraintEqualToRancor(previousButton.rightRancor).active = true
            }
            else if (i == buttons.count-1) { // Last button
                button.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
            }
        }
        
        // Create selection line
        selectionLine = UIView()
        self.addSubview(selectionLine)
        
        // Constrain selection line
        selectionLine.translatesAutoresizingMaskIntoConstraints = false
        selectionLine.heightRancor.constraintEqualToConstant(2.0).active = true
        selectionLine.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
        
        // Move selected line
        updateSelectionLine(selectedIndex, animated: false)
        
        // Set default colors
        iconColor = .whiteColor()
        selectedColor = .draftboardAccentColor()
    }
    
    func buttonTap(button: DraftboardTabBarButton) {
        let index = buttons.indexOf(button)
        if (index != nil) {
            selectButtonAtIndex(index!, animated: true)
        }
    }
    
    func selectButtonAtIndex(index: Int, animated: Bool) {
        
        // Nothing has changed
        if (selectedIndex == index) {
            return
        }
        
        // Update index
        selectedIndex = index
        
        // Deselect all buttons
        for (_, button) in buttons.enumerate() {
            button.iconColor = iconColor
        }
        
        // Select correct button
        let button = buttons[index]
        button.iconColor = selectedColor
        
        // Update line
        self.updateSelectionLine(index, animated: animated)
        
        // Inform delegate
        self.delegate?.didTapTabButton(button.buttonType!)
    }
    
    func updateSelectionLine(index: Int, animated: Bool) {
        
        // Get selected button
        let button = buttons[index]
        
        // Remove old line constraints
        lineLeftConstraint?.active = false
        lineRightConstraint?.active = false
        
        // Create new line constraints
        lineLeftConstraint = selectionLine.leftRancor.constraintEqualToRancor(button.leftRancor)
        lineRightConstraint = selectionLine.rightRancor.constraintEqualToRancor(button.rightRancor)
        
        // Activate new line constraints
        lineLeftConstraint!.active = true
        lineRightConstraint!.active = true
        
        // Animate the change?
        if (animated) {
            
            // Apply constraints
            let fromValue = NSValue(CGPoint: selectionLine.layer.position)
            self.layoutIfNeeded()
            let toValue = NSValue(CGPoint: selectionLine.layer.position)
            
            // Create animation
            let anim = CABasicAnimation(keyPath: "position")
            anim.duration = 0.25
            anim.fromValue = fromValue
            anim.toValue = toValue
            anim.timingFunction = CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.320, 1.275)
            
            // Apply animation
            selectionLine.layer.removeAllAnimations()
            selectionLine.layer.addAnimation(anim, forKey: "position")
        }
    }
    
    @IBInspectable
    var selectedColor: UIColor = .draftboardAccentColor() {
        didSet {
            for (_, button) in buttons.enumerate() {
                button.iconHighlightColor = selectedColor
            }
            
            buttons[selectedIndex].iconColor = selectedColor
            selectionLine.backgroundColor = selectedColor
        }
    }
    
    @IBInspectable
    var iconColor: UIColor = .whiteColor() {
        didSet {
            for (_, button) in buttons.enumerate() {
                button.iconColor = iconColor
            }
            
            buttons[selectedIndex].iconColor = selectedColor
        }
    }
}
