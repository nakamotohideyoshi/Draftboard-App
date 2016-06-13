//
//  LoaderView.swift
//  Draftboard
//
//  Created by Anson Schall on 11/23/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    let gradientImageView = UIImageView()
    var lineWidth: CGFloat = 2.0 { didSet { update() } }
    
    // Prune these when possible
    var thickness: CGFloat = 0
    var spinning: Bool = false
    func resumeSpinning() { }

    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    override convenience init(frame: CGRect) {
        self.init()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    func setup() {
        addSubviews()
        addConstraints()
        otherSetup()
    }
    
    func addSubviews() {
        addSubview(gradientImageView)
    }

    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            gradientImageView.topRancor.constraintEqualToRancor(topRancor),
            gradientImageView.leftRancor.constraintEqualToRancor(leftRancor),
            gradientImageView.rightRancor.constraintEqualToRancor(rightRancor),
            gradientImageView.bottomRancor.constraintEqualToRancor(bottomRancor),
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        gradientImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        gradientImageView.image = UIImage(named: "loader-gradient")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        update()
    }
    
    func update() {
        let mask = CAShapeLayer()
        mask.strokeColor = UIColor.redColor().CGColor
        mask.fillColor = UIColor.clearColor().CGColor
        mask.path = UIBezierPath(ovalInRect: CGRectInset(bounds, lineWidth, lineWidth)).CGPath
        mask.frame = bounds
        mask.lineWidth = lineWidth;

        gradientImageView.layer.mask = mask
        gradientImageView.layer.removeAllAnimations()
        gradientImageView.layer.addAnimation(spinningAnim(), forKey: "spin")
    }

    func spinningAnim() -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.toValue = NSNumber(double: M_PI * 2.0)
        anim.duration = 1.5
        anim.cumulative = true
        anim.repeatCount = Float.infinity
        return anim
    }
    
}
