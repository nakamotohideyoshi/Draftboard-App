//
//  ContestDetailPanelView.swift
//  Draftboard
//
//  Created by Anson Schall on 9/14/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailPanelView: DraftboardView {
    
    let backgroundView = UIView()
    let enterButton = DraftboardTextButton()
    let entryCountLabel = UILabel()
    let segmentedControl = DraftboardSegmentedControl(choices: [], textColor: .greyCool(), textSelectedColor: .greenDraftboard())

    override func setup() {
        super.setup()
        
        addSubview(backgroundView)
        addSubview(enterButton)
        addSubview(entryCountLabel)
        addSubview(segmentedControl)
        
        backgroundView.backgroundColor = .whiteColor()
        
        entryCountLabel.font = .openSans(size: 9)
        entryCountLabel.textAlignment = .Center
        entryCountLabel.textColor = .greyCool()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let boundsSize = bounds.size
        let boundsW = boundsSize.width
        let boundsH = boundsSize.height
        
        let enterButtonW = boundsW - 80
        let enterButtonH = CGFloat(50)
        let enterButtonX = fitToPixel(boundsW / 2 - enterButtonW / 2)
        let enterButtonY = CGFloat(0)
        
        let entryCountLabelSize = entryCountLabel.sizeThatFits(CGSizeZero)
        let entryCountLabelW = entryCountLabelSize.width
        let entryCountLabelH = entryCountLabelSize.height
        let entryCountLabelX = fitToPixel(boundsW / 2 - entryCountLabelW / 2)
        let entryCountLabelY = enterButtonY + enterButtonH + 8
        
        let segmentedControlW = boundsW - 40
        let segmentedControlH = CGFloat(50)
        let segmentedControlX = fitToPixel(boundsW / 2 - segmentedControlW / 2)
        let segmentedControlY = entryCountLabelY + entryCountLabelH
        
        let backgroundViewX = CGFloat(0)
        let backgroundViewY = fitToPixel(enterButtonY + enterButtonH * 0.55)
        let backgroundViewW = boundsW
        let backgroundViewH = boundsH - backgroundViewY
        
        backgroundView.frame = CGRectMake(backgroundViewX, backgroundViewY, backgroundViewW, backgroundViewH)
        enterButton.frame = CGRectMake(enterButtonX, enterButtonY, enterButtonW, enterButtonH)
        entryCountLabel.frame = CGRectMake(entryCountLabelX, entryCountLabelY, entryCountLabelW, entryCountLabelH)
        segmentedControl.frame = CGRectMake(segmentedControlX, segmentedControlY, segmentedControlW, segmentedControlH)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let enterButtonH = CGFloat(50)
        let enterButtonY = CGFloat(0)

        let entryCountLabelH = entryCountLabel.sizeThatFits(CGSizeZero).height
        let entryCountLabelY = enterButtonY + enterButtonH + 8
        
        let segmentedControlH = CGFloat(50)
        let segmentedControlY = entryCountLabelY + entryCountLabelH

        let heightThatFits = segmentedControlY + segmentedControlH
        
        return CGSizeMake(size.width, heightThatFits)
    }
}