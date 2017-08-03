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
    let overlayView = UIControl()
    let footerView = LineupFooterView()
    
    // Header stuff
    let sportIcon = UIImageView()
    let nameField = TextField()
    let editButton = UIButton()
    let flipButton = UIButton()
    let columnLabel = DraftboardLabel()
    let headerBorderView = UIView()
    private let headerShadowView = HeaderShadowView()
    
    // TableView stuff
    let whiteBackgroundView = UIView()
    private let tableTopShadowView = TableTopShadowView()
    private let tableBottomShadowView = TableBottomShadowView()
    
    // Footer stuff
//    private let footerShadowView = FooterShadowView()
    
//    var lineup: Lineup? {
//        didSet {
//            lineupView.hidden = (lineup == nil)
//            createView.hidden = (lineup != nil)
//        }
//    }
    
    var editAction: () -> Void = {}
    var flipAction: () -> Void = {}
    
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
        addSubview(whiteBackgroundView)
        addSubview(tableTopShadowView)
        addSubview(tableBottomShadowView)
        addSubview(tableView)
        addSubview(footerView)
        addSubview(overlayView)
        addSubview(headerView)
        addSubview(headerShadowView)
//        addSubview(footerShadowView)
        
        headerView.addSubview(sportIcon)
        headerView.addSubview(nameField)
        headerView.addSubview(editButton)
        headerView.addSubview(flipButton)
        headerView.addSubview(columnLabel)
        headerView.addSubview(headerBorderView)
    }
    
    
    override func layoutSubviews() {
        let screenH = RootViewController.sharedInstance.view.bounds.height
        let boundsH = bounds.height
        let titleBarH: CGFloat = (boundsH == screenH) ? 76 : 0
        
        tableView.frame = CGRectMake(0, titleBarH, bounds.width, bounds.height - titleBarH)
        whiteBackgroundView.frame = CGRectMake(0, titleBarH, bounds.width, bounds.height - titleBarH)
        tableTopShadowView.frame = CGRectMake(0, titleBarH + 68, bounds.width, 48)
        tableBottomShadowView.frame = CGRectMake(0, bounds.height - 116, bounds.width, 48)
        headerView.frame = CGRectMake(0, titleBarH, bounds.width, 68)
        headerShadowView.frame = CGRectMake(0, 0, bounds.width, 45)
        overlayView.frame = CGRectMake(0, titleBarH + headerView.frame.height, bounds.width, bounds.height - headerView.frame.height - titleBarH)
        footerView.frame = CGRectMake(0, bounds.height - 68, bounds.width, 68)
        
        sportIcon.frame = CGRectMake(17, headerView.bounds.height * 0.5 - 13 * 0.5, 13, 13)
        nameField.frame = headerView.bounds
        editButton.frame = CGRectMake(headerView.bounds.width - 88, 0, 44, headerView.bounds.height)
        flipButton.frame = CGRectMake(headerView.bounds.width - 44, 0, 44, headerView.bounds.height)
        headerBorderView.frame = CGRectMake(0, headerView.bounds.height - 1, headerView.bounds.width, 1)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            columnLabel.bottomRancor.constraintEqualToRancor(headerView.bottomRancor, constant: -2),
            columnLabel.rightRancor.constraintEqualToRancor(headerView.rightRancor, constant: -18)
        ]
        
        columnLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        overlayView.alpha = 0
        overlayView.userInteractionEnabled = false
        whiteBackgroundView.backgroundColor = .whiteColor()
        tableView.backgroundColor = .clearColor()
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
        
        nameField.clearButtonEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 14)
        nameField.edgeInsets = UIEdgeInsetsMake(0, 44, 0, 0)
        nameField.clearButtonMode = .Never
        nameField.font = UIFont.openSansRegular()?.fontWithSize(16.0)
        nameField.textColor = UIColor(0x46495e)
        nameField.returnKeyType = .Done
        nameField.userInteractionEnabled = false
        
        columnLabel.font = .openSans(weight: .Semibold, size: 7)
        columnLabel.textColor = UIColor(0x6d718a)
        columnLabel.letterSpacing = 0.5
        columnLabel.text = "Salary".uppercaseString
        
        headerBorderView.backgroundColor = UIColor(0xebedf2)
        
        headerView.layer.allowsEdgeAntialiasing = true
        headerBackgroundView.layer.allowsEdgeAntialiasing = true
        
        footerBackgroundView.hidden = true
//        footerShadowView.hidden = true
        
        tableView.contentInset = UIEdgeInsetsMake(68, 0, 68, 0)
        tableView.contentOffset = CGPointMake(0, -68)
        tableView.scrollIndicatorInsets = tableView.contentInset

        editButton.addTarget(self, action: #selector(editButtonTapped), forControlEvents: .TouchUpInside)
        flipButton.addTarget(self, action: #selector(flipButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    func editButtonTapped() {
        editAction()
    }
    
    func flipButtonTapped() {
        flipAction()
    }
    
    func hideOverlay() {
        overlayView.userInteractionEnabled = false
        UIView.animateWithDuration(0.25) {
            self.overlayView.alpha = 0
        }
    }
    
    func showOverlay() {
        overlayView.userInteractionEnabled = true
        UIView.animateWithDuration(0.25) {
            self.overlayView.alpha = 1.0
        }
    }
    
}

