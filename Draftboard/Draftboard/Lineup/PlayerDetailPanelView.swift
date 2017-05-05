//
//  PlayerDetailPanelView.swift
//  Draftboard
//
//  Created by Anson Schall on 9/20/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class PlayerDetailPanelView: DraftboardView {
    
    let backgroundView = UIView()
    let draftButton = DraftboardTextButton()
    //let shadowView = DraftButtonShadowView()
    let gameDetailView = PlayerGameDetailView()
    let segmentedControl = DraftboardSegmentedControl(choices: [], textColor: .greyCool(), textSelectedColor: .greenDraftboard())
    
    override func setup() {
        super.setup()
        
        addSubview(backgroundView)
        addSubview(draftButton)
        //addSubview(shadowView)
        addSubview(gameDetailView)
        addSubview(segmentedControl)
        
        backgroundView.backgroundColor = .whiteColor()
        
//        shadowView.opaque = false
//        shadowView.layer.rasterizationScale = UIScreen.mainScreen().scale
//        shadowView.layer.shouldRasterize = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let boundsSize = bounds.size
        let boundsW = boundsSize.width
        let boundsH = boundsSize.height
        
        let draftButtonW = boundsW - 80
        let draftButtonH = CGFloat(50)
        let draftButtonX = fitToPixel(boundsW / 2 - draftButtonW / 2)
        let draftButtonY = CGFloat(0)
        
        let gameDetailViewW = boundsW
        let gameDetailViewH = CGFloat(85)
        let gameDetailViewX = CGFloat(0)
        let gameDetailViewY = draftButtonY + draftButtonH + 15
        
        let segmentedControlW = boundsW - 80
        let segmentedControlH = CGFloat(50)
        let segmentedControlX = fitToPixel(boundsW / 2 - segmentedControlW / 2)
        let segmentedControlY = gameDetailViewY + gameDetailViewH + 15
        
        let backgroundViewX = CGFloat(0)
        let backgroundViewY = fitToPixel(draftButtonY + draftButtonH * 0.55)
        let backgroundViewW = boundsW
        let backgroundViewH = boundsH - backgroundViewY
        
        backgroundView.frame = CGRectMake(backgroundViewX, backgroundViewY, backgroundViewW, backgroundViewH)
        draftButton.frame = CGRectMake(draftButtonX, draftButtonY, draftButtonW, draftButtonH)
        //shadowView.frame = CGRectMake(draftButtonX - 40, draftButtonY + draftButtonH - 15, draftButtonW + 80, 25)
        gameDetailView.frame = CGRectMake(gameDetailViewX, gameDetailViewY, gameDetailViewW, gameDetailViewH)
        segmentedControl.frame = CGRectMake(segmentedControlX, segmentedControlY, segmentedControlW, segmentedControlH)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let draftButtonH = CGFloat(50)
        let draftButtonY = CGFloat(0)
        
        let gameDetailViewH = CGFloat(85)
        let gameDetailViewY = draftButtonY + draftButtonH + 15
        
        let segmentedControlH = CGFloat(50)
        let segmentedControlY = gameDetailViewY + gameDetailViewH + 15
        
        let heightThatFits = segmentedControlY + segmentedControlH
        
        return CGSizeMake(size.width, heightThatFits)
    }
    
}

//class DraftButtonShadowView: UIView {
//    override func drawRect(rect: CGRect) {
//        let radius = bounds.width * 0.5
//        let center = CGPointMake(radius, radius)
//        let black = UIColor(white: 0, alpha: 0.3).CGColor
//        let green = UIColor.greenDraftboard().colorWithAlphaComponent(0.3).CGColor
//        let clear = UIColor(white: 0, alpha: 0).CGColor
//        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [green, clear], [0, 1.0])
//        let context = UIGraphicsGetCurrentContext()
//        CGContextScaleCTM(context!, 1.0, bounds.height / bounds.width)
//        //CGContextDrawRadialGradient(context!, gradient!, center, 0, center, radius, [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
//        CGContextDrawLinearGradient(context!, gradient!, CGPoint(x:0, y:0), CGPoint(x:0, y:500), [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
//    }
//}
