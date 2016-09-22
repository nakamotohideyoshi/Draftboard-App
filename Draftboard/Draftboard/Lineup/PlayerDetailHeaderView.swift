//
//  PlayerDetailHeaderView.swift
//  Draftboard
//
//  Created by Anson Schall on 9/20/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class PlayerDetailHeaderView: DraftboardView {
    
    let avatarView = UIImageView()
    let avatarHaloView = UIImageView()
    let avatarLoaderView = LoaderView()
    let nextGameLabel = DraftboardTextLabel()
    let posStatView = ModalStatView()
    let salaryStatView = ModalStatView()
    let fppgStatView = ModalStatView()
    
    override func setup() {
        super.setup()
        
        addSubview(avatarHaloView)
        addSubview(avatarLoaderView)
        addSubview(avatarView)
        addSubview(nextGameLabel)
        addSubview(posStatView)
        addSubview(salaryStatView)
        addSubview(fppgStatView)
        
        avatarHaloView.image = UIImage(named: "player-halo")
        
        nextGameLabel.font = .openSans(weight: .Bold, size: 10)
        nextGameLabel.kern = 1.1
        nextGameLabel.textAlignment = .Center
        nextGameLabel.textColor = UIColor(0x9c9faf)
        
        posStatView.titleLabel.text = "Pos".uppercaseString
        salaryStatView.titleLabel.text = "Salary".uppercaseString
        fppgStatView.titleLabel.text = "Avg FPPG".uppercaseString
        fppgStatView.rightBorderView.hidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let boundsSize = bounds.size
        let boundsW = boundsSize.width
        
        let avatarViewW = CGFloat(128)
        let avatarViewH = CGFloat(128)
        let avatarViewX = fitToPixel(boundsW / 2 - avatarViewW / 2)
        let avatarViewY = CGFloat(20)
        
        let avatarHaloViewW = CGFloat(200)
        let avatarHaloViewH = CGFloat(200)
        let avatarHaloViewX = avatarViewX + fitToPixel(avatarViewW / 2 - avatarHaloViewW / 2)
        let avatarHaloViewY = avatarViewY + fitToPixel(avatarViewH / 2 - avatarHaloViewH / 2)

        let avatarLoaderViewW = CGFloat(42)
        let avatarLoaderViewH = CGFloat(42)
        let avatarLoaderViewX = avatarViewX + fitToPixel(avatarViewW / 2 - avatarLoaderViewW / 2)
        let avatarLoaderViewY = avatarViewY + fitToPixel(avatarViewH / 2 - avatarLoaderViewH / 2)
        
        let nextGameLabelSize = nextGameLabel.sizeThatFits(CGSizeZero)
        let nextGameLabelW = nextGameLabelSize.width
        let nextGameLabelH = nextGameLabelSize.height
        let nextGameLabelX = fitToPixel(boundsW / 2 - nextGameLabelW / 2)
        let nextGameLabelY = avatarViewY + avatarViewH + 25
        
        let statViewW = fitToPixel((boundsW - 80) / 3)
        let statViewH = CGFloat(55)
        let statViewX = CGFloat(40)
        let statViewY = nextGameLabelY + nextGameLabelH + 25

        avatarView.frame = CGRectMake(avatarViewX, avatarViewY, avatarViewW, avatarViewH)
        avatarHaloView.frame = CGRectMake(avatarHaloViewX, avatarHaloViewY, avatarHaloViewW, avatarHaloViewH)
        avatarLoaderView.frame = CGRectMake(avatarLoaderViewX, avatarLoaderViewY, avatarLoaderViewW, avatarLoaderViewH)
        nextGameLabel.frame = CGRectMake(nextGameLabelX, nextGameLabelY, nextGameLabelW, nextGameLabelH)
        posStatView.frame = CGRectMake(statViewX, statViewY, statViewW, statViewH)
        salaryStatView.frame = CGRectMake(statViewX + statViewW, statViewY, statViewW, statViewH)
        fppgStatView.frame = CGRectMake(statViewX + statViewW * 2, statViewY, statViewW, statViewH)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let avatarViewH = CGFloat(128)
        let avatarViewY = CGFloat(20)
        
        let nextGameLabelH = nextGameLabel.sizeThatFits(CGSizeZero).height
        let nextGameLabelY = avatarViewY + avatarViewH + 25
        
        let statViewH = CGFloat(65)
        let statViewY = nextGameLabelY + nextGameLabelH + 25
        
        let heightThatFits = statViewY + statViewH + 25
        
        return CGSizeMake(size.width, heightThatFits)
    }
}
