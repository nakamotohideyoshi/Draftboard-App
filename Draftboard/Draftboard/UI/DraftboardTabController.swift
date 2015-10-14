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
        
        cnc = lineupNC
        switchViewController(cnc)
    }
    
    func switchViewController(nc: DraftboardNavController, animated: Bool = true) {
        cnc?.view.removeFromSuperview()
        contentView.addSubview(nc.view)
        cnc = nc
        
        nc.view.translatesAutoresizingMaskIntoConstraints = false
        nc.view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
        nc.view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
        nc.view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
        nc.view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
    }
    
    func didTapTabButton(buttonType: TabBarButtonType) {
        if (buttonType == .Lineups) {
            self.switchViewController(lineupNC)
        }
        else if (buttonType == .Contests) {
           self.switchViewController(contestNC)
        }
        else if (buttonType == .Profile) {
            self.switchViewController(profileNC)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
