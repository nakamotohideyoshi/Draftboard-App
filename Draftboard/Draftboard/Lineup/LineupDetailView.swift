//
//  LineupDetailView.swift
//  Draftboard
//
//  Created by Anson Schall on 5/17/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDetailView: UIView {
    
    let tableView = LineupPlayerTableView()
    let headerView = UIView()
    let footerView = UIView()
    
    // Header stuff
    let sportIcon = UIImageView()
    let nameField = TextField()
    let editButton = UIButton()
    let flipButton = UIButton()
    let columnLabel = UILabel()
    let headerBorderView = UIView()
    private let headerShadowView = HeaderShadowView()
    
    // Footer stuff
    let liveInLabel = UILabel()
    let liveInValue = UIView()
    let feesEntriesLabel = UILabel()
    let feesEntriesValue = UILabel()
    let statBoxOne = UIView()
    let statBoxTwo = UIView()
    let statBoxThree = UIView()
    let statBoxOneBorderView = UIView()
    let footerBorderView = UIView()
    private let footerShadowView = FooterShadowView()
    
    let newFooterView = LineupFooterView()
    
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
        addSubview(headerShadowView)
        addSubview(footerView)
        addSubview(footerShadowView)
        
        addSubview(newFooterView)
        
        headerView.addSubview(sportIcon)
        headerView.addSubview(nameField)
        headerView.addSubview(editButton)
        headerView.addSubview(flipButton)
        headerView.addSubview(columnLabel)
        headerView.addSubview(headerBorderView)
        
        footerView.addSubview(statBoxOne)
        footerView.addSubview(statBoxTwo)
        footerView.addSubview(statBoxThree)
        footerView.addSubview(footerBorderView)
        
        statBoxOne.addSubview(liveInLabel)
        statBoxOne.addSubview(liveInValue)
        statBoxOne.addSubview(statBoxOneBorderView)
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
            
            headerShadowView.topRancor.constraintEqualToRancor(headerView.bottomRancor),
            headerShadowView.leftRancor.constraintEqualToRancor(headerView.leftRancor),
            headerShadowView.rightRancor.constraintEqualToRancor(headerView.rightRancor),
            headerShadowView.heightRancor.constraintEqualToConstant(45.0),
            
            footerView.leftRancor.constraintEqualToRancor(leftRancor),
            footerView.rightRancor.constraintEqualToRancor(rightRancor),
            footerView.bottomRancor.constraintEqualToRancor(bottomRancor),
            footerView.heightRancor.constraintEqualToConstant(68.0),
            
            newFooterView.leftRancor.constraintEqualToRancor(leftRancor),
            newFooterView.rightRancor.constraintEqualToRancor(rightRancor),
            newFooterView.bottomRancor.constraintEqualToRancor(bottomRancor),
            newFooterView.heightRancor.constraintEqualToConstant(68.0),

            footerShadowView.leftRancor.constraintEqualToRancor(footerView.leftRancor),
            footerShadowView.rightRancor.constraintEqualToRancor(footerView.rightRancor),
            footerShadowView.bottomRancor.constraintEqualToRancor(footerView.topRancor),
            footerShadowView.heightRancor.constraintEqualToConstant(45.0),
            
            // Header
            sportIcon.leftRancor.constraintEqualToRancor(headerView.leftRancor, constant: 17.0),
            sportIcon.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            sportIcon.widthRancor.constraintEqualToConstant(13.0),
            sportIcon.heightRancor.constraintEqualToConstant(13.0),
            
            nameField.topRancor.constraintEqualToRancor(headerView.topRancor),
            nameField.leftRancor.constraintEqualToRancor(headerView.leftRancor),
            nameField.rightRancor.constraintEqualToRancor(editButton.leftRancor, constant: 15.0),
            nameField.bottomRancor.constraintEqualToRancor(headerView.bottomRancor),
            
            editButton.topRancor.constraintEqualToRancor(headerView.topRancor),
            editButton.bottomRancor.constraintEqualToRancor(headerView.bottomRancor),
            editButton.rightRancor.constraintEqualToRancor(flipButton.leftRancor),
            editButton.widthRancor.constraintEqualToConstant(44.0),
            
            flipButton.topRancor.constraintEqualToRancor(headerView.topRancor),
            flipButton.bottomRancor.constraintEqualToRancor(headerView.bottomRancor),
            flipButton.rightRancor.constraintEqualToRancor(headerView.rightRancor),
            flipButton.widthRancor.constraintEqualToConstant(44.0),
            
            headerBorderView.leftRancor.constraintEqualToRancor(headerView.leftRancor),
            headerBorderView.rightRancor.constraintEqualToRancor(headerView.rightRancor),
            headerBorderView.bottomRancor.constraintEqualToRancor(headerView.bottomRancor),
            headerBorderView.heightRancor.constraintEqualToConstant(1.0),
            
            // Footer
            statBoxOne.topRancor.constraintEqualToRancor(footerView.topRancor),
            statBoxOne.bottomRancor.constraintEqualToRancor(footerView.bottomRancor),
            statBoxOne.leftRancor.constraintEqualToRancor(footerView.leftRancor),
            statBoxOne.widthRancor.constraintEqualToRancor(footerView.widthRancor, multiplier: 0.5),
            
            statBoxOneBorderView.topRancor.constraintEqualToRancor(statBoxOne.topRancor),
            statBoxOneBorderView.bottomRancor.constraintEqualToRancor(statBoxOne.bottomRancor),
            statBoxOneBorderView.rightRancor.constraintEqualToRancor(statBoxOne.rightRancor),
            statBoxOneBorderView.widthRancor.constraintEqualToConstant(1.0),
            
            liveInLabel.topRancor.constraintEqualToRancor(statBoxOne.topRancor, constant: 14.0),
            liveInLabel.widthRancor.constraintEqualToRancor(statBoxOne.widthRancor, multiplier: 0.52),
            liveInLabel.centerXRancor.constraintEqualToRancor(statBoxOne.centerXRancor),
            
            liveInValue.leftRancor.constraintEqualToRancor(liveInLabel.leftRancor),
            liveInValue.topRancor.constraintEqualToRancor(liveInLabel.bottomRancor, constant: 0),
            
            footerBorderView.leftRancor.constraintEqualToRancor(footerView.leftRancor),
            footerBorderView.rightRancor.constraintEqualToRancor(footerView.rightRancor),
            footerBorderView.topRancor.constraintEqualToRancor(footerView.topRancor),
            footerBorderView.heightRancor.constraintEqualToConstant(1.0),

        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerShadowView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerShadowView.translatesAutoresizingMaskIntoConstraints = false
        
        newFooterView.translatesAutoresizingMaskIntoConstraints = false
        
        // Header
        sportIcon.translatesAutoresizingMaskIntoConstraints = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        flipButton.translatesAutoresizingMaskIntoConstraints = false
        headerBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        // Footer
        statBoxOne.translatesAutoresizingMaskIntoConstraints = false
        statBoxOneBorderView.translatesAutoresizingMaskIntoConstraints = false
        liveInLabel.translatesAutoresizingMaskIntoConstraints = false
        liveInValue.translatesAutoresizingMaskIntoConstraints = false
        feesEntriesLabel.translatesAutoresizingMaskIntoConstraints = false
        feesEntriesValue.translatesAutoresizingMaskIntoConstraints = false
        footerBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        tableView.backgroundColor = .whiteColor()
        headerView.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        footerView.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        headerShadowView.hidden = true
        footerShadowView.hidden = true
        headerShadowView.opaque = false
        footerShadowView.opaque = false
        headerShadowView.userInteractionEnabled = false
        footerShadowView.userInteractionEnabled = false

        if let headerEffectView = BlurEffectView(radius: 3) {
            headerEffectView.layer.allowsEdgeAntialiasing = true
            headerEffectView.frame = headerView.bounds
            headerEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            headerView.insertSubview(headerEffectView, atIndex: 0)
            headerView.backgroundColor = UIColor(white: 1.0, alpha: 0.85)
        }
        
        if let footerEffectView = BlurEffectView(radius: 3) {
            footerEffectView.frame = footerView.bounds
            footerEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            footerView.insertSubview(footerEffectView, atIndex: 0)
            footerView.backgroundColor = UIColor(white: 1.0, alpha: 0.85)
        }
        
        let headerBackgroundView = HeaderBackgroundView()
        headerBackgroundView.opaque = false
        headerBackgroundView.layer.shouldRasterize = true
        headerBackgroundView.frame = headerView.bounds
        headerBackgroundView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        headerView.insertSubview(headerBackgroundView, atIndex: 0)
        
        let footerBackgroundView = FooterBackgroundView()
        footerBackgroundView.opaque = false
        footerBackgroundView.layer.shouldRasterize = true
        footerBackgroundView.frame = footerView.bounds
        footerBackgroundView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        footerView.insertSubview(footerBackgroundView, atIndex: 0)

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
        
        sportIcon.image = UIImage(named: "icon-baseball")
        sportIcon.tintColor = UIColor(0x9c9faf)
        
        editButton.setImage(UIImage(named: "icon-edit"), forState: .Normal)
        editButton.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 4, 0)
        flipButton.setImage(UIImage(named: "icon-flip"), forState: .Normal)
        flipButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 4)
        
        nameField.delegate = self
        nameField.edgeInsets = UIEdgeInsetsMake(0, 44, 0, 0)
        nameField.font = UIFont.openSansRegular()?.fontWithSize(16.0)
        nameField.textColor = UIColor(0x46495e)
        nameField.clearButtonMode = .WhileEditing
        nameField.placeholder = "Lineup Name"
        nameField.returnKeyType = .Done
