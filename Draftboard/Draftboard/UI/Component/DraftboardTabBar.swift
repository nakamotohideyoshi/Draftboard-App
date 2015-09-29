//
//  DraftboardTabBar.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

protocol DraftboardTabBarDelegate {
    func didTapTabButtonAtIndex(index: Int)
}

@IBDesignable
class DraftboardTabBar: DraftboardNibView {
    
    @IBOutlet weak var lineupsButton: DraftboardButton!
    @IBOutlet weak var contestsButton: DraftboardButton!
    @IBOutlet weak var profileButton: DraftboardButton!
    
    @IBOutlet weak var lineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectionLine: UIView!
    
    var delegate: DraftboardTabBarDelegate?
    var buttons: [DraftboardButton]!
    var selectedIndex = 0
    
    override func willAwakeFromNib() {
        buttons = [lineupsButton, contestsButton, profileButton]
        
        for (_, button) in buttons.enumerate() {
            button.addTarget(self, action: "buttonTap:", forControlEvents: .TouchUpInside)
            button.iconHighlightColor = selectedColor
            button.iconColor = iconColor
        }
    }
    
    func buttonTap(button: DraftboardButton) {
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
        self.delegate?.didTapTabButtonAtIndex(index)
    }
    
    func updateSelectionLine(index: Int, animated: Bool) {
        
        // Get selected button
        let button = buttons[index]
        
        // Remove old line constraints
        lineLeadingConstraint.active = false
        lineTrailingConstraint.active = false
        
        // Create new line constraints
        lineLeadingConstraint = selectionLine.leadingRancor.constraintEqualToRancor(button.leadingRancor)
        lineTrailingConstraint = selectionLine.trailingRancor.constraintEqualToRancor(button.trailingRancor)
        
        // Activate new line constraints
        lineTrailingConstraint.active = true
        lineLeadingConstraint.active = true
        
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
            anim.timingFunction = CAMediaTimingFunction(controlPoints: 0.390, 0.575, 0.565, 1.000)
            
            // Apply animation
            selectionLine.layer.removeAllAnimations()
            selectionLine.layer.addAnimation(anim, forKey: "position")
        }
    }
    
    @IBInspectable
    var selectedColor: UIColor = .draftboardGreen() {
        didSet {
            for (_, button) in buttons.enumerate() {
                button.iconHighlightColor = selectedColor
            }
            
            lineupsButton.iconColor = selectedColor
            selectionLine.backgroundColor = selectedColor
        }
    }
    
    @IBInspectable
    var iconColor: UIColor = .whiteColor() {
        didSet {
            for (_, button) in buttons.enumerate() {
                button.iconColor = iconColor
            }
        }
    }
}
