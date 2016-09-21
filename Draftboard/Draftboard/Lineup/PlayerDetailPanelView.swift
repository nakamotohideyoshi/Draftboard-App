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
    let segmentedControl = DraftboardSegmentedControl(choices: [], textColor: .greyCool(), textSelectedColor: .greenDraftboard())
    
    override func setup() {
        super.setup()
        
        addSubview(backgroundView)
        addSubview(draftButton)
        addSubview(segmentedControl)
        
        backgroundView.backgroundColor = .whiteColor()
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
        
        let segmentedControlW = boundsW - 80
        let segmentedControlH = CGFloat(50)
        let segmentedControlX = fitToPixel(boundsW / 2 - segmentedControlW / 2)
        let segmentedControlY = draftButtonY + draftButtonH + 8
        
        let backgroundViewX = CGFloat(0)
        let backgroundViewY = fitToPixel(draftButtonY + draftButtonH * 0.55)
        let backgroundViewW = boundsW
        let backgroundViewH = boundsH - backgroundViewY
        
        backgroundView.frame = CGRectMake(backgroundViewX, backgroundViewY, backgroundViewW, backgroundViewH)
        draftButton.frame = CGRectMake(draftButtonX, draftButtonY, draftButtonW, draftButtonH)
        segmentedControl.frame = CGRectMake(segmentedControlX, segmentedControlY, segmentedControlW, segmentedControlH)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let draftButtonH = CGFloat(50)
        let draftButtonY = CGFloat(0)
        
        let segmentedControlH = CGFloat(50)
        let segmentedControlY = draftButtonY + draftButtonH + 8
        
        let heightThatFits = segmentedControlY + segmentedControlH
        
        return CGSizeMake(size.width, heightThatFits)
    }
    
}