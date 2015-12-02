//
//  RootViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardModalNavController: UIViewController {
    
    var contentView: UIView!
    var titlebar: DraftboardTitlebar!
    var vcs = [DraftboardModalViewController]()
    
    var inSpring: Spring?
    var outSpring: Spring?
    var blurView: UIVisualEffectView!
    
    var completionHandler:((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBlurEffect()
        contentView = UIView()
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topRancor.constraintEqualToRancor(view.topRancor).active = true
        contentView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        contentView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        contentView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
    }
    
    func addBlurEffect() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        self.view.addSubview(blurView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false;
        blurView.topRancor.constraintEqualToRancor(view.topRancor).active = true
        blurView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        blurView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        blurView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        blurView.tintColor = .clearColor()
    }
    
    func pushViewController(nvc: DraftboardModalViewController, animated: Bool = true) {
        inSpring?.cancel()
        inSpring = nil
        
        outSpring?.cancel()
        outSpring = nil
        
        let cvc = vcs.last
        
        vcs.append(nvc)
        nvc.navController = self
        contentView.addSubview(nvc.view)
        
        nvc.view.translatesAutoresizingMaskIntoConstraints = false
        nvc.view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
        nvc.view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
        nvc.view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
        nvc.view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        
        completionHandler = { (complete: Bool) in
            cvc?.view.removeFromSuperview()
        }
        
        if (animated) {
            self.view.layoutIfNeeded()
            
            if (vcs.count == 1) {
                inSpring = animateViewControllerInBounce(nvc)
            }
            else {
                inSpring = animateViewControllerInLinear(nvc)
            }
            
            inSpring!.start()
            
            if let vc = cvc {
                outSpring = animateViewControllerOutLinear(vc)
                outSpring?.completeBlock = completionHandler
                outSpring!.start()
            }
        } else {
            blurView.alpha = 1.0
            completionHandler!(true)
            completionHandler = nil
        }
    }
    
    func popViewController(animated: Bool = true) {
        inSpring?.cancel()
        inSpring = nil
        
        outSpring?.cancel()
        outSpring = nil
        
        let cvc = vcs.popLast()
        let nvc = vcs.last
        
        if (nvc != nil) {
            contentView.addSubview(nvc!.view)
            nvc!.view.translatesAutoresizingMaskIntoConstraints = false
            nvc!.view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
            nvc!.view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
            nvc!.view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
            nvc!.view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        }
        
        completionHandler = { (complete: Bool) in
            cvc?.view.removeFromSuperview()
        }
        
        if (animated) {
            self.view.layoutIfNeeded()
            
            if (nvc != nil) {
                inSpring = animateViewControllerInLinear(nvc!, dir: -1.0)
                inSpring!.start()
            }
            
            if let vc = cvc {
                if (nvc == nil) {
                    outSpring = animateViewControllerOutBounce(vc)
                } else {
                    outSpring = animateViewControllerOutLinear(vc, dir: 1.0)
                }
                
                outSpring?.completeBlock = completionHandler
                outSpring!.start()
            }
        } else {
            completionHandler!(true)
            completionHandler = nil
        }
    }
    
    func popOutViewController(animated: Bool = true) {
        
        // Cancel in animation
        inSpring?.cancel()
        inSpring = nil
        
        // Cancel out animation
        outSpring?.cancel()
        outSpring = nil
        
        // Pop last controller
        let cvc = vcs.popLast()
        if (cvc == nil) {
            return
        }
        
        // Remove the other view controllers
        for (_, vc) in vcs.enumerate() {
            vc.view.removeFromSuperview()
        }
        vcs = [DraftboardModalViewController]()
        
        // Fire on complete
        completionHandler = { (complete: Bool) in
            cvc?.view.removeFromSuperview()
        }
        
        // Animate out
        if (animated) {
            self.view.layoutIfNeeded()
            outSpring = animateViewControllerOutBounce(cvc!)
            outSpring?.completeBlock = completionHandler
            outSpring!.start()
        } else { // Or do it instantly
            completionHandler!(true)
            completionHandler = nil
        }
    }
    
    func popToRootViewController(animated: Bool = true) {
        if (vcs.count < 2) {
            return
        }
        
        let cvc = vcs.last!
        let nvc = vcs.first!
        
        cvc.view.removeFromSuperview()
        
        contentView.addSubview(nvc.view)
        nvc.view.translatesAutoresizingMaskIntoConstraints = false
        nvc.view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
        nvc.view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
        nvc.view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
        nvc.view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        
        vcs = [nvc]
    }
    
    func animateViewControllerInBounce(vc: DraftboardModalViewController) -> Spring {
        let endScale: CGFloat = 1.0
        let startScale: CGFloat = 1.1
        let deltaScale: CGFloat = endScale - startScale
        
        let spring = Spring(stiffness: 4.0, damping: 0.4, velocity: 10.0)
        spring.updateBlock = { (value) -> Void in
            let scale = startScale + (deltaScale * value)
            vc.view.layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
        }
        
        vc.view.layer.transform = CATransform3DMakeScale(startScale, startScale, 1.0)
        return spring
    }
    
    func animateViewControllerOutBounce(vc: DraftboardModalViewController) -> Spring {
        let endScale: CGFloat = 1.1
        let startScale: CGFloat = 1.0
        let deltaScale: CGFloat = endScale - startScale
        
        let spring = Spring(stiffness: 4.0, damping: 0.4, velocity: 0)
        spring.updateBlock = { (value) -> Void in
            let scale = startScale + (deltaScale * value)
            vc.view.layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
        }
        
        vc.view.layer.transform = CATransform3DMakeScale(startScale, startScale, 1.0)
        return spring
    }
    
    func animateViewControllerInLinear(vc: DraftboardModalViewController, dir: CGFloat = 1.0) -> Spring {
        let sw = UIScreen.mainScreen().bounds.width
        
        let endPos = vc.view.layer.position
        let startPos = CGPointMake(endPos.x + (sw * dir), endPos.y)
        let deltaPos = CGPointMake(endPos.x - startPos.x, endPos.y - startPos.y)
        
        vc.view.hidden = true // TODO: fix this
        let spring = Spring(stiffness: 3.5, damping: 0.65, velocity: 0.0)
        spring.updateBlock = { (value) -> Void in
            vc.view.hidden = false // TODO fix this
            vc.view.layer.position = CGPointMake(
                startPos.x + (deltaPos.x * value),
                startPos.y + (deltaPos.y * value)
            )
        }
        
        return spring
    }
    
    func animateViewControllerOutLinear(vc: DraftboardModalViewController, dir: CGFloat = -1.0) -> Spring {
        let sw = UIScreen.mainScreen().bounds.width
        
        let startPos = vc.view.layer.position
        let endPos = CGPointMake(startPos.x + (sw * dir), startPos.y)
        let deltaPos = CGPointMake(endPos.x - startPos.x, endPos.y - startPos.y)
        
        let spring = Spring(stiffness: 3.5, damping: 0.65, velocity: 0.0)
        spring.updateBlock = { (value) -> Void in
            vc.view.layer.position = CGPointMake(
                startPos.x + (deltaPos.x * value),
                startPos.y + (deltaPos.y * value)
            )
        }
        
        return spring
    }
}
