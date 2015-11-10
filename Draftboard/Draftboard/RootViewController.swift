//
//  RootViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import GLKit

final class RootViewController: UIViewController {
    
    static let sharedInstance = RootViewController(nibName: "RootViewController", bundle: nil)
    var topConstraint: NSLayoutConstraint!
    
    var tabController = DraftboardTabController()
    var modalController = DraftboardModalNavController()
    
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        
        // Create tab controller
        let tabControllerView = tabController.view
        view.addSubview(tabControllerView)
        
        // Constrain tab controller
        tabControllerView.translatesAutoresizingMaskIntoConstraints = false
        tabControllerView.topRancor.constraintEqualToRancor(view.topRancor, constant: 20.0).active = true
        tabControllerView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        tabControllerView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        tabControllerView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        
        // Create modal controller
        let modalControllerView = modalController.view
        view.addSubview(modalControllerView)
        
        // Constraint modal controller
        modalControllerView.translatesAutoresizingMaskIntoConstraints = false
        modalControllerView.topRancor.constraintEqualToRancor(view.topRancor).active = true
        modalControllerView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        modalControllerView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        modalControllerView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        modalControllerView.hidden = true;
        
        setAppearanceProperties()
        
        DDM.requestPlayers()
    }
    
    func didSelectGlobalFilter(index: Int) {
        print("RootViewController::didSelectGlobalFilter", index)
    }
    
    func setAppearanceProperties() {
        UITextField.appearance().tintColor = UIColor.greenDraftboard()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return tabController.preferredStatusBarStyle()
    }
    
    func pushModalViewController(nvc: DraftboardModalViewController, animated: Bool = true) {
        modalController.pushViewController(nvc, animated: animated)
        if (modalController.vcs.count == 1) {
            showModalViewController()
        }
    }
    
    func popModalViewController(animated: Bool = true) {
//        modalController.popViewController(animated)
//        if (modalController.vcs.count == 0) {
//            hideModalViewController()
//        }
        
        modalController.popOutViewController()
        hideModalViewController()
    }
    
    func showModalViewController() {
        modalController.view.layer.removeAllAnimations()
        modalController.view.hidden = false
        modalController.view.alpha = 0.0
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.modalController.view.alpha = 1.0
        }) { (completed) -> Void in
            // nuffin' fer now
        }
    }
    
    func hideModalViewController() {
        modalController.view.layer.removeAllAnimations()
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.modalController.view.alpha = 0.0
        }) { (completed) -> Void in
            self.modalController.view.hidden = true
        }
    }
    
    func didSelectModalChoice(index: Int) {
        tabController.cnc.vcs.first?.didSelectModalChoice(index)
    }
    
    func didCancelModal() {
        tabController.cnc.vcs.first?.didCancelModal()
    }
    
    /*
    var updateHandler:(()->Void)?

    func updatePhysics() {
        updateHandler?()
    }
    
    func springPlayground() {
        let redBall = UIView(frame: CGRectMake(0.0,0.0,20.0,20.0))
        redBall.backgroundColor = .redColor()
        redBall.layer.cornerRadius = 10.0
        redBall.layer.shouldRasterize = true
        redBall.layer.rasterizationScale = 2.0
        redBall.layer.position = CGPointMake(100.0, 100.0)
        
        view.addSubview(redBall)
        
        let displayLink = CADisplayLink(target: self, selector: Selector("updatePhysics"))
        displayLink.frameInterval = 1
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        let k: Float = 2.0
        var p = redBall.layer.position
        let endPos = GLKVector2Make(200.0, 100.0)
        var velocity = GLKVector2Make(-15.0, 20.0)
        let mass: Float = 3.0
        
        updateHandler = { () -> Void in
            p = redBall.layer.position
            
            let pos = GLKVector2Make(Float(p.x), Float(p.y))
            let dir = GLKVector2Normalize(GLKVector2Subtract(endPos, pos))
            
            if (dir.x.isNaN || dir.y.isNaN) {
                displayLink.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
                return
            }
            
            let dist = GLKVector2Distance(endPos, pos)
            let restoringForce = k * dist
            let speed: Float = restoringForce * (1.0 / 60.0)
            
            let m: Float = 1.0 / mass
            velocity = GLKVector2Add(velocity, GLKVector2MultiplyScalar(dir, speed * m))
            velocity = GLKVector2MultiplyScalar(velocity, 0.9)
            
            redBall.layer.position = CGPointMake(CGFloat(pos.x + velocity.x), CGFloat(pos.y + velocity.y))
        }
    }
    
    func springPlayground2() {
        let redBall = UIView(frame: CGRectMake(0.0,0.0,20.0,20.0))
        redBall.backgroundColor = .redColor()
        redBall.layer.cornerRadius = 10.0
        redBall.layer.shouldRasterize = true
        redBall.layer.rasterizationScale = 2.0
        redBall.layer.position = CGPointMake(100.0, 100.0)
        view.addSubview(redBall)
        
        let spring = Spring(stiffness: 3.0, mass: 1.0, damping: 0.9, velocity: 0.0)
        
        let startPos = redBall.layer.position
        let endPos = CGPointMake(200.0, 300.0)
        let posDelta = CGPointMake(endPos.x - startPos.x, endPos.y - startPos.y)
        spring.updateBlock = { (value) -> Void in
            redBall.layer.position = CGPointMake(startPos.x + posDelta.x * value, startPos.y + posDelta.y * value)
        }
        
        spring.completeBlock = { (completed) -> Void in
            print("complete fired")
        }
        
        spring.start()
    }
    */
}
