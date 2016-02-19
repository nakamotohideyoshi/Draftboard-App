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
        for view in [circleImageView, playerImageView] {
            self.addSubview(view)
        
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
            view.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
            view.topRancor.constraintEqualToRancor(self.topRancor).active = true
            view.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
        }
    }

}

class BigAvatarImageView: AvatarImageView {
    override private var size: Int { return 256 }
}