//        nameField.userInteractionEnabled = false
//        headerView.userInteractionEnabled = false
        
        headerBorderView.backgroundColor = UIColor(0xebedf2)
        footerBorderView.backgroundColor = UIColor(0xebedf2)
        statBoxOneBorderView.backgroundColor = UIColor(0xebedf2)
        
        headerView.layer.allowsEdgeAntialiasing = true
        headerBackgroundView.layer.allowsEdgeAntialiasing = true
        
        liveInLabel.font = UIFont(name: "OpenSans-Semibold", size: 8.0)
        liveInLabel.textColor = UIColor(0x09c9faf)
        liveInLabel.text = "Live In".uppercaseString
        
        
        footerView.hidden = true
        footerBackgroundView.hidden = true
        footerShadowView.hidden = true
        

//        liveInValue.date = 
        
        editButton.addTarget(self, action: .editButtonTapped, forControlEvents: .TouchUpInside)
    }
    
    func editButtonTapped() {
        editAction()
    }
    
}

private class HeaderBackgroundView: UIView {
    override func drawRect(rect: CGRect) {
        let white = UIColor(white: 1, alpha: 1).CGColor
        let clear = UIColor(white: 1, alpha: 0).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [white, clear], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawLinearGradient(context, gradient, CGPointMake(bounds.width * 0.3, bounds.height * 0.25), CGPointMake(bounds.width * 0.28, bounds.height * 1.0), [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
    }
}

private class FooterBackgroundView: UIView {
    override func drawRect(rect: CGRect) {
        let white = UIColor(white: 1, alpha: 1).CGColor
        let clear = UIColor(white: 1, alpha: 0).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [white, clear], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawLinearGradient(context, gradient, CGPointMake(bounds.width * 0.3, bounds.height * 0.75), CGPointMake(bounds.width * 0.28, bounds.height * 0.0), [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
    }
    
}

private class HeaderShadowView: UIView {
    override func drawRect(rect: CGRect) {
        let black = UIColor(white: 0, alpha: 0.05).CGColor
        let clear = UIColor(white: 0, alpha: 0).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [black, clear], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, bounds.height), [])
    }
}

private class FooterShadowView: UIView {
    override func drawRect(rect: CGRect) {
        let black = UIColor(white: 0, alpha: 0.05).CGColor
        let clear = UIColor(white: 0, alpha: 0).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [black, clear], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, bounds.height), CGPointMake(0, 0), [])
    }
}

