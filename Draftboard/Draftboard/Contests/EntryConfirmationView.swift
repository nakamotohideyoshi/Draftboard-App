//
//  EntryConfirmationView.swift
//  Draftboard
//
//  Created by Anson Schall on 8/26/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class EntryConfirmationView: DraftboardView {
    
    let titleLabel = UILabel()
    let panelView = UIView()
    let confirmationLabel = UILabel()
    let prizeStatView = ModalStatView()
    let entrantsStatView = ModalStatView()
    let feeStatView = ModalStatView()
    let panelDividerView = UIView()
    let dontAskLabel = UILabel()
    let dontAskSwitch = UISwitch()
    let enterButton = UIButton()
    let cancelButton = UIButton()
    
    override func setup() {
        super.setup()
        
        // Add subviews
        addSubview(titleLabel)
        addSubview(panelView)
        panelView.addSubview(confirmationLabel)
        panelView.addSubview(prizeStatView)
        panelView.addSubview(entrantsStatView)
        panelView.addSubview(feeStatView)
        panelView.addSubview(panelDividerView)
        panelView.addSubview(dontAskLabel)
        panelView.addSubview(dontAskSwitch)
        panelView.addSubview(enterButton)
        panelView.addSubview(cancelButton)
        
        // Configure subviews
        titleLabel.font = .oswald(size: 15)
        titleLabel.textColor = .whiteColor()
        titleLabel.text = "Confirm Entry".uppercaseString
        
        panelView.backgroundColor = .greyCool()
        panelView.clipsToBounds = true
        
        confirmationLabel.font = .oswald(size: 15)
        confirmationLabel.textColor = .whiteColor()
        
        prizeStatView.titleLabel.text = "Prizes".uppercaseString
        entrantsStatView.titleLabel.text = "Entrants".uppercaseString
        feeStatView.titleLabel.text = "Fee".uppercaseString
        feeStatView.rightBorderView.hidden = true

        panelDividerView.backgroundColor = UIColor(0x57616c)
        
        dontAskLabel.font = .openSans(size: 12)
        dontAskLabel.text = "Don't ask me again"
        dontAskLabel.textColor = .whiteColor()
        
        dontAskSwitch.tintColor = .blueDarker()
        dontAskSwitch.onTintColor = .greenDraftboard()
        dontAskSwitch.thumbTintColor = UIColor(0x333945).colorWithAlphaComponent(0.9)
        dontAskSwitch.backgroundColor = .blueDarker()
        dontAskSwitch.layer.cornerRadius = 16
        
        enterButton.titleLabel?.font = .openSans(weight: .Semibold, size: 10)
        enterButton.titleLabel?.textAlignment = .Center
        enterButton.setTitle("Enter".uppercaseString, forState: .Normal)
        enterButton.setTitleColor(.whiteColor(), forState: .Normal)
        enterButton.backgroundColor = .greenDraftboard()
        enterButton.layer.borderWidth = 1
        enterButton.layer.borderColor = UIColor.greenDraftboard().CGColor
        
        cancelButton.titleLabel?.font = .openSans(weight: .Semibold, size: 10)
        cancelButton.titleLabel?.textAlignment = .Center
        cancelButton.setTitle("Cancel, Don't Enter Contest".uppercaseString, forState: .Normal)
        cancelButton.setTitleColor(.whiteColor(), forState: .Normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let (boundsW, boundsH) = (bounds.width, bounds.height)

        let panelViewW = boundsW - 60
        let titleLabelSize = titleLabel.sizeThatFits(CGSizeZero)
        
        let confirmationLabelSize = confirmationLabel.sizeThatFits(CGSizeMake(panelViewW - 20, 0))
        let statViewSize = CGSizeMake((panelViewW - 10) / 3, 65)
        let panelDividerViewSize = CGSizeMake(panelViewW - 30, 1.5)
        let dontAskLabelSize = dontAskLabel.sizeThatFits(CGSizeZero)
        let dontAskSwitchSize = dontAskSwitch.sizeThatFits(CGSizeZero)
        let enterButtonSize = CGSizeMake(panelViewW - 30, 50)
        
        let (titleLabelW, titleLabelH) = (titleLabelSize.width, titleLabelSize.height)
        let (confirmationLabelW, confirmationLabelH) = (confirmationLabelSize.width, confirmationLabelSize.height)
        let (statViewW, statViewH) = (statViewSize.width, statViewSize.height)
        let (panelDividerViewW, panelDividerViewH) = (panelDividerViewSize.width, panelDividerViewSize.height)
        let (dontAskLabelW, dontAskLabelH) = (dontAskLabelSize.width, dontAskSwitchSize.height)
        let (dontAskSwitchW, dontAskSwitchH) = (dontAskSwitchSize.width, dontAskSwitchSize.height)
        let (enterButtonW, enterButtonH) = (enterButtonSize.width, enterButtonSize.height)

        let confirmationLabelX = fitToPixel(panelViewW / 2 - confirmationLabelW / 2)
        let confirmationLabelY = fitToPixel(30)
        let statViewY = fitToPixel(confirmationLabelY + confirmationLabelH + 32)
        let panelDividerViewX = fitToPixel(panelViewW / 2 - panelDividerViewW / 2)
        let panelDividerViewY = fitToPixel(statViewY + statViewH + 18)
        let dontAskLabelX = fitToPixel(panelViewW / 2 - (dontAskLabelW + 10 + dontAskSwitchW) / 2)
        let dontAskSwitchX = fitToPixel(panelViewW / 2 - (dontAskLabelW + 10 + dontAskSwitchW) / 2 + dontAskLabelW + 10)
        let dontAskSwitchY = fitToPixel(panelDividerViewY + panelDividerViewH + 20)
        let enterButtonY = fitToPixel(dontAskSwitchY + dontAskSwitchH + 22)
        let cancelButtonY = fitToPixel(enterButtonY + enterButtonH + 10)
        
        let panelViewH = cancelButtonY + enterButtonH + 15
        
        let titleLabelX = fitToPixel(boundsW / 2 - titleLabelW / 2)
        let titleLabelY = fitToPixel(boundsH / 2 - panelViewH / 2 - 30 - titleLabelH)
        let panelViewX = fitToPixel((boundsW - panelViewW) / 2)
        let panelViewY = fitToPixel(boundsH / 2 - panelViewH / 2)
        
        
        titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)
        panelView.frame = CGRectMake(panelViewX, panelViewY, panelViewW, panelViewH)
        confirmationLabel.frame = CGRectMake(confirmationLabelX, confirmationLabelY, confirmationLabelW, confirmationLabelH)
        prizeStatView.frame = CGRectMake(5, statViewY, statViewW, statViewH)
        entrantsStatView.frame = CGRectMake(5 + statViewW, statViewY, statViewW, statViewH)
        feeStatView.frame = CGRectMake(5 + statViewW * 2, statViewY, statViewW, statViewH)
        panelDividerView.frame = CGRectMake(panelDividerViewX, panelDividerViewY, panelDividerViewW, panelDividerViewH)
        dontAskLabel.frame = CGRectMake(dontAskLabelX, dontAskSwitchY, dontAskLabelW, dontAskLabelH)
        dontAskSwitch.frame = CGRectMake(dontAskSwitchX, dontAskSwitchY, dontAskSwitchW, dontAskSwitchH)
        enterButton.frame = CGRectMake(15, enterButtonY, enterButtonW, enterButtonH)
        cancelButton.frame = CGRectMake(15, cancelButtonY, enterButtonW, enterButtonH)
    }

}

