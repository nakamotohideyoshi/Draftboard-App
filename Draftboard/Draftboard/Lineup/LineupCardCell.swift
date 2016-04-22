//
//  LineupCardCell.swift
//  Draftboard
//
//  Created by Anson Schall on 4/22/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupCardCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LineupCardCell"
    
    let lineupView = UIView()
    let createView = UIView()
    
    var lineup: Lineup? {
        didSet {
            let lineupExists = (lineup != nil)
            lineupView.hidden = !lineupExists
            createView.hidden = lineupExists
        }
    }
    
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
        setupSubviews()
    }
    
    func addSubviews() {
        contentView.addSubview(lineupView)
        contentView.addSubview(createView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            contentView.topRancor.constraintEqualToRancor(topRancor),
            contentView.leftRancor.constraintEqualToRancor(leftRancor),
            contentView.rightRancor.constraintEqualToRancor(rightRancor),
            contentView.bottomRancor.constraintEqualToRancor(bottomRancor),
            
            lineupView.topRancor.constraintEqualToRancor(contentView.topRancor, constant: 2.0),
            lineupView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 2.0),
            lineupView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -2.0),
            lineupView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -2.0),
            
            createView.topRancor.constraintEqualToRancor(contentView.topRancor, constant: 2.0),
            createView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 2.0),
            createView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -2.0),
            createView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -2.0),
            ]
        
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        lineupView.translatesAutoresizingMaskIntoConstraints = false
        createView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupSubviews() {
        contentView.backgroundColor = .clearColor()
        lineupView.backgroundColor = .whiteColor()
        createView.backgroundColor = .blueMediumDark()
        lineupView.layer.allowsEdgeAntialiasing = true
        createView.layer.allowsEdgeAntialiasing = true
    }
    
    func fade(amount: CGFloat) {
        alpha = 1.0 - (amount * 0.5)
    }
    
    func rotate(amount: CGFloat) {
        let direction: CGFloat = (amount < 0) ? -1 : 1
        let magnitude: CGFloat = abs(amount)
        var (integral, fraction) = modf(magnitude)
        let translateX = direction * (bounds.width / 2)
        let rotateY = direction * CGFloat(M_PI_4)
        let scale = 1.0 - (magnitude * 0.025)
        
        var t = CATransform3DIdentity
        t = CATransform3DTranslate(t, -translateX * integral * 2, 0, 0)
        
        t = CATransform3DTranslate(t, -translateX, 0, 0)
        t = CATransform3DRotate(t, rotateY * fraction, 0, 1, 0)
        t = CATransform3DTranslate(t, translateX, 0, 0)
        
        while integral > 0 {
            t = CATransform3DTranslate(t, translateX, 0, 0)
            t = CATransform3DRotate(t, rotateY, 0, 1, 0)
            t = CATransform3DTranslate(t, translateX, 0, 0)
            integral -= 1
        }
        
        t = CATransform3DScale(t, scale, scale, 1)
        
        layer.transform = t
        
        // A different approach for a similar effect
        /*
         let translateX = -amount * bounds.width
         let translateZ = -1.207 * bounds.width
         let rotateY = amount * CGFloat(M_PI_4)
         let scale = 1.0 - (abs(amount) * 0.025)
         
         var t = CATransform3DIdentity
         t = CATransform3DTranslate(t, translateX, 0, 0) // reset to viewport center
         t = CATransform3DTranslate(t, 0, 0, translateZ) // push to carousel center
         t = CATransform3DRotate(t, rotateY, 0, 1, 0) // rotate at carousel center
         t = CATransform3DTranslate(t, 0, 0, -translateZ) // push back toward viewport
         // scale down as distance from viewport center increases
         t = CATransform3DScale(t, scale, scale, 1.0)
         
         layer.transform = t
         */
    }
    
}
