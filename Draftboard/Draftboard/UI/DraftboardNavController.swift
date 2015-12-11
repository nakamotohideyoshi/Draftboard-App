//
//  RootViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

struct FooterType : OptionSetType {
    let rawValue: Int
    static let Stats = FooterType(rawValue: 0)
    static let None = FooterType(rawValue: 1 << 0)
}

class DraftboardNavController: UIViewController {
    
    var contentView: UIView!
    var titlebar: DraftboardTitlebar!
    var vcs = [DraftboardViewController]()
    var rvc: DraftboardViewController!
    
    var footerView: DraftboardFooterView?
    var footerType: FooterType = .None
    
    var footerInSpring: Spring?
    var footerOutSpring: Spring?
    
    var inSpring: Spring?
    var outSpring: Spring?
    
    var completionHandler:((Bool)->Void)?
    
    convenience init(rootViewController: DraftboardViewController) {
        self.init()
        rvc = rootViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlebar = DraftboardTitlebar()
        view.addSubview(titlebar)
        
        titlebar.translatesAutoresizingMaskIntoConstraints = false
        titlebar.topRancor.constraintEqualToRancor(view.topRancor).active = true
        titlebar.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        titlebar.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        titlebar.heightRancor.constraintEqualToConstant(56.0).active = true
        
        contentView = UIView()
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topRancor.constraintEqualToRancor(titlebar.bottomRancor).active = true
        contentView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        contentView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        contentView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        
        if (vcs.count == 0) {
            self.pushViewController(rvc, animated: false)
        }
    }
    
    func pushViewController(nvc: DraftboardViewController, animated: Bool = true) {
        
        // Cancel in animation
        inSpring?.cancel()
        inSpring = nil
        
        // Cancel out animation
        outSpring?.cancel()
        outSpring = nil
        
        // Get current view controller
        let cvc = vcs.last
        
        // Add new view controller
        vcs.append(nvc)
        nvc.navController = self
        
        // Constrain new controller
        contentView.addSubview(nvc.view)
        nvc.view.translatesAutoresizingMaskIntoConstraints = false
        nvc.view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        nvc.view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
        nvc.view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
        nvc.view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
        
        // Got a different footer here
        updateFooterForViewController(nvc)
        
        // Update titlebar
        titlebar.delegate = nvc
        titlebar.dataSource = nvc
        titlebar.pushElements(animated: animated)
        
        // Animation complete
        completionHandler = { (complete: Bool) in
            cvc?.view.removeFromSuperview()
        }
        
        if (animated) {
            view.layoutIfNeeded()
            
            inSpring = animateViewControllerIn(nvc)
            inSpring!.start()
            
            if let vc = cvc {
                outSpring = animateViewControllerOut(vc)
                outSpring?.completeBlock = completionHandler
                outSpring!.start()
            }
        }
        else {
            completionHandler!(true)
            completionHandler = nil
        }
    }
    
    func popViewController(animated: Bool = true) {
        inSpring?.cancel()
        inSpring = nil
        
        outSpring?.cancel()
        outSpring = nil
        
        if (vcs.count == 1) {
            return
        }
        
        // Get view controllers
        let cvc = vcs.popLast()
        let nvc = vcs.last!
        
        // Constrain new view controller
        contentView.addSubview(nvc.view)
        nvc.view.translatesAutoresizingMaskIntoConstraints = false
        nvc.view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        nvc.view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
        nvc.view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
        nvc.view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
        
        // Update footer
        updateFooterForViewController(nvc)
        
        // Update titlebar
        titlebar.delegate = nvc
        titlebar.dataSource = nvc
        titlebar.popElements(animated: animated)
        
        // Animation complete
        completionHandler = { (complete: Bool) in
            cvc?.view.removeFromSuperview()
        }
        
        if (animated) {
            view.layoutIfNeeded()
            
            inSpring = animateViewControllerIn(nvc, dir: -1.0)
            inSpring!.start()
            
            if let vc = cvc {
                outSpring = animateViewControllerOut(vc, dir: 1.0)
                outSpring?.completeBlock = completionHandler
                outSpring!.start()
            }
        }
        else {
            completionHandler!(true)
            completionHandler = nil
        }
    }
    
    func popToRootViewController(animated: Bool = true) {
        if vcs.count < 2 {
            return
        }
        
        // Get controllers
        let cvc = vcs.last!
        let nvc = vcs.first!
        
        // Remove current controller
        cvc.view.removeFromSuperview()
        contentView.addSubview(nvc.view)
        
        // Constrain root controller
        nvc.view.translatesAutoresizingMaskIntoConstraints = false
        nvc.view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
        nvc.view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
        nvc.view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
        nvc.view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        
        // Update footer
        updateFooterForViewController(nvc)
        
        // Update titlebar
        titlebar.delegate = nvc
        titlebar.dataSource = nvc
        titlebar.popElements(animated: animated)
        
        vcs = [nvc]
    }
    
