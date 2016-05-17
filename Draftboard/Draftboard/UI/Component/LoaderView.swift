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
        
        mask = CAShapeLayer()
        mask.strokeColor = UIColor.redColor().CGColor
        mask.fillColor = UIColor.clearColor().CGColor
        
        addSubview(gradientImageView)
        gradientImageView.layer.mask = mask;
        spinning = false
        
        if !CGRectEqualToRect(frame, CGRectZero) {
            updateMask()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }
    
    func updateMask() {
        let d = frame.size.width;
        let r = d / 2;
        
        mask.path = arcWithRadius(r - thickness, progress: 1.0)
        mask.frame = CGRectMake(0, 0, d, d)
        mask.lineWidth = thickness;
        
        gradientImageView.frame = mask.frame
    }
    
    var thickness: CGFloat = 2.0 {
        didSet {
            mask.lineWidth = thickness;
        }
    }

    func resumeSpinning() {
        if (spinning && !hidden) {
            gradientImageView.layer.removeAllAnimations()
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
        let xy = frame.size.width / 2.0
        let center = CGPointMake(xy, xy)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: CGFloat(M_PI) * 2.0 * progress, clockwise: true)
        return path.CGPath;
    }
}