class LineupFooterView: UIView {
    
    // Normal configuration is [countdown | feesEntries]
    // Editing configuration is [countdown | totalSalaryRem | avgSalaryRem]
    // Live configuration is [points | winnings | pmr]

    let countdown = StatView()
    let feesEntries = StatView()
    let totalSalaryRem = StatView()
    let avgSalaryRem = StatView()
    
    var halfWidthConstraints = [NSLayoutConstraint]()
    var thirdWidthConstraints = [NSLayoutConstraint]()
    
//    let points = StatView()
//    let winnings = StatView()
//    let pmr = StatView()

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
        addSubview(countdown)
        addSubview(feesEntries)
        addSubview(totalSalaryRem)
        addSubview(avgSalaryRem)
    }
    
    func addConstraints() {
        // Normal configuration is [countdown | feesEntries]
        // Editing configuration is [countdown | totalSalaryRem | avgSalaryRem]
        
        let viewConstraints: [NSLayoutConstraint] = [
            countdown.topRancor.constraintEqualToRancor(topRancor),
            countdown.bottomRancor.constraintEqualToRancor(bottomRancor),
            countdown.leftRancor.constraintEqualToRancor(leftRancor, constant: 1.0),
            
            feesEntries.topRancor.constraintEqualToRancor(topRancor),
            feesEntries.bottomRancor.constraintEqualToRancor(bottomRancor),
            feesEntries.leftRancor.constraintEqualToRancor(countdown.rightRancor),
            
            totalSalaryRem.topRancor.constraintEqualToRancor(topRancor),
            totalSalaryRem.bottomRancor.constraintEqualToRancor(bottomRancor),
            totalSalaryRem.leftRancor.constraintEqualToRancor(countdown.rightRancor),
            
            avgSalaryRem.topRancor.constraintEqualToRancor(topRancor),
            avgSalaryRem.bottomRancor.constraintEqualToRancor(bottomRancor),
            avgSalaryRem.leftRancor.constraintEqualToRancor(totalSalaryRem.rightRancor),
        ]
        
        halfWidthConstraints = [
            countdown.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.5),
            feesEntries.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.5),
            totalSalaryRem.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.5),
            avgSalaryRem.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.5),
        ]
        
        thirdWidthConstraints = [
            countdown.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.333),
            feesEntries.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.333),
            totalSalaryRem.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.333),
            avgSalaryRem.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.333),
        ]

        
        translatesAutoresizingMaskIntoConstraints = false
        countdown.translatesAutoresizingMaskIntoConstraints = false
        feesEntries.translatesAutoresizingMaskIntoConstraints = false
        totalSalaryRem.translatesAutoresizingMaskIntoConstraints = false
        avgSalaryRem.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activateConstraints(viewConstraints + halfWidthConstraints)
    }
    
    func otherSetup() {
        backgroundColor = .whiteColor()
        clipsToBounds = true
        
        countdown.titleLabel.text = "LIVE IN"
        countdown.valueLabel.text = "00:00:00"
        
        feesEntries.titleLabel.text = "FEES / ENTRIES"
        feesEntries.valueLabel.text = "$234 / 22"
        
        totalSalaryRem.titleLabel.text = "SALARY REM."
        totalSalaryRem.valueLabel.text = "$50,000"
        
        avgSalaryRem.titleLabel.text = "SALARY REM. / PLAYER"
        avgSalaryRem.valueLabel.text = "$6,250"
        
        totalSalaryRem.alpha = 0
        avgSalaryRem.alpha = 0
    }

    func showTwoBoxes() {
        // If three boxes, animate frames then update constraints
        UIView.animateWithDuration(0.25) {
            NSLayoutConstraint.deactivateConstraints(self.thirdWidthConstraints)
            NSLayoutConstraint.activateConstraints(self.halfWidthConstraints)
            self.layoutIfNeeded()
            self.totalSalaryRem.alpha = 0
            self.avgSalaryRem.alpha = 0
            self.feesEntries.alpha = 1
        }
    }
    
    func showThreeBoxes() {
        // If two boxes, animate frames then update constraints
        UIView.animateWithDuration(0.25) {
            NSLayoutConstraint.deactivateConstraints(self.halfWidthConstraints)
            NSLayoutConstraint.activateConstraints(self.thirdWidthConstraints)
            self.layoutIfNeeded()
            self.totalSalaryRem.alpha = 1
            self.avgSalaryRem.alpha = 1
            self.feesEntries.alpha = 0
        }
    }
}

