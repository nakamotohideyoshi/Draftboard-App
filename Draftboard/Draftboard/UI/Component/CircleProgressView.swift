//
//  CircleProgress.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class CircleProgressView: UIView {
    
    var colorFg: UIColor!
    var colorBg: UIColor!
    
    var thickness: CGFloat!
    var radius: CGFloat!
    var currentProgress: CGFloat = 0.0
    var ringFg: CAShapeLayer!
    var ringBg: CAShapeLayer!
    var spring: Spring?
    
    init(radius _radius: CGFloat, thickness _thickness: CGFloat, colorFg _colorFg: UIColor, colorBg _colorBg: UIColor) {
        super.init(frame: CGRectMake(0.0, 0.0, _radius * 2.0, _radius * 2.0))
        radius = _radius
        thickness = _thickness
        colorFg = _colorFg
        colorBg = _colorBg
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func redraw() {
        spring?.cancel()
        spring = nil
        
        let d = radius * 2.0
        let bounds = self.bounds
        let ringFrame = CGRectMake(bounds.width / 2.0 - radius, bounds.height / 2.0 - radius, d, d)
        
        ringFg.frame = ringFrame
        ringFg.path = getArcPath(currentProgress)
        
        ringBg.frame = ringFrame
        ringBg.path = getArcPath(1.0)
    }
    
    func setup() {
        ringBg = createRing(colorBg)
        ringBg.path = getArcPath(1.0)
        self.layer.addSublayer(ringBg)
        
        ringFg = createRing(colorFg)
        ringFg.path = getArcPath(1.0)
        self.layer.addSublayer(ringFg)
        
//        ringFg.shadowColor = UIColor.blackColor().CGColor
//        ringFg.shadowRadius = 1.0
//        ringFg.shadowOffset = CGSizeMake(0, 0.5);
//        ringFg.shadowOpacity = 0.45;
//        ringFg.masksToBounds = false
    }
    
    func createRing(color: UIColor) -> CAShapeLayer {
        let ring = CAShapeLayer()
        ring.fillColor = UIColor.clearColor().CGColor
        ring.strokeColor = color.CGColor
        ring.lineCap = "round"
        ring.lineWidth = thickness
        ring.killImplicitAnimations()
        return ring
    }
    
    func getArcPath(progress: CGFloat) -> CGPathRef {
        let center = CGPointMake(radius, radius)
        
        let PI = CGFloat(M_PI)
        let TAU = PI * 2.0
        let startAngle = -CGFloat(M_PI_2)
        
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: startAngle - TAU * progress,
            clockwise: false
        )
        
        return path.CGPath;
    }
    
    func setProgress(newProgress: CGFloat, animated: Bool = true, delay: CFTimeInterval = 0.0) {
        spring?.cancel()
        spring = nil
        
        if (animated) {
            let startProgress = currentProgress
            let endProgress = newProgress
            let progressDelta = endProgress - startProgress
            
            spring = Spring(stiffness: 4.0, damping: 0.2, velocity: 4.0)
            spring!.updateBlock = { value in
                self.currentProgress = startProgress + (progressDelta * value)
                self.ringFg.path = self.getArcPath(self.currentProgress)
            }
            spring!.start(delay)
        }
        else {
            ringFg.path = getArcPath(newProgress)
            currentProgress = newProgress
        }
    }
}
