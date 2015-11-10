//
//  GlobalFilterItem.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/9/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class GlobalFilterItem: UIControl {
    
    var label: DraftboardLabel!
    var selectedLineView: UIView!
    var labelLeftConstraint: NSLayoutConstraint!
    var spring: Spring!
    var scale: CGFloat = 1.0
    var index = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        label = DraftboardLabel()
        label.font = .draftboardGlobalFilterFont()
        label.textColor = .whiteLowOpacity()
        label.letterSpacing = -2.0
        label.text = "Sport"
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
        labelLeftConstraint = label.leftRancor.constraintEqualToRancor(self.leftRancor, constant: 30.0)
        labelLeftConstraint.active = true
        
        selectedLineView = UIView()
        selectedLineView.backgroundColor = .greenDraftboard()
        
        addSubview(selectedLineView)
        selectedLineView.translatesAutoresizingMaskIntoConstraints = false
        selectedLineView.topRancor.constraintEqualToRancor(label.bottomRancor, constant: -8.0).active = true
        selectedLineView.leftRancor.constraintEqualToRancor(self.leftRancor, constant: 30.0).active = true
        selectedLineView.widthRancor.constraintEqualToRancor(self.widthRancor, multiplier: 0.4).active = true
        selectedLineView.heightRancor.constraintEqualToConstant(3.0).active = true
    }
    
    func underlined(underlined: Bool, animated: Bool = true) {
        spring?.cancel()
        spring = nil
        
        let startScale: CGFloat = scale
        let endScale: CGFloat = (underlined) ? 1.0 : 0.0
        let scaleDelta: CGFloat = endScale - startScale
        let lineHalfWidth = selectedLineView.bounds.size.width / 2.0
        
        let completionHandler = { (complete: Bool) in
            self.scale = endScale
            var t = CATransform3DMakeTranslation(-lineHalfWidth, 1.0, 1.0)
            t = CATransform3DScale(t, endScale, 1.0, 1.0)
            t = CATransform3DTranslate(t, lineHalfWidth, 0.0, 0.0)
            self.selectedLineView.layer.transform = t
        }
        
        if (!animated) {
            completionHandler(true)
            return
        }
        
        spring = Spring(stiffness: 8.0, damping: 0.45, velocity: 0.0)
        spring.updateBlock = { value in
            self.scale = startScale + (scaleDelta * value)
            var t = CATransform3DMakeTranslation(-lineHalfWidth, 1.0, 1.0)
            t = CATransform3DScale(t, self.scale, 1.0, 1.0)
            t = CATransform3DTranslate(t, lineHalfWidth, 0.0, 0.0)
            self.selectedLineView.layer.transform = t
        }
        spring.completeBlock = { completed in
            completionHandler(completed)
        }
        spring.start()
    }
    
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                label.textColor = .whiteColor()
            } else if (!selected) {
                label.textColor = .whiteLowOpacity()
            }
        }
    }

    override var selected: Bool {
        didSet {
            if (selected) {
                label.textColor = .whiteColor()
            } else {
                label.textColor = .whiteLowOpacity()
            }
        }
    }
    
    @IBInspectable
    var text: String = "Sport" {
        didSet {
            label.text = text
        }
    }
    
    @IBInspectable
    var adjustment: CGFloat = 0.0 {
        didSet {
            labelLeftConstraint.constant = 30.0 + adjustment
        }
    }
}
