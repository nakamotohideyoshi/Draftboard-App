//
//  RootViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardNavController: UIViewController {
    
    var contentView: UIView!
    var titlebar: DraftboardTitlebar!
    var vcs = [DraftboardViewController]()
    var rvc: DraftboardViewController!
    
    convenience init(rootViewController: DraftboardViewController) {
        self.init()
        rvc = rootViewController
    }
    
    override func loadView() {
        super.loadView()
        
        titlebar = DraftboardTitlebar(frame: CGRectMake(0.0, 0.0, 50.0, 50.0))
        view.addSubview(titlebar)
        
        titlebar.translatesAutoresizingMaskIntoConstraints = false
        titlebar.topRancor.constraintEqualToRancor(view.topRancor).active = true
        titlebar.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        titlebar.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        titlebar.heightRancor.constraintEqualToConstant(56.0).active = true
        
        contentView = UIView(frame: CGRectMake(0.0, 0.0, 50.0, 50.0))
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        contentView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        contentView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        contentView.topRancor.constraintEqualToRancor(titlebar.bottomRancor).active = true

        if (vcs.count == 0) {
            self.pushViewController(rvc, animated: false)
        }
    }
    
    func pushViewController(nvc: DraftboardViewController, animated: Bool = true) {
        let cvc = vcs.last
        cvc?.view.removeFromSuperview()
        
        vcs.append(nvc)
        nvc.navController = self
        contentView.addSubview(nvc.view)
        
        nvc.view.translatesAutoresizingMaskIntoConstraints = false
        nvc.view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
        nvc.view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
        nvc.view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
        nvc.view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        
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
    
    func popToRootViewController(animated: Bool = true) {
        if (vcs.count < 2) {
            return
        }
        
        let cvc = vcs.last!
        let nvc = vcs.first!
        
        cvc.view.removeFromSuperview()
        
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
        
        titlebar.delegate = nvc
        titlebar.dataSource = nvc
        titlebar.popElements(animated)
        
        vcs = [nvc]
    }
}
