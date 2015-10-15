//
//  DraftboardTitlebar.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/23/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

enum TitlebarTransitionStyle {
    case Forward
    case Back
    case None
}

protocol DraftboardTitlebarDelegate {
    func didTapTitlebarButton(buttonType: TitlebarButtonType)
}

protocol DraftboardTitlebarDataSource {
    func titlebarTitle() -> String?
    func titlebarLeftButtonType() -> TitlebarButtonType?
    func titlebarRightButtonType() -> TitlebarButtonType?
    func titlebarLeftButtonText() -> String?
    func titlebarRightButtonText() -> String?
    func titlebarBgHidden() -> Bool
}

@IBDesignable
class DraftboardTitlebar: UIView {
    
    var titleLabel: DraftboardLabel?
    var rightButton: DraftboardTitlebarButton?
    var leftButton: DraftboardTitlebarButton?
    var bgView: UIView!
    
    var delegate: DraftboardTitlebarDelegate?
    var dataSource: DraftboardTitlebarDataSource?
    
    var newLeftButton: DraftboardTitlebarButton?
    var newRightButton: DraftboardTitlebarButton?
    var newTitleLabel: DraftboardLabel?
    var newBgHidden: Bool = false
    
    var leftButtonChanged = false
    var rightButtonChanged = false
    var titleLabelChanged = false
    var bgHiddenChanged = false
    
    var bgHidden = false
    var completionHandler:((Bool)->Void)?
    
    convenience init() {
        self.init(frame: CGRectZero)
        
        bgView = UIView()
        bgView.backgroundColor = UIColor(0x25344c, alpha:0.4)
        self.addSubview(bgView)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.leftRancor.constraintEqualToRancor(leftRancor).active = true
        bgView.rightRancor.constraintEqualToRancor(rightRancor).active = true
        bgView.bottomRancor.constraintEqualToRancor(bottomRancor).active = true
        bgView.topRancor.constraintEqualToRancor(topRancor).active = true
    }
    
    func updateElements() {
        completionHandler?(false)
        completionHandler = nil
        
        let newLeftButtonType = dataSource?.titlebarLeftButtonType()
        let newRightButtonType = dataSource?.titlebarRightButtonType()
        let newTitleText = dataSource?.titlebarTitle()
        
        // Background value
        if let ds = dataSource {
            newBgHidden = ds.titlebarBgHidden()
        } else {
            newBgHidden = true
        }
        
        // Different title
        leftButtonChanged = newLeftButtonType != leftButton?.buttonType
        rightButtonChanged = newRightButtonType != rightButton?.buttonType
        titleLabelChanged = newTitleText != titleLabel?.text
        bgHiddenChanged = newBgHidden != bgHidden
        
        // Different left button
        if (leftButtonChanged) {
            
            // Create new left button
            if let buttonType = newLeftButtonType {
                newLeftButton = DraftboardTitlebarButton(type: buttonType)
                newLeftButton!.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
                
                if (buttonType == .Value) {
                    if let textValue = dataSource?.titlebarLeftButtonText() {
                        newLeftButton!.textValue = textValue
                    }
                }
                
                // Position button
                addSubview(newLeftButton!)
                constrainLeftButton(newLeftButton!)
            }
        }
        
        // Different right button
        if (rightButtonChanged) {
            
            // Create new right button
            if let buttonType = newRightButtonType {
                newRightButton = DraftboardTitlebarButton(type: buttonType)
                newRightButton?.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
                
                if (buttonType == .Value) {
                    if let textValue = dataSource?.titlebarRightButtonText() {
                        newRightButton!.textValue = textValue
                    }
                }
                
                // Position button
                addSubview(newRightButton!)
                constrainRightButton(newRightButton!)
            }
        }
        
        // Different title
        if (titleLabelChanged) {
            newTitleLabel = titleLabelWithText(newTitleText)
            addSubview(newTitleLabel!)
            constrainLabel(newTitleLabel!)
        }
    }
    
    func removeAnimations() {
        leftButton?.layer.removeAllAnimations()
        rightButton?.layer.removeAllAnimations()
        titleLabel?.layer.removeAllAnimations()
        bgView.layer.removeAllAnimations()
    }
    
    // MARK: Animation
    
    func pushElements(animated animated: Bool = true) {
        self.updateElements()
        let style: TitlebarTransitionStyle = (animated) ? .Forward : .None
        transitionElements(style)
    }
    
    func popElements(animated animated: Bool = true) {
        self.updateElements()
        let style: TitlebarTransitionStyle = (animated) ? .Back : .None
        transitionElements(style)
    }
    
