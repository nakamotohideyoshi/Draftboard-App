//
//  RootViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    static let sharedInstance = RootViewController()
    var tabController = DraftboardTabController()
    var topConstraint: NSLayoutConstraint!
    
    var floorImageView: UIImageView!
    
    override func viewDidLoad() {
        floorImageView = UIImageView()
        view.addSubview(floorImageView)
        
        floorImageView.translatesAutoresizingMaskIntoConstraints = false
        floorImageView.topRancor.constraintEqualToRancor(view.topRancor).active = true
        floorImageView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        floorImageView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        floorImageView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        
        let v = tabController.view
        view.addSubview(v)
        
        v.translatesAutoresizingMaskIntoConstraints = false
        v.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        v.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        v.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        
        topConstraint = v.topRancor.constraintEqualToRancor(view.topRancor, constant: 20.0)
        topConstraint.active = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return tabController.preferredStatusBarStyle()
    }
}
