//
//  DraftboardLoadingButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 12/11/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardLoadingButton: DraftboardArrowButton {
    
    var loaderView: LoaderView!
    
    override func setDefaults() {
        super.setDefaults()
        
        loaderView = LoaderView(frame: CGRectZero)
        loaderView.hidden = true
        
        self.addSubview(loaderView)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.heightRancor.constraintEqualToRancor(self.heightRancor, multiplier: 0.6).active = true
        loaderView.widthRancor.constraintEqualToRancor(loaderView.heightRancor).active = true
        loaderView.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
        loaderView.rightRancor.constraintEqualToRancor(self.rightRancor, constant: -14.0) .active = true
        loaderView.thickness = 1.0
    }
    
    var loading: Bool = false {
        didSet {
            disabled = loading
            loaderView.updateMask()
            
            if (loading) {
                iconImageView.hidden = true
                loaderView.hidden = false
                loaderView.spinning = true
            }
            else {
                iconImageView.hidden = false
                loaderView.hidden = true
                loaderView.spinning = false
            }
        }
    }
}
