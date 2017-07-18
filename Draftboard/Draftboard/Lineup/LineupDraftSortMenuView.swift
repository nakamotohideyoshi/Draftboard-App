//
//  LineupDraftSortMenuView.swift
//  Draftboard
//
//  Created by devguru on 7/15/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class LineupDraftSortMenuView: UIView {

    let menuView = UIView()
    let bgImageView = UIImageView()
    let tableView = LineupDraftSortMenuTableView()
    
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
        addSubview(menuView)
        menuView.addSubview(bgImageView)
        menuView.addSubview(tableView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            menuView.widthRancor.constraintEqualToRancor(widthRancor, multiplier: 0.656),
            menuView.rightRancor.constraintEqualToRancor(rightRancor, constant: 45),
            menuView.topRancor.constraintEqualToRancor(topRancor, constant: 60.0),
            bgImageView.topRancor.constraintEqualToRancor(menuView.topRancor),
            bgImageView.leftRancor.constraintEqualToRancor(menuView.leftRancor),
            bgImageView.rightRancor.constraintEqualToRancor(menuView.rightRancor),
            bgImageView.bottomRancor.constraintEqualToRancor(menuView.bottomRancor),
            tableView.topRancor.constraintEqualToRancor(menuView.topRancor, constant: 56),
            tableView.leftRancor.constraintEqualToRancor(menuView.leftRancor, constant: 55),
            tableView.rightRancor.constraintEqualToRancor(menuView.rightRancor, constant: -55),
            tableView.bottomRancor.constraintEqualToRancor(menuView.bottomRancor, constant: -56),
        ]
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func otherSetup() {
        alpha = 0
        
        bgImageView.image = UIImage(named: "sort-dropdown-bg")?.resizableImageWithCapInsets(UIEdgeInsetsMake(90, 90, 90, 90), resizingMode: .Stretch)
        bgImageView.contentMode = .ScaleToFill
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: .didTapView)
        tapGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    func toggleView() {
        UIView.animateWithDuration(0.3, animations: {
            self.alpha = 1 - self.alpha
            }, completion: { (value: Bool) in
                
        })
    }
    
    func didTapView(gestureRecognizer: UITapGestureRecognizer) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue(),{
                self.toggleView()
            })
        }
    }
}

private extension Selector {
    static let didTapView = #selector(LineupDraftSortMenuView.didTapView(_:))
}
