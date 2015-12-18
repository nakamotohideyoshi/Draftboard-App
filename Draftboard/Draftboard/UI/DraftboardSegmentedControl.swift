//
//  DraftboardSegmentedControl.swift
//  Draftboard
//
//  Created by Wes Pearce on 12/2/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardSegmentedControl: UIView {
    var choices: [String]!
    var controls: [DraftboardControlSegment]!
    var lineView: UIView!
    
    var lineConstraint: NSLayoutConstraint?
    var selectionSpring: Spring?
    
    var textColor: UIColor!
    var textSelectedColor: UIColor!
    
    var indexChangedHandler:((Int)->Void)?
    var currentIndex = 0
    
    init(choices _choices: [String], textColor _textColor: UIColor, textSelectedColor _textSelectedColor: UIColor) {
        super.init(frame: CGRectMake(0.0, 0.0, 100.0, 100.0))
        choices = _choices
        textColor = _textColor
        textSelectedColor = _textSelectedColor
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        // Stuff we need
        let choiceWidth = 1.0 / CGFloat(choices.count);
        controls = [DraftboardControlSegment]()
        
        // Create controls
        var lastControl: UIControl?
        for (_, choice) in choices.enumerate() {
            let control = DraftboardControlSegment(textValue: choice, textColor: textColor, textSelectedColor: textSelectedColor)
            
            self.addSubview(control)
            control.translatesAutoresizingMaskIntoConstraints = false
            control.widthRancor.constraintEqualToRancor(self.widthRancor, multiplier: choiceWidth).active = true
            control.heightRancor.constraintEqualToRancor(self.heightRancor).active = true
            control.topRancor.constraintEqualToRancor(self.topRancor).active = true
            
            control.addTarget(self, action: "buttonTap:", forControlEvents: .TouchDown)
            
            if (lastControl != nil) {
                control.leftRancor.constraintEqualToRancor(lastControl?.rightRancor).active = true
            }
            else {
                control.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
            }
            
            controls.append(control)
            lastControl = control;
        }
        
        // Create selection indicator
        if (controls.count > 0) {
            let firstControl = controls[0]
            firstControl.label.textColor = textSelectedColor
            
            lineView = UIView(frame: CGRectZero)
            lineView.backgroundColor = textSelectedColor
            self.addSubview(lineView)
            
            lineView.translatesAutoresizingMaskIntoConstraints = false
            lineView.topRancor.constraintEqualToRancor(firstControl.label.bottomRancor, constant: 1.0).active = true
            lineView.widthRancor.constraintEqualToConstant(30.0).active = true
            lineView.heightRancor.constraintEqualToConstant(2.0).active = true
            
            lineConstraint = lineView.leftRancor.constraintEqualToRancor(firstControl.label.leftRancor)
            lineConstraint!.active = true
        }
    }
    
    func buttonTap(control: DraftboardControlSegment) {
        let index = controls.indexOf(control)
        
        if (index != nil) {
            updateSelectionLine(index!, animated: true)
        }
    }
    
    func updateSelectionLine(index: Int, animated: Bool) {
        
        // Bail if index is out of range
        let lastIndex = controls.count - 1
        if (index < 0 || index > lastIndex || index == currentIndex) {
            return;
        }
        
        // Update index
        currentIndex = index;
        
        // Deselect other buttons
        for (i, control) in controls.enumerate() {
            if (i == index) {
                control.selectedState = true;
                continue;
            }
            
            control.selectedState = false;
        }
        
        // Remove old line constraint
        lineConstraint?.active = false
        
        // Get selected control
        let control = controls[index]
        
        if (index == 0) {
            lineConstraint = lineView.leftRancor.constraintEqualToRancor(control.label.leftRancor)
        }
        else if (index > 0 && index < lastIndex) {
            lineConstraint = lineView.centerXRancor.constraintEqualToRancor(control.label.centerXRancor)
        }
        else if (index == lastIndex) {
            lineConstraint = lineView.rightRancor.constraintEqualToRancor(control.label.rightRancor)
        }
        
        // Activate update constraint
        lineConstraint?.active = true
        
        // Remove animations
        selectionSpring?.stop()
        selectionSpring = nil
        
        // Animate the change?
        if (animated) {
            
            // Apply constraints
            let startPos = NSValue(CGPoint: lineView.layer.position).CGPointValue()
            self.layoutIfNeeded() // Updates layer position
            
            let endPos = NSValue(CGPoint: lineView.layer.position).CGPointValue()
            let deltaPos = CGPointMake(endPos.x - startPos.x, endPos.y - startPos.y)
            
            // Update line position
            lineView.layer.position = startPos
            selectionSpring = Spring(stiffness: 3.0, damping: 0.74, velocity: 0.0)
            selectionSpring!.updateBlock = { (value) -> Void in
                self.lineView.layer.position = CGPointMake(startPos.x + (deltaPos.x * value), startPos.y + (deltaPos.y * value))
            }
            selectionSpring!.start()
        }
        
        // Fire off handler
        indexChangedHandler?(currentIndex);
    }
}

class DraftboardControlSegment: UIControl {
    var label: DraftboardLabel!
    
    var textColor: UIColor!
    var textSelectedColor: UIColor!
    
    init(textValue: String, textColor _textColor: UIColor, textSelectedColor _textSelectedColor: UIColor) {
        super.init(frame: CGRectZero)
        
        textColor = _textColor
        textSelectedColor = _textSelectedColor
        
        label = DraftboardLabel(frame: CGRectMake(0.0, 0.0, 100.0, 20.0))
        label.font = UIFont(name: "OpenSans-Bold", size: 10.0)
        label.textAlignment = .Center
        label.textColor = _textColor
        label.letterSpacing = 1.0
        label.text = textValue.uppercaseString

        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        label.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var selectedState: Bool = false {
        didSet {
            if (selectedState) {
                label.textColor = textSelectedColor
            } else {
                label.textColor = textColor
            }
        }
    }
}