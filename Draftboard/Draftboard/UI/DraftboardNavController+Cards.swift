//
//  RootViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

extension DraftboardNavController {
    func pushViewController(nvc: DraftboardViewController, fromCardView cardView: LineupCardView, animated: Bool = true) {
        let cvc = vcs.last!
        
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
        
        // Begin animation code
        
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
        
        spring.completeBlock = { completed in
            cvc.view.hidden = true
            nvc.view.layer.transform = CATransform3DIdentity
        }
        
        UIView.animateWithDuration(0.2, animations: {
            cvc.view.layer.opacity = 0
        })
        
        spring.start()
    }
    
    func popViewControllerToCardView(cardView: LineupCardView, animated: Bool = true) {
        let cvc = vcs.popLast()!
        
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
        
        self.view.layoutIfNeeded()
        
        // Begin animation code
        
        let sx = cvc.view.bounds.size.width / cardView.bounds.size.width - 1
        let sy = cvc.view.bounds.size.height / cardView.bounds.size.height - 1
        
        let sx2 = 1 - cardView.bounds.size.width / cvc.view.bounds.size.width
        let sy2 = 1 - cardView.bounds.size.height / cvc.view.bounds.size.height
        
        let spring = Spring(stiffness: 6.0, damping: 0.0, velocity: 4.0)
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
        
        spring.completeBlock = { completed in
            cvc.view.removeFromSuperview()
            cardView.layer.transform = CATransform3DIdentity
        }
        
        UIView.animateWithDuration(0.2, animations: {
            nvc.view.layer.opacity = 1
        })
        
        spring.start()
    }
}