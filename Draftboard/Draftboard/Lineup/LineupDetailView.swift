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
    let footerView = LineupFooterView()
    
    // Header stuff
    let sportIcon = UIImageView()
    let nameField = TextField()
    let editButton = UIButton()
    let flipButton = UIButton()
    let columnLabel = UILabel()
    let headerBorderView = UIView()
    private let headerShadowView = HeaderShadowView()
    
    // Footer stuff
//    private let footerShadowView = FooterShadowView()
    
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
//        addSubview(footerShadowView)
        
        headerView.addSubview(sportIcon)
        headerView.addSubview(nameField)
        headerView.addSubview(editButton)
        headerView.addSubview(flipButton)
        headerView.addSubview(columnLabel)
        headerView.addSubview(headerBorderView)
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
            
//            footerShadowView.leftRancor.constraintEqualToRancor(footerView.leftRancor),
//            footerShadowView.rightRancor.constraintEqualToRancor(footerView.rightRancor),
//            footerShadowView.bottomRancor.constraintEqualToRancor(footerView.topRancor),
//            footerShadowView.heightRancor.constraintEqualToConstant(45.0),
            
            // Header
            sportIcon.leftRancor.constraintEqualToRancor(headerView.leftRancor, constant: 17.0),
            sportIcon.centerYRancor.constraintEqualToRancor(headerView.centerYRancor),
            sportIcon.widthRancor.constraintEqualToConstant(13.0),
            sportIcon.heightRancor.constraintEqualToConstant(13.0),
            
            nameField.topRancor.constraintEqualToRancor(headerView.topRancor),
            nameField.leftRancor.constraintEqualToRancor(headerView.leftRancor),
            nameField.rightRancor.constraintEqualToRancor(headerView.rightRancor),
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
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerShadowView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
//        footerShadowView.translatesAutoresizingMaskIntoConstraints = false
        
        // Header
        sportIcon.translatesAutoresizingMaskIntoConstraints = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        flipButton.translatesAutoresizingMaskIntoConstraints = false
        headerBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        tableView.backgroundColor = .whiteColor()
        headerView.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        footerView.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        headerShadowView.hidden = true
//        footerShadowView.hidden = true
        headerShadowView.opaque = false
//        footerShadowView.opaque = false
        headerShadowView.userInteractionEnabled = false
//        footerShadowView.userInteractionEnabled = false

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
        
        sportIcon.image = UIImage(named: "icon-baseball")
        sportIcon.tintColor = UIColor(0x9c9faf)
        
        editButton.setImage(UIImage(named: "icon-edit"), forState: .Normal)
        editButton.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 4, 0)
        flipButton.setImage(UIImage(named: "icon-flip"), forState: .Normal)
        flipButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 4)
        
        nameField.clearButtonEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        nameField.edgeInsets = UIEdgeInsetsMake(0, 44, 0, 0)
        nameField.clearButtonMode = .Never
        nameField.font = UIFont.openSansRegular()?.fontWithSize(16.0)
        nameField.textColor = UIColor(0x46495e)
        nameField.returnKeyType = .Done
        nameField.userInteractionEnabled = false
        
        headerBorderView.backgroundColor = UIColor(0xebedf2)
        
        headerView.layer.allowsEdgeAntialiasing = true
        headerBackgroundView.layer.allowsEdgeAntialiasing = true
        
        footerBackgroundView.hidden = true
//        footerShadowView.hidden = true
        
        tableView.contentInset = UIEdgeInsetsMake(68, 0, 68, 0)
        tableView.contentOffset = CGPointMake(0, -68)
        tableView.scrollIndicatorInsets = tableView.contentInset


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

//protocol StatFooterDataSource {
//    func footerStatAvgSalary() -> Double?
//    func footerStatRemSalary() -> Double?
//    func footerStatLiveInDate() -> NSDate?
//}


class LineupFooterView: UIView {
    
    enum FooterConfiguration {
        case Normal  // [ countdown | feesEntries ]
        case Editing // [ countdown | totalSalaryRem | avgSalaryRem ]
        case Live    // [ points | winnings | pmr ]
    }
    
    var configuration: FooterConfiguration = .Normal { didSet { update() } }
    
    let countdown = CountdownStatView()
    let feesEntries = StatView()
    let totalSalaryRem = StatView()
    let avgSalaryRem = StatView()
    let points = StatView()
    let winnings = StatView()
    let pmr = StatView()
    let topBorderView = UIView()

