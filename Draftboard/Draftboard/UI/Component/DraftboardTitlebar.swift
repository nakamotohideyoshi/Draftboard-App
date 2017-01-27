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
    case Directionless
    case None
}

protocol DraftboardTitlebarDelegate {
    func didTapTitlebarButton(buttonType: TitlebarButtonType)
}

protocol DraftboardTitlebarDataSource {
    func titlebarTitle() -> String?
    func titlebarAttributedTitle() -> NSMutableAttributedString?
    func titlebarSubtitle() -> String?
    func titlebarAttributedSubtitle() -> NSMutableAttributedString?
    func titlebarLeftButtonType() -> TitlebarButtonType?
    func titlebarRightButtonType() -> TitlebarButtonType?
    func titlebarLeftButtonText() -> String?
    func titlebarRightButtonText() -> String?
    func titlebarBgHidden() -> Bool
}

@IBDesignable
class DraftboardTitlebar: UIView {
    
    var titleLabel: UILabel?
    var subtitleLabel: UILabel?
    var rightButton: DraftboardTitlebarButton?
    var leftButton: DraftboardTitlebarButton?
    var bgView: UIImageView!
    
    var delegate: DraftboardTitlebarDelegate?
    var dataSource: DraftboardTitlebarDataSource?
    
    var newLeftButton: DraftboardTitlebarButton?
    var newRightButton: DraftboardTitlebarButton?
    var newTitleLabel: UILabel?
    var newSubtitleLabel: UILabel?
    var newBgHidden: Bool = false
    
    var leftButtonChanged = false
    var rightButtonChanged = false
    var titleLabelChanged = false
    var subtitleLabelChanged = false
    var bgHiddenChanged = false
    
    var bgHidden = false
    var completionHandler:((Bool)->Void)?
    
    convenience init() {
        self.init(frame: CGRectZero)
        
        bgView = UIImageView(image: UIImage(named: "photographic-bg"))
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
        let newSubtitleText = dataSource?.titlebarSubtitle()
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
        subtitleLabelChanged = newSubtitleText != subtitleLabel?.text
        bgHiddenChanged = newBgHidden != bgHidden
        
        // Different left button
        if (leftButtonChanged) {
            
            // Create new left button
            if let buttonType = newLeftButtonType {
                newLeftButton = DraftboardTitlebarButton(type: buttonType)
                newLeftButton!.addTarget(self, action: .didTapButton, forControlEvents: .TouchUpInside)
                
                if (buttonType == .Value || buttonType == .DisabledValue) {
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
                newRightButton?.addTarget(self, action: .didTapButton, forControlEvents: .TouchUpInside)
                
                if (buttonType == .Value || buttonType == .DisabledValue) {
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
        
        // Different subtitle
        if (subtitleLabelChanged) {
            newSubtitleLabel = subtitleLabelWithText(newTitleText)
            addSubview(newSubtitleLabel!)
            constrainSubtitleLabel(newSubtitleLabel!)
        }
    }
    
    func removeAnimations() {
        leftButton?.layer.removeAllAnimations()
        rightButton?.layer.removeAllAnimations()
        titleLabel?.layer.removeAllAnimations()
        bgView.layer.removeAllAnimations()
    }
    
    // MARK: Animation
    
    func pushElements(directionless directionless: Bool = false, animated: Bool = true) {
        self.updateElements()
        var style: TitlebarTransitionStyle = .None
        if (animated) {
            style = (directionless) ? .Directionless : .Forward
        }
        transitionElements(style)

    }
    
    func popElements(directionless directionless: Bool = false, animated: Bool = true) {
        self.updateElements()
        var style: TitlebarTransitionStyle = .None
        if (animated) {
            style = (directionless) ? .Directionless : .Back
        }
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
        var dir: CGFloat = 0.0
        if (style != .Directionless) {
            dir = (style == .Forward) ? -1.0 : 1.0
        }
        
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
        
        newSubtitleLabel?.alpha = 0.0
        newSubtitleLabel?.layer.transform = inT
        
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
            
            if (self.subtitleLabelChanged) {
                self.subtitleLabel?.alpha = 0
                self.subtitleLabel?.layer.transform = ouT
                
                self.newSubtitleLabel?.alpha = 1.0
                self.newSubtitleLabel?.layer.transform = idT
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
        
        if (self.subtitleLabelChanged) {
            subtitleLabel?.removeFromSuperview()
            subtitleLabel = newSubtitleLabel
            newSubtitleLabel = nil
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
    
    func titleLabelWithText(text: String?) -> UILabel {
        let label = UILabel()
        
        label.textAlignment = .Center
        label.numberOfLines = 2
        label.attributedText = dataSource?.titlebarAttributedTitle()
        
        return label
    }
    
    func constrainLabel(label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
        label.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        label.widthRancor.constraintEqualToRancor(self.widthRancor, multiplier: 0.5).active = true
    }
    
    // MARK: Subtitle
    
    func subtitleLabelWithText(text: String?) -> UILabel {
        let label = UILabel()
        
        label.textAlignment = .Center
        label.numberOfLines = 2
        label.attributedText = dataSource?.titlebarAttributedSubtitle()
        
        return label
    }
    
    func constrainSubtitleLabel(label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYRancor.constraintEqualToRancor(self.centerYRancor, constant: 20).active = true
        label.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        label.widthRancor.constraintEqualToRancor(self.widthRancor, multiplier: 0.5).active = true
    }
    
    // MARK: Buttons
    
    func constrainButton(button: DraftboardTitlebarButton) {
        if (button.buttonType == .Value || button.buttonType == .DisabledValue) {
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
        
        if (button.buttonType == .Value || button.buttonType == .DisabledValue) {
            button.rightRancor.constraintEqualToRancor(self.rightRancor, constant: -10.0).active = true
        } else {
            button.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        }
            
        self.constrainButton(button)
    }
    
    func setSubtitle(subtitle:String, color:UIColor) {
        if subtitleLabel != nil {
            // Create attributed string
            let attrStr = NSMutableAttributedString(string: subtitle.uppercaseString)
            
            // Kerning
            let wholeStr = NSMakeRange(0, attrStr.length)
            attrStr.addAttribute(NSKernAttributeName, value: 0.0, range: wholeStr)
            
            // Font
            if let font = UIFont.draftboardTitlebarSubtitleFont() {
                attrStr.addAttribute(NSFontAttributeName, value: font, range: wholeStr)
            }
            
            // Line height
            let pStyle = NSMutableParagraphStyle()
            pStyle.lineHeightMultiple = 1.0
            pStyle.lineBreakMode = .ByTruncatingMiddle
            pStyle.alignment = .Center
            attrStr.addAttribute(NSParagraphStyleAttributeName, value: pStyle, range: wholeStr)
            
            // Color
            attrStr.addAttribute(NSForegroundColorAttributeName, value: color, range: wholeStr)
            
            subtitleLabel?.attributedText = attrStr
            
        }
    }
}

private extension Selector {
    static let didTapButton = #selector(DraftboardTitlebar.didTapButton(_:))
}
