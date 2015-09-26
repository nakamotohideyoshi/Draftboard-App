//
//  DraftboardTitlebar.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/23/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

protocol DraftboardTitlebarDelegate {
    func didTapTitlebarButton(index: Int)
}

@IBDesignable
class DraftboardTitlebar: DraftboardNibView {

    @IBOutlet weak var titleLabel: DraftboardLabel!
    @IBOutlet weak var rightButton: DraftboardButton!
    @IBOutlet weak var leftButton: DraftboardButton!
    
    var delegate: DraftboardTitlebarDelegate?
    
    override func willAwakeFromNib() {
        super.willAwakeFromNib()
        
        titleLabel.textColor = .whiteColor()
        
        leftButton.iconColor = .whiteColor()
        rightButton.iconColor = .whiteColor()
        
        leftButton.iconHighlightColor = .draftboardGreen()
        rightButton.iconHighlightColor = .draftboardGreen()
        
        leftButton.bgHighlightColor = .clearColor()
        leftButton.bgColor = .clearColor()
        
        rightButton.bgHighlightColor = .clearColor()
        rightButton.bgColor = .clearColor()
        
        rightButton.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
        leftButton.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
    }
    
    func didTapButton(sender: UIControl) {
        if (sender == rightButton) {
            delegate?.didTapTitlebarButton(1)
        }
        if (sender == leftButton) {
            delegate?.didTapTitlebarButton(0)
        }
    }
}
