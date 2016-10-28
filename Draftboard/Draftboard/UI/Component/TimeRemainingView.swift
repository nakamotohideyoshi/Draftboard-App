//
//  TimeRemainingView.swift
//  Draftboard
//
//  Created by Anson Schall on 10/27/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class TimeRemainingView: DraftboardView {
    let backgroundView = UIView()
    let foregroundView = UIImageView()
    let backgroundMaskLayer = CAShapeLayer()
    let foregroundMaskLayer = CAShapeLayer()
    
    var lineWidth: CGFloat = 1 { didSet { setNeedsLayout() } }
    var remaining: Double = 0 { didSet { setNeedsLayout() } }
    
    override func setup() {
        super.setup()
        
        addSubview(backgroundView)
        addSubview(foregroundView)
        
        backgroundView.backgroundColor = UIColor(0xebedf2)
        foregroundView.image = UIImage(named: "pmr-gradient")
        foregroundView.contentMode = .ScaleAspectFill
        
        backgroundMaskLayer.strokeColor = UIColor.redColor().CGColor
        foregroundMaskLayer.strokeColor = UIColor.redColor().CGColor
        backgroundMaskLayer.fillColor = UIColor.clearColor().CGColor
        foregroundMaskLayer.fillColor = UIColor.clearColor().CGColor
        
        backgroundView.layer.mask = backgroundMaskLayer
        foregroundView.layer.mask = foregroundMaskLayer
    }
    
    override func layoutSubviews() {
        backgroundView.frame = bounds
        foregroundView.frame = bounds
        
        foregroundMaskLayer.lineWidth = lineWidth
        backgroundMaskLayer.lineWidth = lineWidth

        let radius = bounds.width / 2
        let center = CGPointMake(radius, radius)
        let offsetAngle = CGFloat(-M_PI / 2)
        let startAngle = CGFloat(0) + offsetAngle
        let remainingAngle = CGFloat(-2 * M_PI * remaining) + offsetAngle
        let endAngle = CGFloat(-2 * M_PI) + offsetAngle
        
        foregroundMaskLayer.path = UIBezierPath(arcCenter: center, radius: radius - lineWidth / 2, startAngle: startAngle, endAngle: remainingAngle, clockwise: false).CGPath
        backgroundMaskLayer.path = UIBezierPath(arcCenter: center, radius: radius - lineWidth / 2, startAngle: remainingAngle, endAngle: endAngle, clockwise: false).CGPath
    }
}
