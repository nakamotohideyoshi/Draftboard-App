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

@IBDesignable
class DraftboardTabBar: DraftboardNibView {
    
    @IBOutlet weak var lineupsButton: DraftboardTabBarButton!
    @IBOutlet weak var contestsButton: DraftboardTabBarButton!
    @IBOutlet weak var profileButton: DraftboardTabBarButton!
    
    @IBOutlet weak var lineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectionLine: UIView!
    
    var delegate: DraftboardTabBarDelegate?
    var buttons: [DraftboardTabBarButton]!
    var selectedIndex = 0
    
    override func willAwakeFromNib() {
        buttons = [lineupsButton, contestsButton, profileButton]
        
        lineupsButton.buttonType = .Lineups
        contestsButton.buttonType = .Contests
        profileButton.buttonType = .Profile
        
        iconColor = .whiteColor()
        selectedColor = .draftboardAccentColor()
        
        for (_, button) in buttons.enumerate() {
            button.addTarget(self, action: "buttonTap:", forControlEvents: .TouchUpInside)
        }
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
