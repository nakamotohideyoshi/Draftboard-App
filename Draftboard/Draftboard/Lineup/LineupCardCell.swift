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
    
    let shadowView = LineupCardShadowView()
    let createView = LineupCardCreateView()
    let lineupView = UIView()
    var lineupDetailView: LineupDetailView? { didSet { didSetLineupView() } }
    
    var createAction: () -> Void = {}
    
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
        contentView.addSubview(shadowView)
        contentView.addSubview(createView)
        contentView.addSubview(lineupView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            contentView.topRancor.constraintEqualToRancor(topRancor),
            contentView.leftRancor.constraintEqualToRancor(leftRancor),
            contentView.rightRancor.constraintEqualToRancor(rightRancor),
            contentView.bottomRancor.constraintEqualToRancor(bottomRancor),
            
            shadowView.topRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -5.0),
            shadowView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: -40.0),
            shadowView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: 40.0),
            shadowView.heightRancor.constraintEqualToConstant(25.0),
            
            createView.topRancor.constraintEqualToRancor(contentView.topRancor, constant: 2.0),
            createView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 2.0),
            createView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -2.0),
            createView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -2.0),

            lineupView.topRancor.constraintEqualToRancor(contentView.topRancor, constant: 2.0),
            lineupView.leftRancor.constraintEqualToRancor(contentView.leftRancor, constant: 2.0),
            lineupView.rightRancor.constraintEqualToRancor(contentView.rightRancor, constant: -2.0),
            lineupView.bottomRancor.constraintEqualToRancor(contentView.bottomRancor, constant: -2.0),
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        createView.translatesAutoresizingMaskIntoConstraints = false
        lineupView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        contentView.backgroundColor = .clearColor()
        
        shadowView.opaque = false
        shadowView.layer.rasterizationScale = UIScreen.mainScreen().scale
        shadowView.layer.shouldRasterize = true
        
        shadowView.layer.allowsEdgeAntialiasing = true
        createView.layer.allowsEdgeAntialiasing = true
        lineupView.layer.allowsEdgeAntialiasing = true
        
        createView.addTarget(self, action: .createViewTapped, forControlEvents: .TouchUpInside)
    }
    
    func createViewTapped() {
        createView.flashHighlightedState()
        createAction()
    }
    
    func didSetLineupView() {
        lineupView.hidden = (lineupDetailView == nil)
        createView.hidden = (lineupDetailView != nil)
        if let lineupDetailView = lineupDetailView {
            for subview in lineupView.subviews {
                subview.removeFromSuperview()
            }
            lineupView.addSubview(lineupDetailView)
            NSLayoutConstraint.activateConstraints([
                lineupDetailView.topRancor.constraintEqualToRancor(lineupView.topRancor),
                lineupDetailView.leftRancor.constraintEqualToRancor(lineupView.leftRancor),
                lineupDetailView.rightRancor.constraintEqualToRancor(lineupView.rightRancor),
                lineupDetailView.bottomRancor.constraintEqualToRancor(lineupView.bottomRancor),
            ])
        }
    }
    
    func fade(amount: CGFloat) {
        alpha = 1.0 - (amount * 0.5)
        shadowView.alpha = 1.0 - (amount * 0.5)
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

class LineupCardShadowView: UIView {
    override func drawRect(rect: CGRect) {
        print("drawRect")
        let radius = bounds.width * 0.5
        let center = CGPointMake(radius, radius)
        let black = UIColor(white: 0, alpha: 0.3).CGColor
        let clear = UIColor(white: 0, alpha: 0).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [black, clear], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(context, 1.0, bounds.height / bounds.width)
        CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
    }
}

class LineupCardCreateView: UIControl, CancelableTouchControl {
    
    let titleLabel = UILabel()
    let buttonLabel = UILabel()
    
    override var highlighted: Bool { didSet { didSetHighlighted() } }
    
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
        addSubview(titleLabel)
        addSubview(buttonLabel)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            titleLabel.topRancor.constraintEqualToRancor(topRancor, constant: 20.0),
            titleLabel.leftRancor.constraintEqualToRancor(leftRancor, constant: 20.0),
            
            buttonLabel.leftRancor.constraintEqualToRancor(leftRancor, constant: 20.0),
            buttonLabel.rightRancor.constraintEqualToRancor(rightRancor, constant: -20.0),
            buttonLabel.bottomRancor.constraintEqualToRancor(bottomRancor, constant: -20.0),
            buttonLabel.heightRancor.constraintEqualToConstant(35.0)
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        // Label
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 54.0
        let font = UIFont(name: "Oswald-Bold", size: 50.0)!
        titleLabel.attributedText = NSAttributedString(string: "IT’S\nANYONE’S\nGAME.", attributes: [
            NSBaselineOffsetAttributeName: font.descender,
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
        ])
        titleLabel.numberOfLines = 0
        
        // Button
        buttonLabel.font = UIFont(name: "OpenSans-Bold", size: 10)
        buttonLabel.text = "START DRAFTING"
        buttonLabel.textAlignment = .Center
        buttonLabel.textColor = .whiteColor()
        buttonLabel.layer.allowsEdgeAntialiasing = true
        buttonLabel.layer.borderWidth = 0.5
        buttonLabel.layer.borderColor = UIColor.greenDraftboard().CGColor
        
        // Self
        backgroundColor = .blueMediumDark()
    }
    
    func didSetHighlighted() {
        let color: UIColor = highlighted ? .greenDraftboard() : .clearColor()
        buttonLabel.layer.backgroundColor = color.CGColor
    }
    
    func flashHighlightedState() {
        highlighted = true
        UIView.animateWithDuration(0.5, animations: {
            self.highlighted = false
        })
    }
    
}

// MARK: -

protocol CancelableTouchControl {}
extension CancelableTouchControl {
    var touchesShouldCancel: Bool { return true }
}

private extension Selector {
    static let createViewTapped = #selector(LineupCardCell.createViewTapped)
}