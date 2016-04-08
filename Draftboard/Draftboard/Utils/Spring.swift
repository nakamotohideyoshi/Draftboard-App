//
//  Spring.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/15/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

final class Springs: NSObject {
    static let sharedInstance = Springs()
    
    var id: UInt = 0
    var springs = [Spring]()
    
    var lastUpdateTime: CFAbsoluteTime = 0.0
    var timeSinceLastUpdate: NSTimeInterval = 0.0
    var accumulatedTime: NSTimeInterval = 0.0
    var displayLink: CADisplayLink?
    
    override init() {}
    
    func createDisplayLink() {
        if (displayLink != nil) {
            return
        }
        
        displayLink = CADisplayLink(target: self, selector: .update)
        displayLink!.frameInterval = 1
        displayLink!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func destroyDisplayLink() {
        if (displayLink == nil) {
            return
        }
        
        displayLink?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink = nil
    }
    
    func add(spring: Spring) -> Bool {
        createDisplayLink()
        
        if (springs.contains(spring)) {
            return false
        }
        
        springs.append(spring)
        return true
    }
    
    func remove(spring: Spring) -> Bool {
        if let idx = springs.indexOf(spring) {
            springs.removeAtIndex(idx)
            
            if (springs.count == 0) {
                destroyDisplayLink()
            }
            
            return true
        }
        
        return false
    }
    
    func update() {
        var completeSprings = [Spring]()
        let now = CFAbsoluteTimeGetCurrent()
        
        for (_, spring) in springs.enumerate() {
            if (now - spring.startTime < spring.startDelay) {
                continue
            }
            
            spring.integrate(1.0 / 60.0)
            spring.updateBlock?(spring.val)
            
            if (spring.complete) {
                completeSprings.append(spring)
                spring.completeBlock?(true)
            }
        }
        
        for (_, spring) in completeSprings.enumerate() {
            let idx = springs.indexOf(spring)
            if (idx != nil) {
                springs.removeAtIndex(idx!)
            }
        }
        
        if (springs.count == 0) {
            destroyDisplayLink()
        }
    }
    
    func uniqueId() -> UInt {
        id += 1
        return id
    }
}

class Spring {
    var id: UInt
    
    var updateBlock:((CGFloat)->Void)?
    var completeBlock:((Bool)->Void)?
    
    var stiffness: CGFloat
    var damping: CGFloat
    var velocity: CGFloat
    
    var velocityThreshold: CGFloat = 0.00001
    var valueThreshold: CGFloat = 0.001
    
    var val: CGFloat
    var complete = false
    
    var startTime: CFAbsoluteTime
    var startDelay: CFTimeInterval
    
    init(stiffness s: CGFloat = 0.0, damping d: CGFloat = 0.9, velocity v: CGFloat = 0.0) {
        id = Springs.sharedInstance.uniqueId()
        stiffness = s
        damping = d
        velocity = v * CGFloat(1.0 / 60.0)
        startDelay = 0
        startTime = 0
        val = 0
    }
    
    func start(delay: CFTimeInterval = 0) {
        startDelay = delay
        startTime = CFAbsoluteTimeGetCurrent()
        Springs.sharedInstance.add(self)
    }
    
    func stop() {
        Springs.sharedInstance.remove(self)
    }
    
    func cancel() {
        updateBlock?(1.0)
        completeBlock?(false)
        Springs.sharedInstance.remove(self)
    }
    
    func integrate(deltaTime: NSTimeInterval) {
        let force = stiffness * (1.0 - val) * CGFloat(deltaTime)
        
        velocity += force
        val += velocity
        velocity *= damping
        
        if (abs(velocity) < velocityThreshold && (1 - val) < valueThreshold) {
            complete = true
            val = 1.0
        }
        
//        if ((1 - val) < valueThreshold) {
//            print("value")
//        }
//        if (abs(velocity) < velocityThreshold) {
//            print("velocity")
//        }
    }
}

extension Spring: Equatable {}
func ==(lhs: Spring, rhs: Spring) -> Bool {
    return lhs.id == rhs.id
}

extension CALayer {
    func killImplicitAnimations() {
        let na = NullAction()
        self.actions = [
            "onOrderIn": na,
            "onOrderOut": na,
            "sublayers": na,
            "contents": na,
            "bounds": na,
            "position": na,
            "transform": na,
            "opacity": na,
            "path": na,
        ];
    }
}

private extension Selector {
    static let update = #selector(Springs.update)
}

class NullAction: CAAction {
    @objc
    func runActionForKey(event: String, object anObject: AnyObject, arguments dict: [NSObject : AnyObject]?) {
        // Do nothing.
    }
}
