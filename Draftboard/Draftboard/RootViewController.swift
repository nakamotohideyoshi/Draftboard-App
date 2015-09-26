//
//  RootViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

final class RootViewController: DraftboardViewController, DraftboardTabBarDelegate, DraftboardTitlebarDelegate {
    
    static let sharedInstance = RootViewController(nibName: "RootViewController", bundle: nil)
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabBar: DraftboardTabBar!
    @IBOutlet weak var titlebar: DraftboardTitlebar!
    
    var vcs: [DraftboardViewController]!
    let list = LineupsListController(nibName: "LineupListController", bundle: nil)
    let contests = ContestsListController(nibName: "ContestsListController", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        titlebar.delegate = self
        vcs = [DraftboardViewController]()
        self.pushViewController(list)
    }
    
    func pushViewController(vc: DraftboardViewController) {
        let cvc = vcs.last
        cvc?.view.removeFromSuperview()
        
        vcs.append(vc)
        var parentView = contentView
        if (vc is DraftboardModalViewController) {
            parentView = view
        }
        
        parentView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.leftRancor.constraintEqualToRancor(parentView.leftRancor).active = true
        vc.view.rightRancor.constraintEqualToRancor(parentView.rightRancor).active = true
        vc.view.bottomRancor.constraintEqualToRancor(parentView.bottomRancor).active = true
        vc.view.topRancor.constraintEqualToRancor(parentView.topRancor).active = true
    }
    
    func popViewController() {
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
    }
    
    func changeSections(vc: DraftboardViewController?) {
        for (_, vc) in vcs.enumerate() {
            vc.view.removeFromSuperview()
        }
        
        vcs = [DraftboardViewController]()
        
        if (vc != nil) {
            self.pushViewController(vc!)
        }
    }
    
    func didTapTabButtonAtIndex(index: Int) {
        if (index == 0) {
            self.changeSections(list)
        }
        else if (index == 1) {
            self.changeSections(contests)
        }
        else {
            self.changeSections(nil)
        }
    }
    
    override func didTapTitlebarButton(index: Int) {
        vcs.last?.didTapTitlebarButton(index)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent;
    }
}
