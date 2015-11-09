//
//  GlobalFilterItem.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/9/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class GlobalFilterItem: UIControl {
    var label = DraftboardLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        label.font = .draftboardGlobalFilterFont()
        label.letterSpacing = -2.0
        label.text = "Sport"
        
        self.addSubview(label)
        constrainLabel()
    }
    
    func constrainLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        label.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
    }
    
    @IBInspectable
    var text: String = "Sport" {
        didSet {
            label.text = text
        }
    }
}
