//
//  LineupDetailControllerView.swift
//  Draftboard
//
//  Created by Anson Schall on 5/17/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDetailControllerView: UIView {
    
    let tableView = LineupPlayerTableView()
    let headerView = UIView()
    let footerView = UIView()
    
    // Header stuff
    let sportIcon = UIImageView()
    let nameField = TextField()
    let editButton = UIButton()
    let flipButton = UIButton()
    let columnLabel = UILabel()
    
    // Footer stuff
    let statBoxOne = UIView()
    let statBoxTwo = UIView()
    let statBoxThree = UIView()
    
//    var lineup: Lineup? {
//        didSet {
//            lineupView.hidden = (lineup == nil)
//            createView.hidden = (lineup != nil)
//        }
//    }
    
    var editAction: () -> Void = {}
    
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
        addSubview(tableView)
        addSubview(headerView)
        addSubview(footerView)
        
        headerView.addSubview(sportIcon)
        headerView.addSubview(nameField)
        headerView.addSubview(editButton)
        headerView.addSubview(flipButton)
        headerView.addSubview(columnLabel)
        
        footerView.addSubview(statBoxOne)
        footerView.addSubview(statBoxTwo)
        footerView.addSubview(statBoxThree)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            tableView.topRancor.constraintEqualToRancor(topRancor),
            tableView.leftRancor.constraintEqualToRancor(leftRancor),
            tableView.rightRancor.constraintEqualToRancor(rightRancor),
            tableView.bottomRancor.constraintEqualToRancor(bottomRancor),
            
            headerView.topRancor.constraintEqualToRancor(topRancor),
            headerView.leftRancor.constraintEqualToRancor(leftRancor),
            headerView.rightRancor.constraintEqualToRancor(rightRancor),
            headerView.heightRancor.constraintEqualToConstant(68.0),
            
            footerView.leftRancor.constraintEqualToRancor(leftRancor),
            footerView.rightRancor.constraintEqualToRancor(rightRancor),
            footerView.bottomRancor.constraintEqualToRancor(bottomRancor),
            footerView.heightRancor.constraintEqualToConstant(68.0),
            
            // Header
            sportIcon.leftRancor.constraintEqualToRancor(headerView.leftRancor, constant: 15.0),
            sportIcon.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            sportIcon.widthRancor.constraintEqualToConstant(12.0),
            sportIcon.heightRancor.constraintEqualToConstant(12.0),
            
            nameField.topRancor.constraintEqualToRancor(headerView.topRancor),
            nameField.leftRancor.constraintEqualToRancor(headerView.leftRancor),
            nameField.rightRancor.constraintEqualToRancor(editButton.leftRancor, constant: 10.0),
            nameField.bottomRancor.constraintEqualToRancor(headerView.bottomRancor),
            
            editButton.topRancor.constraintEqualToRancor(headerView.topRancor),
            editButton.bottomRancor.constraintEqualToRancor(headerView.bottomRancor),
            editButton.rightRancor.constraintEqualToRancor(flipButton.leftRancor),
            editButton.widthRancor.constraintEqualToConstant(44.0),
            
            flipButton.topRancor.constraintEqualToRancor(headerView.topRancor),
            flipButton.bottomRancor.constraintEqualToRancor(headerView.bottomRancor),
            flipButton.rightRancor.constraintEqualToRancor(headerView.rightRancor),
            flipButton.widthRancor.constraintEqualToConstant(44.0),
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        sportIcon.translatesAutoresizingMaskIntoConstraints = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        flipButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        tableView.backgroundColor = .whiteColor()
        headerView.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        footerView.backgroundColor = UIColor(white: 1.0, alpha: 0.9)

//        headerView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
//        footerView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)

        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            let blurEffectView = APCustomBlurView()