    var halfWidthConstraints = [NSLayoutConstraint]()
    var thirdWidthConstraints = [NSLayoutConstraint]()

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
        addSubview(points)
        addSubview(winnings)
        addSubview(pmr)
        addSubview(topBorderView)
    }
    
    func addConstraints() {
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
            
            points.topRancor.constraintEqualToRancor(topRancor),
            points.bottomRancor.constraintEqualToRancor(bottomRancor),
            points.leftRancor.constraintEqualToRancor(leftRancor, constant: 1.0),
            
            winnings.topRancor.constraintEqualToRancor(topRancor),
            winnings.bottomRancor.constraintEqualToRancor(bottomRancor),
            winnings.leftRancor.constraintEqualToRancor(points.rightRancor),
            
            pmr.topRancor.constraintEqualToRancor(topRancor),
            pmr.bottomRancor.constraintEqualToRancor(bottomRancor),
            pmr.leftRancor.constraintEqualToRancor(winnings.rightRancor),

            topBorderView.topRancor.constraintEqualToRancor(topRancor),
            topBorderView.leftRancor.constraintEqualToRancor(leftRancor),
            topBorderView.rightRancor.constraintEqualToRancor(rightRancor),
            topBorderView.heightRancor.constraintEqualToConstant(1.0),
        ]
        
        halfWidthConstraints = [
            countdown.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.5),
            feesEntries.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.5),
            totalSalaryRem.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.5),
            avgSalaryRem.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.5),
            points.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.5),
            winnings.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.5),
            pmr.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.5),
        ]
        
        thirdWidthConstraints = [
            countdown.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.333),
            feesEntries.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.333),
            totalSalaryRem.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.333),
            avgSalaryRem.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.333),
            points.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.333),
            winnings.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.333),
            pmr.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.333),
        ]
        
        translatesAutoresizingMaskIntoConstraints = false
        countdown.translatesAutoresizingMaskIntoConstraints = false
        feesEntries.translatesAutoresizingMaskIntoConstraints = false
        totalSalaryRem.translatesAutoresizingMaskIntoConstraints = false
        avgSalaryRem.translatesAutoresizingMaskIntoConstraints = false
        points.translatesAutoresizingMaskIntoConstraints = false
        winnings.translatesAutoresizingMaskIntoConstraints = false
        pmr.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activateConstraints(viewConstraints + halfWidthConstraints)
    }
    
    func otherSetup() {
        backgroundColor = .whiteColor()
        clipsToBounds = true
        
        topBorderView.backgroundColor = UIColor(0xebedf2)
        
        // Values
        countdown.titleLabel.text = "LIVE IN"
        countdown.countdownView.date = NSDate().dateByAddingTimeInterval(60)
        
        feesEntries.titleLabel.text = "FEES / ENTRIES"
        feesEntries.valueLabel.text = "\(Format.currency.stringFromNumber(0.00)!) / \(0)"
        
        totalSalaryRem.titleLabel.text = "REM. SALARY"
        totalSalaryRem.valueLabel.text = Format.currency.stringFromNumber(0.00)!
        
        avgSalaryRem.titleLabel.text = "AVG. SALARY REM."
        avgSalaryRem.valueLabel.text = Format.currency.stringFromNumber(0.00)!
        
        points.titleLabel.text = "POINTS"
        points.valueLabel.text = "\(0)"
        
        winnings.titleLabel.text = "WINNINGS"
        winnings.valueLabel.text = Format.currency.stringFromNumber(0.00)!
        
        pmr.titleLabel.text = "PMR"
        pmr.valueLabel.text = "\(0)"
        
        update()
    }

    func update() {
        if configuration == .Normal {
//            UIView.animateWithDuration(0.25) {
                NSLayoutConstraint.deactivateConstraints(self.thirdWidthConstraints)
                NSLayoutConstraint.activateConstraints(self.halfWidthConstraints)
                self.layoutIfNeeded()
                self.countdown.alpha = 1
                self.feesEntries.alpha = 1
                self.totalSalaryRem.alpha = 0
                self.avgSalaryRem.alpha = 0
                self.points.alpha = 0
                self.winnings.alpha = 0
                self.pmr.alpha = 0
//            }
        } else if configuration == .Editing {
//            UIView.animateWithDuration(0.25) {
                NSLayoutConstraint.deactivateConstraints(self.halfWidthConstraints)
                NSLayoutConstraint.activateConstraints(self.thirdWidthConstraints)
                self.layoutIfNeeded()
                self.countdown.alpha = 1
                self.feesEntries.alpha = 0
                self.totalSalaryRem.alpha = 1
                self.avgSalaryRem.alpha = 1
                self.points.alpha = 0
                self.winnings.alpha = 0
                self.pmr.alpha = 0
//            }
        } else if configuration == .Live {
//            UIView.animateWithDuration(0.25) {
                NSLayoutConstraint.deactivateConstraints(self.halfWidthConstraints)
                NSLayoutConstraint.activateConstraints(self.thirdWidthConstraints)
                self.layoutIfNeeded()
                self.countdown.alpha = 0
                self.feesEntries.alpha = 0
                self.totalSalaryRem.alpha = 0
                self.avgSalaryRem.alpha = 0
                self.points.alpha = 1
                self.winnings.alpha = 1
                self.pmr.alpha = 1
//            }
        }
    }
}

class CountdownStatView: StatView {
    var countdownView: CountdownView { return valueLabel as! CountdownView }
    
    override func setup() {
        valueLabel = CountdownView(date: NSDate(), size: 18.0, color: UIColor(0x46495e))
        super.setup()
    }
}

class StatView: UIView {
    var titleLabel = UILabel()
    var valueLabel = UILabel()
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
            titleLabel.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.6),
            
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
    var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero
    var clearButtonEdgeInsets: UIEdgeInsets = UIEdgeInsetsZero
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, edgeInsets))
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
    override func clearButtonRectForBounds(bounds: CGRect) -> CGRect {
        return super.clearButtonRectForBounds(UIEdgeInsetsInsetRect(bounds, clearButtonEdgeInsets))
    }
}

private extension Selector {
    static let editButtonTapped = #selector(LineupDetailView.editButtonTapped)
}
