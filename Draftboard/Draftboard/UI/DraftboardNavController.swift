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
        contentView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        contentView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        contentView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        contentView.topRancor.constraintEqualToRancor(titlebar.bottomRancor).active = true

        if (vcs.count == 0) {
            self.pushViewController(rvc, animated: false)
        }
    }
    
    func pushViewController(nvc: DraftboardViewController, animated: Bool = true) {
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
        
        titlebar.delegate = nvc
        titlebar.dataSource = nvc
        titlebar.pushElements(animated: animated)
        
        completionHandler = { (complete: Bool) in
            cvc?.view.removeFromSuperview()
        }
        
        self.view.layoutIfNeeded()
    
        if (animated) {
            inSpring = animateViewControllerIn(nvc)
            inSpring!.start()
            
            if let vc = cvc {
                outSpring = animateViewControllerOut(vc)
                outSpring?.completeBlock = completionHandler
                outSpring!.start()
            }
        } else {
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
        if (nvc == nil) {
            return
        }
        
        contentView.addSubview(nvc!.view)
        nvc!.view.translatesAutoresizingMaskIntoConstraints = false
        nvc!.view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
        nvc!.view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
        nvc!.view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
        nvc!.view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        
        titlebar.delegate = nvc
        titlebar.dataSource = nvc
        titlebar.popElements(animated: animated)
        
        completionHandler = { (complete: Bool) in
            cvc?.view.removeFromSuperview()
        }
        
        self.view.layoutIfNeeded()
        
        if (animated) {
            inSpring = animateViewControllerIn(nvc!, dir: -1.0)
            inSpring!.start()
            
            if let vc = cvc {
                outSpring = animateViewControllerOut(vc, dir: 1.0)
                outSpring?.completeBlock = completionHandler
                outSpring!.start()
            }
        } else {
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
        
        titlebar.delegate = nvc
        titlebar.dataSource = nvc
        titlebar.popElements(animated: animated)
        
        vcs = [nvc]
    }

    func pushViewController(nvc: DraftboardViewController, fromCardView cardView: LineupCardView, animated: Bool = true) {
        let cvc = vcs.last!
//        cvc?.view.removeFromSuperview()
        
        vcs.append(nvc)
        nvc.navController = self
        contentView.addSubview(nvc.view)
        nvc.view.layer.opacity = 0
        
        nvc.view.translatesAutoresizingMaskIntoConstraints = false
        nvc.view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
        nvc.view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
        nvc.view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
        nvc.view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        
        titlebar.delegate = nvc
        titlebar.dataSource = nvc
        titlebar.pushElements(directionless: true, animated: animated)
        
        //////
        
        let sx = cvc.view.bounds.size.width / cardView.bounds.size.width - 1
        let sy = cvc.view.bounds.size.height / cardView.bounds.size.height - 1
        
        let sx2 = 1 - cardView.bounds.size.width / cvc.view.bounds.size.width
        let sy2 = 1 - cardView.bounds.size.height / cvc.view.bounds.size.height
        
        let spring = Spring(stiffness: 4.0, damping: 0.65, velocity: 0.0)
        spring.updateBlock = { (value) -> Void in
            cardView.layer.transform = CATransform3DMakeScale(1.0 + (sx * value), 1.0 + (sy * value), 1.0)
            cardView.layer.transform.m34 = -1/500
            cardView.layer.transform = CATransform3DRotate(cardView.layer.transform, CGFloat(M_PI) * value, 0, 1, 0)
            if value >= 0.5 {
                cardView.layer.opacity = 0
            }
            nvc.view.layer.transform = CATransform3DMakeScale(1.0 - sx2 + (sx2 * value), 1.0 - sy2 + (sy2 * value), 1.0)
            nvc.view.layer.transform.m34 = -1/500
            nvc.view.layer.transform = CATransform3DRotate(nvc.view.layer.transform, -CGFloat(M_PI) + CGFloat(M_PI) * value, 0, 1, 0)
            if value >= 0.5 {
                nvc.view.layer.opacity = 1
            }

        }
        spring.completeBlock = { (completed) -> Void in
//            cvc.view.removeFromSuperview()
            cvc.view.hidden = true
            nvc.view.layer.transform = CATransform3DIdentity
        }
        UIView.animateWithDuration(0.2, animations: {
            cvc.view.layer.opacity = 0
//            nvc.view.alpha = 1
        })
        
        spring.start()
    }
    
    func popViewControllerToCardView(cardView: LineupCardView, animated: Bool = true) {
        let cvc = vcs.popLast()!
//        cvc?.view.removeFromSuperview()
        
        if vcs.last == nil {
            return
        }
        
        let nvc = vcs.last!
        nvc.view.layer.opacity = 0
        cardView.layer.opacity = 0
        nvc.view.hidden = false
        
        contentView.addSubview(nvc.view)
        nvc.view.translatesAutoresizingMaskIntoConstraints = false
        nvc.view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
        nvc.view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
        nvc.view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
        nvc.view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        
        titlebar.delegate = nvc
        titlebar.dataSource = nvc
        titlebar.popElements(directionless: true, animated: animated)
        
        //////
        
        let sx = cvc.view.bounds.size.width / cardView.bounds.size.width - 1
        let sy = cvc.view.bounds.size.height / cardView.bounds.size.height - 1
        
        let sx2 = 1 - cardView.bounds.size.width / cvc.view.bounds.size.width
        let sy2 = 1 - cardView.bounds.size.height / cvc.view.bounds.size.height
        
        let spring = Spring(stiffness: 10.0, damping: 0.0, velocity: 0.0)
        spring.updateBlock = { (value) -> Void in
            cardView.layer.transform = CATransform3DMakeScale(1.0 + sx - (sx * value), 1.0 + sy - (sy * value), 1.0)
            cardView.layer.transform.m34 = -1/500
            cardView.layer.transform = CATransform3DRotate(cardView.layer.transform, -CGFloat(M_PI) + CGFloat(M_PI) * -value, 0, 1, 0)
            if value >= 0.5 {
                cardView.layer.opacity = 1
            }
            cvc.view.layer.transform = CATransform3DMakeScale(1.0 - (sx2 * value), 1.0 - (sy2 * value), 1.0)
            cvc.view.layer.transform.m34 = -1/500
            cvc.view.layer.transform = CATransform3DRotate(cvc.view.layer.transform, CGFloat(M_PI) * -value, 0, 1, 0)
            if value >= 0.5 {
                cvc.view.layer.opacity = 0
            }

        }
        spring.completeBlock = { (completed) -> Void in
            cvc.view.removeFromSuperview()
            cardView.layer.transform = CATransform3DIdentity
        }
        UIView.animateWithDuration(0.2, animations: {
//            cvc.view.alpha = 0
            nvc.view.layer.opacity = 1
        })
        
        spring.start()
    }
    
    func animateViewControllerIn(vc: DraftboardViewController, dir: CGFloat = 1.0) -> Spring {
        let sw = UIScreen.mainScreen().bounds.width
        
        let endPos = vc.view.layer.position
        let startPos = CGPointMake(endPos.x + (sw * dir), endPos.y)
        let deltaPos = CGPointMake(endPos.x - startPos.x, endPos.y - startPos.y)
        
        vc.view.hidden = true // TODO: fix this
        
        let spring = Spring(stiffness: 3.5, damping: 0.65, velocity: 0.0)
        spring.updateBlock = { (value) -> Void in
            vc.view.hidden = false
            vc.view.layer.position = CGPointMake(
                startPos.x + (deltaPos.x * value),
                startPos.y + (deltaPos.y * value)
            )
        }
        
        return spring
    }
    
    func animateViewControllerOut(vc: DraftboardViewController, dir: CGFloat = -1.0) -> Spring {
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
    
    func updateTitlebar(animated animated: Bool = true) {
        titlebar.pushElements(directionless: true, animated: animated)
    }
}
