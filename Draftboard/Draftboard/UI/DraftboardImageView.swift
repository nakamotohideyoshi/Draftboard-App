//
//  DraftboardImageView.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/18/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class DraftboardImageView: UIImageView {
    
    override func didMoveToSuperview() {
        let image = self.image
        self.image = nil
        self.image = image
        
        super.didMoveToSuperview()
    }
    
    @IBInspectable var downsample: Bool = false {
        didSet {
            if (downsample) {
                self.layer.minificationFilter = kCAFilterTrilinear
            } else {
                self.layer.minificationFilter = kCAFilterLinear
            }
        }
    }
}
