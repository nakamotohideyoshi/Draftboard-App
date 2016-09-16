//
//  DraftboardTextButton.swift
//  Draftboard
//
//  Created by Anson Schall on 9/14/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardTextButton: DraftboardControl {
    
    let label = DraftboardTextLabel()
    
    override func setup() {
        addSubview(label)
        
        label.font = .openSans(weight: .Semibold, size: 10)
        label.kern = 1.5
        label.textAlignment = .Center
        label.textColor = .whiteColor()
        backgroundColor = .greenDraftboard()
        layer.borderWidth = 1
        layer.borderColor = UIColor.greenDraftboard().CGColor
    }
    
    override func layoutSubviews() {
        let labelSize = label.sizeThatFits(CGSizeZero)
        let labelW = labelSize.width
        let labelH = labelSize.height
        let labelX = fitToPixel(bounds.width / 2 - labelSize.width / 2)
        let labelY = fitToPixel(bounds.height / 2 - labelSize.height / 2)
        label.frame = CGRectMake(labelX, labelY, labelW, labelH)
    }
    
    //    override func sizeThatFits(size: CGSize) -> CGSize {
    //        return CGSizeMake(size.width, max(min(size.height, 50), 20))
    //    }
}

