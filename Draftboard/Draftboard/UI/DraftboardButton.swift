//
//  DraftboardButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class DraftboardButton: UIView {

    var view : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup(){
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "DraftboardButton", bundle: bundle)
        view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        view.topRancor.constraintEqualToRancor(self.topRancor).active = true
        view.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
        view.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        
        self.layer.borderColor = UIColor.greenColor().CGColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 2.0
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.greenColor() {
        didSet {
            self.layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
