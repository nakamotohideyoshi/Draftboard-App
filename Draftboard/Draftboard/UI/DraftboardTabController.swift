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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lineupRvc = LineupsListController(nibName: "LineupListController", bundle: nil)
        let contestRvc = ContestsListController(nibName: "ContestsListController", bundle: nil)
        let profileRvc = AccountViewController(nibName: "AccountViewController", bundle: nil)
        
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
        contentView.bottomRancor.constraintEqualToRancor(tabBar.topRancor).active = true
        contentView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        contentView.clipsToBounds = true
        
        switchNavController(lineupNC, animated: false)
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
            self.cnc?.view.removeFromSuperview()
            
            var inT = CATransform3DIdentity
            inT.m34 = -1.0 / 500.0
            inT = CATransform3DScale(inT, 1.2, 1.2, 1.0)
            nc.view.layer.transform = inT
            
            let startScale: CGFloat = 1.2
            let scaleDelta: CGFloat = 1.0 - startScale
            spring = Spring(stiffness: 4.0, mass: 2.0, damping: 0.8, velocity: 10.0)
            spring!.updateBlock = { (value) -> Void in
                let scale = startScale + scaleDelta * value
                nc.view.layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
            }
            spring!.completeBlock = { (completed) -> Void in
                nc.view.layer.transform = CATransform3DIdentity
                self.completionHandler?(completed)
            }
            
            self.view.layoutIfNeeded()
            spring!.start()
            
        } else {
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