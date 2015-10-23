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
    var tabController = DraftboardTabController()
    var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        let v = tabController.view
        view.addSubview(v)
        
        v.translatesAutoresizingMaskIntoConstraints = false
        v.topRancor.constraintEqualToRancor(view.topRancor, constant: 20.0).active = true
        v.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        v.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        v.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        
//        DDM.playersForSport(0)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return tabController.preferredStatusBarStyle()
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