//            let blurEffectView = UIVisualEffectView()
//            blurEffectView.effect = UIBlurEffect()
            //always fill the view
            blurEffectView.setBlurRadius(3)
            blurEffectView.frame = headerView.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            let blurEffectView2 = APCustomBlurView()
            blurEffectView2.setBlurRadius(3)
            blurEffectView2.frame = footerView.bounds
            blurEffectView2.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

            headerView.backgroundColor = UIColor(white: 1.0, alpha: 0.85)
            footerView.backgroundColor = UIColor(white: 1.0, alpha: 0.85)

            headerView.insertSubview(blurEffectView, atIndex: 0)
            footerView.insertSubview(blurEffectView2, atIndex: 0)
            
            let headerBackgroundView = HeaderBackgroundView()
            headerBackgroundView.opaque = false
            headerBackgroundView.layer.shouldRasterize = true
            headerBackgroundView.frame = headerView.bounds
            headerBackgroundView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            headerView.insertSubview(headerBackgroundView, atIndex: 0)
//            headerView.insertSubview(HeaderBackgroundView(), atIndex: 0)
            
            let footerBackgroundView = FooterBackgroundView()
            footerBackgroundView.opaque = false
            footerBackgroundView.layer.shouldRasterize = true
            footerBackgroundView.frame = footerView.bounds
            footerBackgroundView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            footerView.insertSubview(footerBackgroundView, atIndex: 0)

        }

        
        footerView.userInteractionEnabled = false
        
//        sportIcon.backgroundColor = .blueColor()
//        nameField.backgroundColor = UIColor(0xFFFF00, alpha: 0.5)
//        editButton.backgroundColor = .redColor()
//        flipButton.backgroundColor = .yellowColor()
        
//        tableView.allowsSelection = false
//        tableView.showsVerticalScrollIndicator = true
//        tableView.contentInset = UIEdgeInsetsMake(68, 0, 68, 0)
//        tableView.contentOffset = CGPointMake(0, -68)
//        tableView.scrollIndicatorInsets = tableView.contentInset
        
        sportIcon.image = UIImage(named: "icon-basketball")
        sportIcon.tintColor = UIColor(0x9c9faf)
        
        editButton.setImage(UIImage(named: "icon-edit"), forState: .Normal)
        editButton.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0)
        flipButton.setImage(UIImage(named: "icon-flip"), forState: .Normal)
        flipButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4)
        
        nameField.delegate = self
        nameField.edgeInsets = UIEdgeInsetsMake(0, 44, 0, 0)
        nameField.font = UIFont.openSansRegular()?.fontWithSize(16.0)
        nameField.textColor = .blackColor()
        nameField.clearButtonMode = .WhileEditing
        nameField.placeholder = "Lineup Name"
        nameField.returnKeyType = .Done
        nameField.userInteractionEnabled = false
        
        editButton.addTarget(self, action: .editButtonTapped, forControlEvents: .TouchUpInside)
    }
    
    func editButtonTapped() {
        editAction()
    }
    
//    func dequeueCellForIndexPath(indexPath: NSIndexPath) -> PlayerCell {
//        return dequeueReusableCellWithReuseIdentifier(PlayerCell.reuseIdentifier, forIndexPath: indexPath) as! PlayerCell
//    }

    
}

private class HeaderBackgroundView: UIView {
    override func drawRect(rect: CGRect) {
        let white = UIColor(white: 1, alpha: 1).CGColor
        let clear = UIColor(white: 1, alpha: 0).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [white, clear], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawLinearGradient(context, gradient, CGPointMake(bounds.width * 0.3, bounds.height * 0.25), CGPointMake(bounds.width * 0.28, bounds.height * 1.0), [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
//        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, bounds.height * 0.15), CGPointMake(0, bounds.height), [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
    }

}

private class FooterBackgroundView: UIView {
    override func drawRect(rect: CGRect) {
        let white = UIColor(white: 1, alpha: 1).CGColor
        let clear = UIColor(white: 1, alpha: 0).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [white, clear], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawLinearGradient(context, gradient, CGPointMake(bounds.width * 0.3, bounds.height * 0.75), CGPointMake(bounds.width * 0.28, bounds.height * 0.0), [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
//        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, bounds.height * 0.85), CGPointMake(0, 0), [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
    }
    
}


class TextField: UITextField {
    lazy var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, edgeInsets))
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
}

private typealias TextFieldDelegate = LineupDetailControllerView
extension TextFieldDelegate: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        return true
    }
}

private extension Selector {
    static let editButtonTapped = #selector(LineupDetailControllerView.editButtonTapped)
}
