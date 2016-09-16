//
//  DraftboardControl.swift
//  Draftboard
//
//  Created by Anson Schall on 9/14/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

// See also: DraftboardView
class DraftboardControl: UIControl {
    
    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    override convenience init(frame: CGRect) {
        self.init()
        self.frame = frame
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        // Override and call super.setup()
    }
    
}
