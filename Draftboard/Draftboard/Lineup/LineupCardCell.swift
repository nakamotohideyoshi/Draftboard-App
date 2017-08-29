//
//  LineupCardCell.swift
//  Draftboard
//
//  Created by Anson Schall on 4/22/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupCardCellState {
    var flipped: Bool = false
    var detailScrollOffset: CGPoint?
    var entryScrollOffset: CGPoint?
}

class LineupCardCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LineupCardCell"
    
    let shadowView = LineupCardShadowView()
    let createView = LineupCardCreateView()
    
    let detailViewController = LineupDetailViewController()
    let entryViewController = LineupEntryViewController()
    
    var lineup: LineupWithStart? { didSet { didSetLineup() } }
    var state: LineupCardCellState { get { return getState() } set { setState(newValue) } }
    var flipped: Bool = false
    
    var createAction: (() -> Void) = {}
    var detailEditAction: (() -> Void) = {}
    var detailFlipAction: (() -> Void) = {}
    var entryFlipAction: (() -> Void) = {}
    var showPlayerAction: ((player: Player, sportName: String) -> Void) = {_ in }
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
    
    override func layoutSubviews() {
        contentView.frame = bounds
        shadowView.frame = CGRectMake(-40, bounds.height - 5, bounds.width + 80, 25)
        createView.frame = CGRectInset(bounds, 2, 2)
        detailViewController.view.frame = CGRectInset(bounds, 2, 2)
        entryViewController.view.frame = CGRectInset(bounds, 2, 2)
    }
    
    func setup() {
        addSubviews()
        otherSetup()
    }
    
    func addSubviews() {
        contentView.addSubview(shadowView)
        contentView.addSubview(createView)
        contentView.addSubview(entryViewController.view)
        contentView.addSubview(detailViewController.view)
    }
    
    func otherSetup() {
        shadowView.opaque = false
        shadowView.layer.rasterizationScale = UIScreen.mainScreen().scale
        shadowView.layer.shouldRasterize = true
        
        createView.addTarget(self, action: #selector(createViewTapped), forControlEvents: .TouchUpInside)
        detailViewController.lineupDetailView.editAction = { [weak self] in self?.detailEditAction() }
        detailViewController.lineupDetailView.flipAction = { [weak self] in self?.detailFlipAction() }
        detailViewController.showPlayerAction = { player, sportName in self.showPlayerAction(player: player, sportName: sportName) }
        entryViewController.flipAction = { [weak self] in self?.entryFlipAction() }
    }
    
    func getState() -> LineupCardCellState {
        let state = LineupCardCellState()
        state.flipped = flipped
        state.detailScrollOffset = detailViewController.tableView.contentOffset
        return state
    }
    
    func setState(state: LineupCardCellState) {
        flipped = state.flipped
        flipped ? showEntry(animated: false) : showDetail(animated: false)
        if let offset = state.detailScrollOffset {
            detailViewController.tableView.contentOffset = offset
        }
    }
    
    func showDetail(animated animated: Bool = true) {
        flipped = false
        let duration: NSTimeInterval = animated ? 0.5 : 0
        let options: UIViewAnimationOptions = animated ? .TransitionFlipFromLeft : .TransitionNone
        UIView.transitionFromView(entryViewController.view, toView: detailViewController.view, duration: duration, options: options, completion: nil)
    }
    
    func showEntry(animated animated: Bool = true) {
        flipped = true
        let duration: NSTimeInterval = animated ? 0.5 : 0
        let options: UIViewAnimationOptions = animated ? .TransitionFlipFromRight : .TransitionNone
        UIView.transitionFromView(detailViewController.view, toView: entryViewController.view, duration: duration, options: options, completion: nil)
    }
    
    func didSetLineup() {
        createView.hidden = (lineup != nil)
        detailViewController.emptyViewData()
        detailViewController.lineup = lineup
        detailViewController.view.hidden = (lineup == nil)
        detailViewController.viewDidLoad()
        entryViewController.lineup = lineup
        entryViewController.liveContests = []
        entryViewController.liveDraftGroup = nil
        entryViewController.lineupFinished = false
        entryViewController.cellStatuses = []
        entryViewController.viewDidLoad()
        entryViewController.view.hidden = (lineup == nil)
    }
    
    func createViewTapped() {
        createView.flashHighlightedState()
        createAction()
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
        let radius = bounds.width * 0.5
        let center = CGPointMake(radius, radius)
        let black = UIColor(white: 0, alpha: 0.3).CGColor
        let clear = UIColor(white: 0, alpha: 0).CGColor
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [black, clear], [0, 1.0])
        let context = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(context!, 1.0, bounds.height / bounds.width)
        CGContextDrawRadialGradient(context!, gradient!, center, 0, center, radius, [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
    }
}

class LineupCardCreateView: UIControl, CancelableTouchControl {
    
    let bgImageView = UIImageView()
    let logoImageView = UIImageView()
    let circleImageView = UIImageView()
    let circleView = UIView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let arrowImageView = UIImageView()
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
    
    override func layoutSubviews() {
        bgImageView.frame = bounds
        logoImageView.frame = CGRect(x: 0, y: 0, width: 33, height: 27)
        logoImageView.center = CGPoint(x: center.x, y: 90)
        circleImageView.frame = CGRect(x: 0, y: 0, width: bounds.size.width * 0.7, height: bounds.size.width * 0.7)
        circleImageView.center = CGPoint(x: center.x, y: center.y + 20)
        buttonLabel.frame = CGRectMake(20, bounds.height - 55, bounds.width - 40, 35)
    }
    
    func setup() {
        addSubviews()
        addConstraints()
        otherSetup()
    }
    
    func addSubviews() {
        addSubview(bgImageView)
        addSubview(logoImageView)
        addSubview(circleImageView)
        circleView.addSubview(titleLabel)
        circleView.addSubview(subTitleLabel)
        circleView.addSubview(arrowImageView)
        addSubview(circleView)
        //addSubview(buttonLabel)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            circleView.centerXRancor.constraintEqualToRancor(circleImageView.centerXRancor),
            circleView.centerYRancor.constraintEqualToRancor(circleImageView.centerYRancor),
            circleView.widthRancor.constraintEqualToRancor(circleImageView.widthRancor),
            titleLabel.topRancor.constraintEqualToRancor(circleView.topRancor),
            titleLabel.centerXRancor.constraintEqualToRancor(circleView.centerXRancor),
            subTitleLabel.topRancor.constraintEqualToRancor(titleLabel.bottomRancor),
            subTitleLabel.centerXRancor.constraintEqualToRancor(circleView.centerXRancor),
            arrowImageView.widthRancor.constraintEqualToConstant(36),
            arrowImageView.heightRancor.constraintEqualToConstant(5),
            arrowImageView.topRancor.constraintEqualToRancor(subTitleLabel.bottomRancor, constant: 5),
            arrowImageView.centerXRancor.constraintEqualToRancor(circleView.centerXRancor),
            arrowImageView.bottomRancor.constraintEqualToRancor(circleView.bottomRancor)
            
            ]
        circleView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        // Background Image
        bgImageView.image = UIImage(named: "create-card-bg")
        bgImageView.contentMode = .ScaleAspectFill
        // Logo Image
        logoImageView.image = UIImage(named: "logo-create-card")
        logoImageView.contentMode = .ScaleAspectFill
        // Circle BackgroundImage
        circleView.userInteractionEnabled = false
        
        circleImageView.image = UIImage(named: "create-card-circle")
        circleImageView.contentMode = .ScaleAspectFill
        circleImageView.userInteractionEnabled = false
        
        titleLabel.font = UIFont(name: "Oswald-Regular", size: 18)
        titleLabel.text = "IT'S ANYONE'S GAME"
        titleLabel.textAlignment = .Center
        titleLabel.textColor = .whiteColor()
        titleLabel.sizeToFit()
        titleLabel.userInteractionEnabled = false
        
        subTitleLabel.font = UIFont(name: "OpenSans-SemiBold", size: 10)
        subTitleLabel.text = "CREATE A LINEUP"
        subTitleLabel.textAlignment = .Center
        subTitleLabel.textColor = UIColor(0x8f9195)
        subTitleLabel.sizeToFit()
        subTitleLabel.userInteractionEnabled = false
        
        arrowImageView.image = UIImage(named: "icon-green-arrow")
        arrowImageView.contentMode = .ScaleAspectFill
        
        // Button
        buttonLabel.font = UIFont(name: "OpenSans-Bold", size: 10)
        buttonLabel.text = "START DRAFTING"
        buttonLabel.textAlignment = .Center
        buttonLabel.textColor = .whiteColor()
        buttonLabel.layer.allowsEdgeAntialiasing = true
        buttonLabel.layer.borderWidth = 0.5
        buttonLabel.layer.borderColor = UIColor.greenDraftboard().CGColor
        buttonLabel.userInteractionEnabled = false
        
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
