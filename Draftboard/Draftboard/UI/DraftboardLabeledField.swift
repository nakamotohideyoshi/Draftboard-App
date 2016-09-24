//
//  DraftboardLabeledField.swift
//  Draftboard
//
//  Created by Anson Schall on 9/23/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardLabeledField: DraftboardView {
    
    let textField = UITextField()
    let label = DraftboardTextLabel()
    let topBorderView = UIView()
    let bottomBorderView = UIView()
    
    override func setup() {
        super.setup()
        
        addSubview(textField)
        addSubview(label)
        addSubview(topBorderView)
        addSubview(bottomBorderView)
        
        textField.font = .openSans(size: 13)
        textField.textColor = UIColor(white: 1, alpha: 0.25)
            
        label.font = .oswald(size: 12)
        label.textColor = .whiteLowOpacity()
        
        topBorderView.backgroundColor = .whiteLowestOpacity()
        bottomBorderView.backgroundColor = .whiteLowestOpacity()
    }
    
    override func layoutSubviews() {
        let boundsW = bounds.size.width
        let boundsH = bounds.size.height
        
        let labelSize = label.sizeThatFits(CGSizeZero)
        let labelW = labelSize.width
        let labelH = labelSize.height
        let labelX = boundsW - labelW - 10
        let labelY = fitToPixel(boundsH / 2 - labelH / 2)
        
        let textFieldSize = textField.sizeThatFits(CGSizeZero)
        let textFieldW = boundsW - labelW - 20
        let textFieldH = textFieldSize.height
        let textFieldX = CGFloat(10)
        let textFieldY = fitToPixel(boundsH / 2 - textFieldH / 2)
        
        let topBorderViewW = boundsW
        let topBorderViewH = CGFloat(1)
        let topBorderViewX = CGFloat(0)
        let topBorderViewY = CGFloat(0)
        
        let bottomBorderViewW = boundsW
        let bottomBorderViewH = CGFloat(1)
        let bottomBorderViewX = CGFloat(0)
        let bottomBorderViewY = boundsH - bottomBorderViewH
        
        label.frame = CGRectMake(labelX, labelY, labelW, labelH)
        textField.frame = CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH)
        topBorderView.frame = CGRectMake(topBorderViewX, topBorderViewY, topBorderViewW, topBorderViewH)
        bottomBorderView.frame = CGRectMake(bottomBorderViewX, bottomBorderViewY, bottomBorderViewW, bottomBorderViewH)
    }
}