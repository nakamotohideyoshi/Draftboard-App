//
//  AvatarImageView.swift
//  Draftboard
//
//  Created by Anson Schall on 2/16/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class AvatarImageView: UIView {
    private var size: Int { return 76 }
    private var circleImageView = UIImageView()
    private var playerImageView = UIImageView()
    var player: Player? {
        didSet {
            if let srid = player?.srid, image = UIImage(named: "PlayerPhotos/\(size)/\(srid)") {
                playerImageView.image = image
            } else {
                playerImageView.image = UIImage(named: "PlayerPhotos/player-default-\(size)")
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        player = nil
        let circlePath = "PlayerPhotos/player-background-\(size)"
        circleImageView.image = UIImage(named: circlePath)

        self.addSubview(circleImageView)
    
//        circleImageView.translatesAutoresizingMaskIntoConstraints = false
//        circleImageView.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
//        circleImageView.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
//        circleImageView.topRancor.constraintEqualToRancor(self.topRancor).active = true
//        circleImageView.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
        
        self.addSubview(playerImageView)
        
//        playerImageView.translatesAutoresizingMaskIntoConstraints = false
//        playerImageView.leftRancor.constraintEqualToRancor(self.leftRancor, constant: 2.0).active = true
//        playerImageView.rightRancor.constraintEqualToRancor(self.rightRancor, constant: -2.0).active = true
//        playerImageView.topRancor.constraintEqualToRancor(self.topRancor, constant: 2.0).active = true
//        playerImageView.bottomRancor.constraintEqualToRancor(self.bottomRancor, constant: -2.0).active = true
    }
    
    override func layoutSubviews() {
        circleImageView.frame = bounds
        playerImageView.frame = CGRectInset(bounds, 2, 2)
    }

}

class BigAvatarImageView: AvatarImageView {
    override private var size: Int { return 256 }
}
