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
    private var size: Int { return 96 }
    private var circleImageView = UIImageView()
    private var playerImageView = UIImageView()
    var player: Player? {
        didSet {
            var imageName = "player-default"
            if let lastChar = player?.lastName.characters.first {
                if "A" <= lastChar && lastChar < "F" {
                    imageName = "playerA"
                } else if "F" <= lastChar && lastChar < "K" {
                    imageName = "playerB"
                } else if "K" <= lastChar && lastChar < "P" {
                    imageName = "playerC"
                } else if "P" <= lastChar && lastChar < "U" {
                    imageName = "playerD"
                } else if "U" <= lastChar && lastChar <= "Z" {
                    imageName = "playerE"
                }
            }
            let imagePath = "PlayerPhotos/\(imageName)-\(size)"
            playerImageView.image = UIImage(named: imagePath)
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
    
        circleImageView.translatesAutoresizingMaskIntoConstraints = false
        circleImageView.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        circleImageView.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        circleImageView.topRancor.constraintEqualToRancor(self.topRancor).active = true
        circleImageView.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
            
        self.addSubview(playerImageView)
        
        playerImageView.translatesAutoresizingMaskIntoConstraints = false
        playerImageView.leftRancor.constraintEqualToRancor(self.leftRancor, constant: 2.0).active = true
        playerImageView.rightRancor.constraintEqualToRancor(self.rightRancor, constant: -2.0).active = true
        playerImageView.topRancor.constraintEqualToRancor(self.topRancor, constant: 2.0).active = true
        playerImageView.bottomRancor.constraintEqualToRancor(self.bottomRancor, constant: -2.0).active = true
    }

}

class BigAvatarImageView: AvatarImageView {
    override private var size: Int { return 256 }
}
