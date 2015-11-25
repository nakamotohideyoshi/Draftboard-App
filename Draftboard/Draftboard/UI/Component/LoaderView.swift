//
//  LoaderView.swift
//  Draftboard
//
//  Created by Anson Schall on 11/23/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    var gradientImageView: UIImageView!
    var mask: CAShapeLayer!
    var ring: CAShapeLayer?
    var spinning: Bool = false {
        willSet(spinning) {
            if (self.spinning != spinning) {
                if (spinning) {
                    self.gradientImageView.layer.addAnimation(spinningAnim(), forKey:"transform.rotation.z");
                }
                else {
                    self.gradientImageView.layer.removeAllAnimations();
                }
            }
        }

    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let gradientImage = UIImage(named: "loader-gradient")
        gradientImageView = UIImageView(image: gradientImage)
        gradientImageView.frame = frame;
        
        let d = frame.size.width;
        let r = d / 2;
        
        mask = CAShapeLayer()
        mask.path = arcWithRadius(r * 0.65, progress: 1.0)
        mask.frame = CGRectMake(0, 0, d, d)
        mask.strokeColor = UIColor.redColor().CGColor
        mask.fillColor = UIColor.clearColor().CGColor
        mask.lineWidth = 2;
        addSubview(gradientImageView)
        gradientImageView.layer.mask = mask;
        spinning = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func resumeSpinning() {
        if (spinning) {
            gradientImageView.layer.addAnimation(spinningAnim(), forKey: "transform.rotation.z")
        }
    }
    
    func spinningAnim() -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.toValue = NSNumber(double: M_PI * 2.0)
        anim.duration = 1.5
        anim.cumulative = true
        anim.repeatCount = Float.infinity
        return anim
    }
    
    func arcWithRadius(radius: CGFloat, progress: CGFloat) -> CGPathRef {
        let xy = self.frame.size.width / 2.0
        let center = CGPointMake(xy, xy)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: CGFloat(M_PI) * 2.0 * progress, clockwise: true)
        
        return path.CGPath;
    }

    func selectedMaskPath() -> CGPathRef {
        let r = self.frame.size.width / 2.0
        let center = CGPointMake(r, r)
        let path = UIBezierPath(arcCenter: center, radius: r * 0.5, startAngle: 0.0, endAngle: CGFloat(M_PI) * 2.0, clockwise: true)
        
        return path.CGPath
    }
}