    func transitionElements(style: TitlebarTransitionStyle, duration: NSTimeInterval = 0.25) {
        
        // Finish immediately
        if (style == .None) {
            completeTransition(true)
            completionHandler = nil
            return
        }
        
        // Layer transforms
        let dir: CGFloat = (style == .Forward) ? -1.0 : 1.0
        
        // Transforms
        let ouT = CATransform3DMakeTranslation(40.0 * dir, 0.0, 0.0)
        let inT = CATransform3DMakeTranslation(-40.0 * dir, 0.0, 0.0)
        let idT = CATransform3DIdentity
        
        // Start hidden
        newLeftButton?.alpha = 0.0
        //newLeftButton?.layer.transform = inT
        
        newRightButton?.alpha = 0.0
        //newRightButton?.layer.transform = inT
        
        newTitleLabel?.alpha = 0.0
        newTitleLabel?.layer.transform = inT
        
        // Completion handler
        completionHandler = { (complete: Bool) in
            self.completeTransition(complete)
        }
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            if (self.leftButtonChanged) {
                self.leftButton?.alpha = 0
                //self.leftButton?.layer.transform = ouT
                
                self.newLeftButton?.alpha = 1.0
                //self.newLeftButton?.layer.transform = idT
            }
            
            if (self.rightButtonChanged) {
                self.rightButton?.alpha = 0
                //self.rightButton?.layer.transform = ouT
                
                self.newRightButton?.alpha = 1.0
                //self.newRightButton?.layer.transform = idT
            }
            
            if (self.titleLabelChanged) {
                self.titleLabel?.alpha = 0
                self.titleLabel?.layer.transform = ouT
                
                self.newTitleLabel?.alpha = 1.0
                self.newTitleLabel?.layer.transform = idT
            }
            
            if (self.bgHiddenChanged) {
                var bgTrans = CATransform3DIdentity
                if (self.newBgHidden) {
                    bgTrans = CATransform3DMakeScale(0.001, 1.0, 1.0)
                }
                
                self.bgView.layer.transform = bgTrans
            }
        }) { (complete) -> Void in
            self.completionHandler?(complete)
            self.completionHandler = nil
        }
    }
    
    func completeTransition(complete: Bool) {
        removeAnimations()
        
        if (leftButtonChanged) {
            leftButton?.removeFromSuperview()
            leftButton = newLeftButton
            newLeftButton = nil
        }
        
        if (rightButtonChanged) {
            rightButton?.removeFromSuperview()
            rightButton = newRightButton
            newRightButton = nil
        }
        
        if (self.titleLabelChanged) {
            titleLabel?.removeFromSuperview()
            titleLabel = newTitleLabel
            newTitleLabel = nil
        }
        
        if (self.bgHiddenChanged) {
            if (complete) {
                if (newBgHidden) {
                    bgView.layer.transform = CATransform3DMakeScale(0.0, 1.0, 1.0)
                } else {
                    bgView.layer.transform = CATransform3DIdentity
                }
            }
            
            bgHidden = newBgHidden
        }
    }
    
    // MARK: Delegate
    
    func didTapButton(sender: DraftboardTitlebarButton) {
        delegate?.didTapTitlebarButton(sender.buttonType!)
    }
    
    // MARK: Title
    
    func titleLabelWithText(text: String?) -> DraftboardLabel {
        let label = DraftboardLabel()
        
        label.textAlignment = .Center
        label.textColor = .whiteColor()
        label.font = .draftboardTitlebarTitleFont()
        label.lineBreakMode = .ByTruncatingTail
        label.numberOfLines = 2
        
        label.letterSpacing = 0.0
        label.lineHeightMultiple = 0.9
        label.text = text
        
        return label
    }
    
    func constrainLabel(label: DraftboardLabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
        label.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        label.widthRancor.constraintEqualToRancor(self.widthRancor, multiplier: 0.5).active = true
    }
    
    // MARK: Buttons
    
    func constrainButton(button: DraftboardTitlebarButton) {
        if (button.buttonType == .Value) {
            button.topRancor.constraintEqualToRancor(self.topRancor, constant: 10.0).active = true
            button.bottomRancor.constraintEqualToRancor(self.bottomRancor, constant: -10.0).active = true
            button.widthRancor.constraintEqualToRancor(self.widthRancor, multiplier: 0.16).active = true
        } else {
            button.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
            button.widthRancor.constraintEqualToRancor(self.widthRancor, multiplier: 0.16).active = true
            button.heightRancor.constraintEqualToRancor(self.heightRancor).active = true
        }
    }
    
    func constrainLeftButton(button: DraftboardTitlebarButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        self.constrainButton(button)
    }
    
    func constrainRightButton(button: DraftboardTitlebarButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if (button.buttonType == .Value) {
            button.rightRancor.constraintEqualToRancor(self.rightRancor, constant: -10.0).active = true
        } else {
            button.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        }
            
        self.constrainButton(button)
    }
}