    func animateViewControllerIn(vc: DraftboardViewController, dir: CGFloat = 1.0) -> Spring {
        let sw = App.screenBounds.width
        
        let endPos = vc.view.layer.position
        let startPos = CGPointMake(endPos.x + (sw * dir), endPos.y)
        let deltaPos = CGPointMake(endPos.x - startPos.x, endPos.y - startPos.y)
        self.view.bringSubviewToFront(vc.view)
        
        vc.view.hidden = true // TODO: this shouldn't be necessary, needs a fix
        let spring = Spring(stiffness: 3.4, damping: 0.62, velocity: 0.0)
        spring.updateBlock = { (value) -> Void in
            vc.view.hidden = false // TODO: this shouldn't be necessary, needs a fix
            
            vc.view.layer.position = CGPointMake(
                startPos.x + (deltaPos.x * value),
                startPos.y + (deltaPos.y * value)
            )
            
            vc.view.alpha = min(value + 0.6, 1)
        }
        
        return spring
    }
    
    func animateViewControllerOut(vc: DraftboardViewController, dir: CGFloat = -1.0) -> Spring {
        let sw = App.screenBounds.width
        
        let startPos = vc.view.layer.position
        let endPos = CGPointMake(startPos.x + (sw * dir), startPos.y)
        let deltaPos = CGPointMake(endPos.x - startPos.x, endPos.y - startPos.y)
        
        let spring = Spring(stiffness: 3.4, damping: 0.62, velocity: 0.0)
        spring.updateBlock = { (value) -> Void in
            vc.view.layer.position = CGPointMake(
                startPos.x + (deltaPos.x * value),
                startPos.y + (deltaPos.y * value)
            )
            vc.view.alpha = max(abs(value - 1), 0.6)
        }
        
        return spring
    }
}

// MARK: - Titlebar and footer view

extension DraftboardNavController {
    func updateTitlebar(animated animated: Bool = true) {
        titlebar.pushElements(directionless: true, animated: animated)
    }
    
    func heightForFooterType(footerType: FooterType) -> CGFloat {
        switch (footerType) {
        case FooterType.Stats:
            return 60.0
        default:
            return 0.0
        }
    }
    
    func viewForFooterType(vc: DraftboardViewController, footerType: FooterType) -> DraftboardFooterView? {
        switch (footerType) {
        case FooterType.Stats:
            return LineupStatFooterView(dataSource: vc as? StatFooterDataSource)
        default:
            return nil
        }
    }
    
    func updateFooterForViewController(nvc: DraftboardViewController, animated: Bool = true) {
        
        // Same footer type
        let newFooterType = nvc.footerType()
        if footerType == newFooterType {
            
            // Update data source
            if let fv = footerView as? LineupStatFooterView {
                fv.dataSource = nvc as? StatFooterDataSource
                fv.reloadData()
            }
            
            // Bail
            return
        }
        
        // Kill in animation
        footerInSpring?.stop()
        footerInSpring = nil
        
        // Kill out animation
        footerOutSpring?.stop()
        footerOutSpring = nil
        
        // Remove old footer view
        if let fv = footerView {
            let completeBlock = { (complete: Bool) in
                fv.removeFromSuperview()
            }
            
            if animated {
                footerOutSpring = animateFooterOut(fv)
                footerOutSpring?.completeBlock = completeBlock
                footerOutSpring?.start()
            }
            else {
                completeBlock(true)
            }
        }

        // Create new footer view
        footerType = nvc.footerType()
        if let fv = self.viewForFooterType(nvc, footerType: footerType) {
            view.addSubview(fv)
            
            // Constrain new footer view
            fv.translatesAutoresizingMaskIntoConstraints = false
            fv.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
            fv.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
            fv.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
            fv.heightRancor.constraintEqualToConstant(heightForFooterType(footerType)).active = true
            
            // Keep a reference
            footerView = fv
            
            // Animate in
            self.view.layoutIfNeeded()
            
            // Animate in
            if (animated) {
                footerInSpring = self.animateFooterIn(fv)
                footerInSpring!.start(0.25)
            }
        }
    }
    
    func animateFooterIn(fv: UIView) -> Spring {
        let endPos = fv.layer.position
        let startPos = CGPointMake(endPos.x, endPos.y + fv.bounds.size.height)
        let deltaPos = CGPointMake(endPos.x - startPos.x, endPos.y - startPos.y)
        
        fv.layer.position = startPos
        let spring = Spring(stiffness: 3.4, damping: 0.62, velocity: 0.0)
        spring.updateBlock = { (value) -> Void in
            fv.layer.position = CGPointMake(
                startPos.x + (deltaPos.x * value),
                startPos.y + (deltaPos.y * value)
            )
        }
        
        return spring
    }
    
    func animateFooterOut(fv: UIView) -> Spring {
        let startPos = fv.layer.position
        let endPos = CGPointMake(startPos.x, startPos.y + fv.bounds.size.height)
        let deltaPos = CGPointMake(endPos.x - startPos.x, endPos.y - startPos.y)
        
        fv.layer.position = startPos
        let spring = Spring(stiffness: 3.4, damping: 0.62, velocity: 0.0)
        spring.updateBlock = { (value) -> Void in
            fv.layer.position = CGPointMake(
                startPos.x + (deltaPos.x * value),
                startPos.y + (deltaPos.y * value)
            )
        }
        
        return spring
    }
}