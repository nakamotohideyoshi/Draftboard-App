//
//  DraftboardNibView.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardNibControl: UIControl {
    var nibView: UIView!
    var _selectedView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    func setupNib() {
        nibView = self.loadNib()
        nibView.frame = self.bounds
        nibView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        nibView.userInteractionEnabled = false
        
        self.addSubview(nibView)
        self.awakeFromNib()
    }
    
    func loadNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let views = bundle.loadNibNamed(self.nibName(), owner: self, options: nil)
        return views.first as! UIView
    }
    
    func nibName() -> String {
        return self.dynamicType.description().componentsSeparatedByString(".").last!
    }
    
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                self._selectedView?.hidden = false
            }
            else {
                self._selectedView?.hidden = true
            }
        }
    }
    
    override var selected: Bool {
        didSet {
            if (selected) {
                self._selectedView?.hidden = false
            }
            else {
                self._selectedView?.hidden = true
            }
        }
    }
    
    func deselectAnimated(animated: Bool) {
        if (!selected) {
            return
        }
        selected = false
        
        if (animated) {
            _selectedView?.layer.removeAllAnimations()
            _selectedView?.hidden = false
            
            UIView.animateWithDuration(0.4, animations: {
                self._selectedView?.alpha = 0
            }, completion: { (value: Bool) in
                self._selectedView?.hidden = true
            })
        }
    }
}