private class HeaderBackgroundView: UIView {
    override func drawRect(rect: CGRect) {
        let white = UIColor(white: 1, alpha: 1).CGColor
        let clear = UIColor(white: 1, alpha: 0).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [white, clear], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawLinearGradient(context!, gradient!, CGPointMake(bounds.width * 0.3, bounds.height * 0.25), CGPointMake(bounds.width * 0.28, bounds.height * 1.0), [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
    }
}

private class FooterBackgroundView: UIView {
    override func drawRect(rect: CGRect) {
        let white = UIColor(white: 1, alpha: 1).CGColor
        let clear = UIColor(white: 1, alpha: 0).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [white, clear], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawLinearGradient(context!, gradient!, CGPointMake(bounds.width * 0.3, bounds.height * 0.75), CGPointMake(bounds.width * 0.28, bounds.height * 0.0), [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
    }
    
}

private class HeaderShadowView: UIView {
    override func drawRect(rect: CGRect) {
        let black = UIColor(white: 0, alpha: 0.05).CGColor
        let clear = UIColor(white: 0, alpha: 0).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [black, clear], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawLinearGradient(context!, gradient!, CGPointMake(0, 0), CGPointMake(0, bounds.height), [])
    }
}

private class FooterShadowView: UIView {
    override func drawRect(rect: CGRect) {
        let black = UIColor(white: 0, alpha: 0.05).CGColor
        let clear = UIColor(white: 0, alpha: 0).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [black, clear], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawLinearGradient(context!, gradient!, CGPointMake(0, bounds.height), CGPointMake(0, 0), [])
    }
}

private class TableTopShadowView: UIView {
    override func drawRect(rect: CGRect) {
        let gray = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0).CGColor
        let white = UIColor(white: 1, alpha: 1).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [gray, white], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawLinearGradient(context!, gradient!, CGPointMake(0, 0), CGPointMake(0, bounds.height), [])
    }
}

private class TableBottomShadowView: UIView {
    override func drawRect(rect: CGRect) {
        let gray = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0).CGColor
        let white = UIColor(white: 1, alpha: 1).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [white, gray], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawLinearGradient(context!, gradient!, CGPointMake(0, 0), CGPointMake(0, bounds.height), [])
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
    let fees = StatView()
    let entries = StatView()
    let totalSalaryRem = StatView()
    let avgSalaryRem = StatView()
    let points = StatView()
    let winnings = StatView()
    let pmr = StatView()
    let topBorderView = UIView()

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
        otherSetup()
    }
    
    func addSubviews() {
        addSubview(countdown)
        addSubview(fees)
        addSubview(entries)
        addSubview(totalSalaryRem)
        addSubview(avgSalaryRem)
        addSubview(points)
        addSubview(winnings)
        addSubview(pmr)
        addSubview(topBorderView)
    }
    
    override func layoutSubviews() {
        // [ countdown | fees | entries ]
        // [ countdown | totalSalaryRem | avgSalaryRem ]
        // [ points | winnings | pmr ]

        // Half width for Normal, third width for Editing or Live
        let width = 0.333 * bounds.width + 1
        countdown.frame = CGRectMake(0, 0, width, bounds.height)
        fees.frame = CGRectMake(width, 0, width, bounds.height)
        entries.frame = CGRectMake(width * 2, 0, width, bounds.height)
        totalSalaryRem.frame = CGRectMake(width, 0, width, bounds.height)
        avgSalaryRem.frame = CGRectMake(width * 2, 0, width, bounds.height)
        points.frame = CGRectMake(0, 0, width, bounds.height)
        winnings.frame = CGRectMake(width, 0, width, bounds.height)
        pmr.frame = CGRectMake(width * 2, 0, width, bounds.height)
        topBorderView.frame = CGRectMake(0, 0, bounds.width, 1)
    }
    
    func otherSetup() {
        backgroundColor = .whiteColor()
        clipsToBounds = true
        
        topBorderView.backgroundColor = UIColor(0xebedf2)
        
        // Values
        countdown.titleLabel.text = "LIVE IN"
        countdown.countdownView.date = NSDate().dateByAddingTimeInterval(60)
        
        fees.titleLabel.text = "FEES"
        fees.valueLabel.text = "\(Format.currency.stringFromNumber(0.00)!)"
        
        entries.titleLabel.text = "ENTRIES"
        entries.valueLabel.text = "\(0)"
        
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
            setNeedsLayout()
            countdown.alpha = 1
            fees.alpha = 1
            entries.alpha = 1
            totalSalaryRem.alpha = 0
            avgSalaryRem.alpha = 0
            points.alpha = 0
            winnings.alpha = 0
            pmr.alpha = 0
        } else if configuration == .Editing {
            setNeedsLayout()
            countdown.alpha = 1
            fees.alpha = 0
            entries.alpha = 0
            totalSalaryRem.alpha = 1
            avgSalaryRem.alpha = 1
            points.alpha = 0
            winnings.alpha = 0
            pmr.alpha = 0
        } else if configuration == .Live {
            setNeedsLayout()
            countdown.alpha = 0
            fees.alpha = 0
            entries.alpha = 0
            totalSalaryRem.alpha = 0
            avgSalaryRem.alpha = 0
            points.alpha = 1
            winnings.alpha = 1
            pmr.alpha = 1
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
        otherSetup()
    }
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(rightBorderView)
    }
    
    override func layoutSubviews() {
        let originX = bounds.width * 0.5 - 40
        let width = bounds.width - originX * 2
        
        titleLabel.frame = CGRectMake(originX, 13, width, 10)
        valueLabel.frame = CGRectMake(originX, 28, width, 20)
        rightBorderView.frame = CGRectMake(bounds.width - 1, 0, 1, bounds.height)
    }
    
    func otherSetup() {
        titleLabel.font = .openSans(weight: .Semibold, size: 8.0)
        titleLabel.textColor = UIColor(0x09c9faf)
        titleLabel.textAlignment = .Center

        valueLabel.font = .oswald(size: 18.0)
        valueLabel.textColor = UIColor(0x46495e)
        valueLabel.textAlignment = .Center
        
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
