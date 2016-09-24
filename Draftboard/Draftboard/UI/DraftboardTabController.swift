//
//  RootViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardTabController: UIViewController, DraftboardTabBarDelegate {
    
    var contentView: UIView!
    var tabBar: DraftboardTabBar!
    
    var lineupNC: DraftboardNavController!
    var contestNC: DraftboardNavController!
    var profileNC: DraftboardNavController!
    
    var cnc: DraftboardNavController!
    var completionHandler:((Bool)->Void)?
    var spring: Spring?
    
    var contentViewOverlapsTabBar: Bool = false { didSet { didSetContentViewOverlapsTabBar() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lineupRvc = LineupListViewController()
        let contestRvc = ContestListViewController()
        let profileRvc = AccountViewController()

        lineupNC = DraftboardNavController(rootViewController: lineupRvc)
        contestNC = DraftboardNavController(rootViewController: contestRvc)
        profileNC = DraftboardNavController(rootViewController: profileRvc)

        tabBar = DraftboardTabBar()
        tabBar.delegate = self
        view.addSubview(tabBar)

        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        tabBar.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        tabBar.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        tabBar.heightRancor.constraintEqualToConstant(50.0).active = true

        contentView = UIView()
        view.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topRancor.constraintEqualToRancor(view.topRancor).active = true
        contentView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        contentView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        contentView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true

        switchNavController(lineupNC, animated: false)
//        tabBar.selectButtonAtIndex(1, animated: false)
    }
    
    func didSetContentViewOverlapsTabBar() {
        if contentViewOverlapsTabBar {
            view.insertSubview(contentView, aboveSubview: tabBar)
        } else {
            view.insertSubview(contentView, belowSubview: tabBar)
        }
    }
    
    func switchNavController(nc: DraftboardNavController, animated: Bool = true) {
        spring?.cancel()
        spring = nil
        
        contentView.addSubview(nc.view)
        nc.view.translatesAutoresizingMaskIntoConstraints = false
        nc.view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
        nc.view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
        nc.view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
        nc.view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        
        completionHandler = { (complete: Bool) in
            self.cnc = nc
        }

        if (animated) {
            nc.view.alpha = 0.0;
            
            // Scale up new controller slightly
            var inT = CATransform3DIdentity
            inT.m34 = -1.0 / 500.0
            inT = CATransform3DScale(inT, 1.1, 1.1, 1.0)
            nc.view.layer.transform = inT
            
            // Create spring
            let startScale: CGFloat = 1.1
            let scaleDelta: CGFloat = 1.0 - startScale
            spring = Spring(stiffness: 4.0, damping: 0.4, velocity: 8.0)
            spring!.updateBlock = { (value) -> Void in
                
                // Scale new controller down to 1
                let scale = startScale + scaleDelta * value
                nc.view.layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
                nc.view.alpha = value
                
                // have the old view fade out faster
                self.cnc?.view.alpha = abs(value - 1) - 0.4
            }
            
            // Remove old stuff on completion
            spring!.completeBlock = { (completed) -> Void in
                nc.view.layer.transform = CATransform3DIdentity
                self.cnc?.view.removeFromSuperview()
                self.completionHandler?(completed)
            }
            
            // Start animation
            spring!.start()
        }
        else {
            completionHandler!(true)
            completionHandler = nil
        }
    }
    
    func didTapTabButton(buttonType: TabBarButtonType) {
        if (buttonType == .Lineups) {
            self.switchNavController(lineupNC)
        }
        else if (buttonType == .Contests) {
           self.switchNavController(contestNC)
        }
        else if (buttonType == .Profile) {
            self.switchNavController(profileNC)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}