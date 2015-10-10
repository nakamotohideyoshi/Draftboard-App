//
//  RootViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

final class RootViewController: DraftboardViewController, DraftboardTabBarDelegate {
    
    static let sharedInstance = RootViewController(nibName: "RootViewController", bundle: nil)
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabBar: DraftboardTabBar!
    @IBOutlet weak var titlebar: DraftboardTitlebar!
    
    var vcs: [DraftboardViewController]!
    let list = LineupsListController(nibName: "LineupListController", bundle: nil)
    let contests = ContestsListController(nibName: "ContestsListController", bundle: nil)
    let account = AccountViewController(nibName: "AccountViewController", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vcs = [DraftboardViewController]()
        self.pushViewController(list, animated: false)
        
        tabBar.delegate = self
    }
    
    func pushViewController(nvc: DraftboardViewController, animated: Bool = true) {
        let cvc = vcs.last
        cvc?.view.removeFromSuperview()
        
        vcs.append(nvc)
        var parentView = contentView
        if (nvc is DraftboardModalViewController) {
            parentView = view
        }
        
        parentView.addSubview(nvc.view)
        nvc.view.translatesAutoresizingMaskIntoConstraints = false
        nvc.view.leftRancor.constraintEqualToRancor(parentView.leftRancor).active = true
        nvc.view.rightRancor.constraintEqualToRancor(parentView.rightRancor).active = true
        nvc.view.bottomRancor.constraintEqualToRancor(parentView.bottomRancor).active = true
        nvc.view.topRancor.constraintEqualToRancor(parentView.topRancor).active = true
        
        self.view.bringSubviewToFront(tabBar)
        
        titlebar.delegate = nvc
        titlebar.dataSource = nvc
        titlebar.pushElements(animated)
    }
    
    func popViewController(animated: Bool = true) {
        let cvc = vcs.popLast()
        cvc?.view.removeFromSuperview()
        
        let nvc = vcs.last
        if (nvc == nil) {
            return
        }

        var parentView = contentView
        if (nvc is DraftboardModalViewController) {
            parentView = view
        }
        
        parentView.addSubview(nvc!.view)
        nvc!.view.translatesAutoresizingMaskIntoConstraints = false
        nvc!.view.leftRancor.constraintEqualToRancor(parentView.leftRancor).active = true
        nvc!.view.rightRancor.constraintEqualToRancor(parentView.rightRancor).active = true
        nvc!.view.bottomRancor.constraintEqualToRancor(parentView.bottomRancor).active = true
        nvc!.view.topRancor.constraintEqualToRancor(parentView.topRancor).active = true
        
        titlebar.delegate = nvc
        titlebar.dataSource = nvc
        titlebar.popElements(animated)
    }
    
    func changeSections(vc: DraftboardViewController?) {
        for (_, vc) in vcs.enumerate() {
            vc.view.removeFromSuperview()
        }
        
        vcs = [DraftboardViewController]()
        
        if let newvc = vc {
            self.pushViewController(newvc)
            titlebar.dataSource = newvc
        }
    }
    
    func didTapTabButton(buttonType: TabBarButtonType) {
        if (buttonType == .Lineups) {
            self.changeSections(list)
        }
        else if (buttonType == .Contests) {
            self.changeSections(contests)
        }
        else if (buttonType == .Profile) {
            self.changeSections(account)
        }
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        vcs.last?.didTapTitlebarButton(buttonType)
    }
    
    override func titlebarTitle() -> String? {
        return vcs.last?.titlebarTitle()
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return vcs.last?.titlebarLeftButtonType()
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType? {
        return vcs.last?.titlebarRightButtonType()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent;
    }
}
