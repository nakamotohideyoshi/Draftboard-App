//
//  SelectableView.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/21/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class TappableView: UIView {
    
    // Tap handler
    let tapRecognizer = UITapGestureRecognizer()
    var onTap:DraftClosure?
    
    // Selected state
    var selectedView: UIView?
    var selected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tapRecognizer.addTarget(self, action: "handleTap:")
        self.addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectAnimated(animated: Bool) {
        if (selected) {
            return
        }
        
        selected = true
        selectedView?.hidden = false
        selectedView?.layer.removeAllAnimations()
        
        if (animated) {
            UIView.animateWithDuration(1.0) { () -> Void in
                self.selectedView?.alpha = 1
            }
        } else {
            selectedView?.alpha = 1
            selectedView?.hidden = false
        }
    }
    
    func deselectAnimated(animated: Bool) {
        if (!selected) {
            return
        }
        
        selected = false
        selectedView?.layer.removeAllAnimations()
        
        if (animated) {
            UIView.animateWithDuration(0.4, animations: {
                self.selectedView?.alpha = 0
                }, completion: { (value: Bool) in
                    self.selectedView?.hidden = true
            })
        } else {
            selectedView?.hidden = true
            selectedView?.alpha = 0
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first {
            self.selectAnimated(false)
        }
        
        super.touchesBegan(touches, withEvent:event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let inside = CGRectContainsPoint(self.bounds, touch.locationInView(self))
            
            if (inside) {
                selectAnimated(true)
            }
            else {
                deselectAnimated(true)
            }
        }
        
        super.touchesMoved(touches, withEvent:event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        deselectAnimated(true)
        super.touchesEnded(touches, withEvent:event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        deselectAnimated(true)
        super.touchesCancelled(touches, withEvent:event)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        onTap?(target: self)
    }
}
