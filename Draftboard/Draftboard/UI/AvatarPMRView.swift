//
//  AvatarPMRView.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/11/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class AvatarPMRView: UIView {
    var PMRView: CircleProgressView!
    var avatarImageView: AvatarImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        avatarImageView = AvatarImageView()
        self.addSubview(avatarImageView)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        avatarImageView.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        avatarImageView.topRancor.constraintEqualToRancor(self.topRancor).active = true
        avatarImageView.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
        
        PMRView = CircleProgressView(radius: 18.0, thickness: 1.0, colorFg: .PMRColorFG(), colorBg: .PMRColorBG())
        self.addSubview(PMRView)
        
        PMRView.translatesAutoresizingMaskIntoConstraints = false
        PMRView.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        PMRView.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        PMRView.topRancor.constraintEqualToRancor(self.topRancor).active = true
        PMRView.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
        
        PMRView.setProgress(0.0, animated: false)
        PMRView.hidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        PMRView.radius = self.bounds.size.width / 2.0
        PMRView.redraw()
    }
}
