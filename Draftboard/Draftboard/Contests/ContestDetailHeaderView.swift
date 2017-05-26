//
//  ContestDetailHeaderView.swift
//  Draftboard
//
//  Created by Anson Schall on 9/9/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailHeaderView: DraftboardView {
    
    let countdownView = CountdownView()
    let hLabel = UILabel()
    let mLabel = UILabel()
    let sLabel = UILabel()
    let prizeStatView = ModalStatView()
    let entrantsStatView = ModalStatView()
    let feeStatView = ModalStatView()
    
    override func setup() {
        super.setup()
        
        addSubview(countdownView)
        addSubview(hLabel)
        addSubview(mLabel)
        addSubview(sLabel)
        addSubview(prizeStatView)
        addSubview(entrantsStatView)
        addSubview(feeStatView)
        
        countdownView.date = NSDate()
        countdownView.size = 50
        
        hLabel.font = .openSans(weight: .Semibold, size: 9)
        hLabel.textAlignment = .Center
        hLabel.textColor = UIColor(0x808289)
        hLabel.text = "H"
        
        mLabel.font = .openSans(weight: .Semibold, size: 9)
        mLabel.textAlignment = .Center
        mLabel.textColor = UIColor(0x808289)
        mLabel.text = "M"
        
        sLabel.font = .openSans(weight: .Semibold, size: 9)
        sLabel.textAlignment = .Center
        sLabel.textColor = UIColor(0x808289)
        sLabel.text = "S"
        
        prizeStatView.titleLabel.text = "Prizes".uppercaseString
        entrantsStatView.titleLabel.text = "Entries".uppercaseString
        feeStatView.titleLabel.text = "Fee".uppercaseString
        feeStatView.rightBorderView.hidden = true
    }
    
    override func layoutSubviews() {
        let boundsSize = bounds.size
        let boundsW = boundsSize.width
        
        let countdownViewSize = countdownView.sizeThatFits(CGSizeZero)
        let countdownViewW = countdownViewSize.width
        let countdownViewH = countdownViewSize.height
        
        let hmsLabelSize = mLabel.sizeThatFits(CGSizeZero)
        let hmsLabelW = countdownViewW / 3
        let hmsLabelH = hmsLabelSize.height
        
        let statViewSize = CGSizeMake((boundsW - 80) / 3, 65)
        let statViewW = statViewSize.width
        let statViewH = statViewSize.height
        
        let countdownViewX = fitToPixel(boundsW / 2 - countdownViewW / 2)
        let countdownViewY = fitToPixel(30)
        
        let hmsLabelX = fitToPixel(countdownViewX)
        let hmsLabelY = fitToPixel(countdownViewY + countdownViewH)
        
        let statViewX = fitToPixel(40)
        let statViewY = fitToPixel(hmsLabelY + hmsLabelH + 40)
        
        countdownView.frame = CGRectMake(countdownViewX, countdownViewY, countdownViewW, countdownViewH)
        hLabel.frame = CGRectMake(hmsLabelX, hmsLabelY, hmsLabelW, hmsLabelH)
        mLabel.frame = CGRectMake(hmsLabelX + hmsLabelW, hmsLabelY, hmsLabelW, hmsLabelH)
        sLabel.frame = CGRectMake(hmsLabelX + hmsLabelW * 2, hmsLabelY, hmsLabelW, hmsLabelH)
        prizeStatView.frame = CGRectMake(statViewX, statViewY, statViewW, statViewH)
        entrantsStatView.frame = CGRectMake(statViewX + statViewW, statViewY, statViewW, statViewH)
        feeStatView.frame = CGRectMake(statViewX + statViewW * 2, statViewY, statViewW, statViewH)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let countdownViewH = countdownView.sizeThatFits(CGSizeZero).height
        let hmsLabelH = mLabel.sizeThatFits(CGSizeZero).height
        let statViewH = fitToPixel(65)
        
        let countdownViewY = fitToPixel(30)
        let hmsLabelY = fitToPixel(countdownViewY + countdownViewH)
        let statViewY = fitToPixel(hmsLabelY + hmsLabelH + 40)
        
        let heightThatFits = statViewY + statViewH + 40
        
        return CGSizeMake(size.width, heightThatFits)
    }
}
