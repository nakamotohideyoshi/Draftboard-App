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
}

@IBDesignable
class DraftboardTitlebar: DraftboardNibView {

    @IBOutlet weak var titleLabel: DraftboardLabel?
    @IBOutlet weak var rightButton: DraftboardTitlebarButton?
    @IBOutlet weak var leftButton: DraftboardTitlebarButton?
    
    var delegate: DraftboardTitlebarDelegate?
    
    var newLeftButton: DraftboardTitlebarButton?
    var newRightButton: DraftboardTitlebarButton?
    var newTitleLabel: DraftboardLabel?
    
    var leftButtonChanged = false
    var rightButtonChanged = false
    var titleLabelChanged = false
    
    var loaded = false
    var completionHandler:(()->Void)?
    
    override func willAwakeFromNib() {
        super.willAwakeFromNib()
        titleLabel?.textColor = .whiteColor()
    }
    
    var dataSource: DraftboardTitlebarDataSource? {
        
        // Set values
        willSet {
            stopAnimating()
            
            let newLeftButtonType = newValue?.titlebarLeftButtonType()
            let newRightButtonType = newValue?.titlebarRightButtonType()
            let newTitleText = newValue?.titlebarTitle()
            
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
        }
        didSet {
            
            // Animate
            changeElementsAnimated(loaded)
            loaded = true
        }
    }
    
    func stopAnimating() {
        completionHandler?()
        completionHandler = nil

        self.leftButton?.layer.removeAllAnimations()
        self.rightButton?.layer.removeAllAnimations()
        self.titleLabel?.layer.removeAllAnimations()
    }
    
    // MARK: Animation
    
    func changeElementsAnimated(animated: Bool) {
        
        completionHandler = { () -> Void in
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
        }
        
        // Finish immediately
        if (!animated) {
            completionHandler?()
            return
        }
        
        // Start hidden
        self.newLeftButton?.alpha = 0.0
        self.newRightButton?.alpha = 0.0
        self.newTitleLabel?.alpha = 0.0
        
        // Crossfade
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            if (self.leftButtonChanged) {
                self.leftButton?.alpha = 0
                self.newLeftButton?.alpha = 1.0
            }
            if (self.rightButtonChanged) {
                self.rightButton?.alpha = 0
                self.newRightButton?.alpha = 1.0
            }
            if (self.titleLabelChanged) {
                self.titleLabel?.alpha = 0
                self.newTitleLabel?.alpha = 1.0
            }
            
        }) { (complete) -> Void in
            self.completionHandler?()
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
