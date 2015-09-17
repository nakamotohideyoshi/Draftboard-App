//
//  LineupCell.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/14/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupCellView: UIView {
    
    @IBOutlet weak var topBorderView: UIView!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var avgValueLabel: UILabel!
    
    var onTap:DraftClosure?
    var pressRecognizer = UILongPressGestureRecognizer()
    let tapRecognizer = UITapGestureRecognizer()
    
    let selectedView = UIView()
    var view : UIView!
    var selected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LineupCellView", bundle: bundle)
        
        self.backgroundColor = .whiteColor()
        view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        view.topRancor.constraintEqualToRancor(self.topRancor).active = true
        view.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
        view.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        view.backgroundColor = .clearColor()
        
        selectedView.frame = self.bounds
        selectedView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        selectedView.backgroundColor = .yellowColor()
        selectedView.hidden = true
        selectedView.alpha = 0
        
        self.addSubview(selectedView)
        self.sendSubviewToBack(selectedView)
        
        tapRecognizer.addTarget(self, action: "handleTap:")
        self.addGestureRecognizer(tapRecognizer)
        
        bottomBorderView.hidden = true
    }
    
    func selectAnimated(animated: Bool) {
        if (selected) {
            return
        }
        
        selected = true
        selectedView.hidden = false
        selectedView.layer.removeAllAnimations()
        
        if (animated) {
            UIView.animateWithDuration(1.0) { () -> Void in
                self.selectedView.alpha = 1
            }
        } else {
            selectedView.alpha = 1
            selectedView.hidden = false
        }
    }
    
    func deselectAnimated(animated: Bool) {
        if (!selected) {
            return
        }

        selected = false
        selectedView.layer.removeAllAnimations()
        
        if (animated) {
            UIView.animateWithDuration(0.4, animations: {
                self.selectedView.alpha = 0
            }, completion: { (value: Bool) in
                self.selectedView.hidden = true
            })
        } else {
            selectedView.hidden = true
            selectedView.alpha = 0
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
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        deselectAnimated(true)
        super.touchesCancelled(touches, withEvent:event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        deselectAnimated(true)
        super.touchesEnded(touches, withEvent:event)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        onTap?(target: self)
    }
}