class ModalStatView: DraftboardView {
    
    var titleLabel = UILabel()
    var valueLabel = UILabel()
    let rightBorderView = UIView()
    let leftBorderView = UIView()
    
    override func setup() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(leftBorderView)
        addSubview(rightBorderView)
        
        titleLabel.font = .openSans(weight: .Semibold, size: 9)
        titleLabel.textColor = UIColor(0xc5c7ce)
        titleLabel.textAlignment = .Center
        
        valueLabel.font = .oswald(size: 18)
        valueLabel.textColor = .whiteColor()
        valueLabel.textAlignment = .Center
        
        leftBorderView.hidden = true
        leftBorderView.backgroundColor = UIColor(0x57616c)
        rightBorderView.backgroundColor = UIColor(0x57616c)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let (boundsW, boundsH) = (bounds.width, bounds.height)

        let titleLabelH = titleLabel.sizeThatFits(bounds.size).height
        let valueLabelH = valueLabel.sizeThatFits(bounds.size).height
        let combinedH = titleLabelH + 1 + valueLabelH

        let titleLabelY = fitToPixel(boundsH / 2 - combinedH / 2)
        let valueLabelY = fitToPixel(titleLabelY + titleLabelH + 1)
        
        titleLabel.frame = CGRectMake(0, titleLabelY, boundsW, titleLabelH)
        valueLabel.frame = CGRectMake(0, valueLabelY, boundsW, valueLabelH)
        leftBorderView.frame = CGRectMake(0, 0, 1.5, bounds.height)
        rightBorderView.frame = CGRectMake(bounds.width - 1.5, 0, 1.5, bounds.height)
    }
    
}

