//
//  DraftboardTitlebar.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/23/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

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
class DraftboardTitlebar: DraftboardNibView {
    
    @IBOutlet weak var titleLabel: DraftboardLabel?
    @IBOutlet weak var rightButton: DraftboardTitlebarButton?
    @IBOutlet weak var leftButton: DraftboardTitlebarButton?
    @IBOutlet weak var bgView: DraftboardView!
    
    var delegate: DraftboardTitlebarDelegate?
    
    var newLeftButton: DraftboardTitlebarButton?
    var newRightButton: DraftboardTitlebarButton?
    var newTitleLabel: DraftboardLabel?
    var newBgHidden: Bool = false
    
    var leftButtonChanged = false
    var rightButtonChanged = false
    var titleLabelChanged = false
    var bgHiddenChanged = false
    
    var bgHidden = false
    
    var loaded = false
    var completionHandler:((Bool)->Void)?
    
    override func willAwakeFromNib() {
        super.willAwakeFromNib()
        titleLabel?.textColor = .whiteColor()
        bgView.backgroundColor = UIColor(0x25344c, alpha:0.4)
    }
    
    var dataSource: DraftboardTitlebarDataSource? {
        
        // Set values
        willSet {
            stopAnimating()
            
            let newLeftButtonType = newValue?.titlebarLeftButtonType()
            let newRightButtonType = newValue?.titlebarRightButtonType()
            let newTitleText = newValue?.titlebarTitle()
            
            // Background value
            if let nv = newValue {
                newBgHidden = nv.titlebarBgHidden()
            } else {
                newBgHidden = true
            }
            
            // Different left button
            leftButtonChanged = newLeftButtonType != leftButton?.buttonType
            if (leftButtonChanged) {

                // Create new left button
                if let buttonType = newLeftButtonType {
                    newLeftButton = DraftboardTitlebarButton(type: buttonType)
                    newLeftButton?.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
                    
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
            rightButtonChanged = newRightButtonType != rightButton?.buttonType
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
            titleLabelChanged = newTitleText != titleLabel?.text
            if (titleLabelChanged) {
                newTitleLabel = titleLabelWithText(newValue?.titlebarTitle())
                addSubview(newTitleLabel!)
                constrainLabel(newTitleLabel!)
            }
            
            // Different bg state
            bgHiddenChanged = newBgHidden != bgHidden
        }
        didSet {
            
            // Animate
            changeElementsAnimated(loaded)
            loaded = true
        }
    }
    
    func stopAnimating() {
        completionHandler?(false)
        completionHandler = nil
        
        self.leftButton?.layer.removeAllAnimations()
        self.rightButton?.layer.removeAllAnimations()
        self.titleLabel?.layer.removeAllAnimations()
        self.bgView.layer.removeAllAnimations()
    }
    
    // MARK: Animation
    
    func changeElementsAnimated(animated: Bool) {
        
        completionHandler = { (completed: Bool) -> Void in
            if (self.leftButtonChanged) {
                self.leftButton?.removeFromSuperview()
                self.leftButton = self.newLeftButton
                self.newLeftButton = nil
            }
            if (self.rightButtonChanged) {
                self.rightButton?.removeFromSuperview()
                self.rightButton = self.newRightButton
                self.newRightButton = nil
            }
            if (self.titleLabelChanged) {
                self.titleLabel?.removeFromSuperview()
                self.titleLabel = self.newTitleLabel
                self.newTitleLabel = nil
            }
            if (self.bgHiddenChanged) {
                if (completed) {
                    if (self.newBgHidden) {
                         self.bgView.layer.transform = CATransform3DMakeScale(0.0, 1.0, 1.0)
                    } else {
                         self.bgView.layer.transform = CATransform3DIdentity
                    }
                }
                
                self.bgHidden = self.newBgHidden
            }
        }
        
        // Finish immediately
        if (!animated) {
            completionHandler?(true)
            completionHandler = nil
            return
        }
        
        // Layer transforms
        let outTrans = CATransform3DMakeTranslation(40.0, 0.0, 0.0)
        let inTrans = CATransform3DMakeTranslation(-40.0, 0.0, 0.0)
        
        // Start hidden
        self.newLeftButton?.alpha = 0.0
        //self.newLeftButton?.layer.transform = inTrans
        
        self.newRightButton?.alpha = 0.0
        //self.newRightButton?.layer.transform = inTrans
        
        self.newTitleLabel?.alpha = 0.0
        self.newTitleLabel?.layer.transform = inTrans
        
        // Crossfade
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            if (self.leftButtonChanged) {
                self.leftButton?.alpha = 0
                //self.leftButton?.layer.transform = outTrans
                
                self.newLeftButton?.alpha = 1.0
                //self.newLeftButton?.layer.transform = CATransform3DIdentity
            }
            if (self.rightButtonChanged) {
                self.rightButton?.alpha = 0
                //self.rightButton?.layer.transform = outTrans
                
                self.newRightButton?.alpha = 1.0
                //self.newRightButton?.layer.transform = CATransform3DIdentity
            }
            if (self.titleLabelChanged) {
                self.titleLabel?.alpha = 0
                self.titleLabel?.layer.transform = outTrans
                
                self.newTitleLabel?.alpha = 1.0
                self.newTitleLabel?.layer.transform = CATransform3DIdentity
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
        button.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
        button.widthRancor.constraintEqualToRancor(self.widthRancor, multiplier: 0.16).active = true
        button.heightRancor.constraintEqualToRancor(self.heightRancor).active = true
    }
    
    func constrainLeftButton(button: DraftboardTitlebarButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        self.constrainButton(button)
    }
    
    func constrainRightButton(button: DraftboardTitlebarButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        self.constrainButton(button)
    }
}