class StatView: UIView {
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    let rightBorderView = UIView()
    
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
        addSubview(valueLabel)
        addSubview(rightBorderView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            titleLabel.centerXRancor.constraintEqualToRancor(centerXRancor),
            titleLabel.centerYRancor.constraintEqualToRancor(centerYRancor, constant: -14.0),
            titleLabel.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.52),
            
            valueLabel.leftRancor.constraintEqualToRancor(titleLabel.leftRancor),
            valueLabel.topRancor.constraintEqualToRancor(titleLabel.bottomRancor, constant: 0),
            
            rightBorderView.topRancor.constraintEqualToRancor(topRancor),
            rightBorderView.bottomRancor.constraintEqualToRancor(bottomRancor),
            rightBorderView.rightRancor.constraintEqualToRancor(rightRancor),
            rightBorderView.widthRancor.constraintEqualToConstant(1.0),
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        rightBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        titleLabel.font = UIFont(name: "OpenSans-Semibold", size: 8.0)
        titleLabel.textColor = UIColor(0x09c9faf)

        valueLabel.font = UIFont(name: "Oswald-Regular", size: 18.0)
        valueLabel.textColor = UIColor(0x46495e)
        
        rightBorderView.backgroundColor = UIColor(0xebedf2)
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

private typealias TextFieldDelegate = LineupDetailView
extension TextFieldDelegate: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        return true
    }
}

private extension Selector {
    static let editButtonTapped = #selector(LineupDetailView.editButtonTapped)
}
