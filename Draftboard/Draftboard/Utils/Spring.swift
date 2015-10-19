//
//  Spring.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/15/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

final class Springs: NSObject {
    static let sharedInstance = Springs()
    
    var id: UInt = 0
    var springs = [Spring]()
    
    var lastUpdateTime: CFAbsoluteTime = 0.0
    var timeSinceLastUpdate: NSTimeInterval = 0.0
    var accumulatedTime: NSTimeInterval = 0.0
    
    let physicsTimeInterval: NSTimeInterval = 1.0 / 60.0
    
    var displayLink: CADisplayLink?
    var physicsTimer: NSTimer?
    
    override init() {}
    
    func createPhysicsTimer() {
        if (physicsTimer != nil) {
            return
        }
        
        let time = CACurrentMediaTime()
        lastUpdateTime = time
        
        physicsTimer = NSTimer(timeInterval: 1.0 / 90.0, target: self, selector: Selector("integrate"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(physicsTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func destroyPhysicsTimer() {
        if (physicsTimer == nil) {
            return
        }
        
        physicsTimer?.invalidate()
        physicsTimer = nil
    }
    
    func createDisplayLink() {
        if (displayLink != nil) {
            return
        }
        
        displayLink = CADisplayLink(target: self, selector: Selector("update"))
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
        createPhysicsTimer()
        
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
                destroyPhysicsTimer()
            }
            
            return true
        }
        
        return false
    }
    
    func update() {
        var completeSprings = [Int]()
        
        for (i, spring) in springs.enumerate() {
            spring.updateBlock?(spring.val)
            
            if (spring.complete) {
                completeSprings.append(i)
                spring.completeBlock?(true)
            }
        }
        
        for (_, idx) in completeSprings.enumerate() {
            springs.removeAtIndex(idx)
        }
        
        if (springs.count == 0) {
            destroyDisplayLink()
            destroyPhysicsTimer()
        }
    }
    
    func integrate() {
        let time = CACurrentMediaTime();
        timeSinceLastUpdate = time - lastUpdateTime;
        lastUpdateTime = time;
        accumulatedTime += timeSinceLastUpdate
        
        while (accumulatedTime > physicsTimeInterval) {
            for (_, spring) in springs.enumerate() {
                spring.integrate(physicsTimeInterval)
            }

            accumulatedTime -= physicsTimeInterval
        }
    }
    
    func uniqueId() -> UInt {
        return id++
    }
}

class Spring {
    var id: UInt
    
    var updateBlock:((CGFloat)->Void)?
    var completeBlock:((Bool)->Void)?
    
    var stiffness: CGFloat
    var mass: CGFloat
    var damping: CGFloat
    var velocity: CGFloat
    
    var velocityThreshold: CGFloat = 0.00001
    var valueThreshold: CGFloat = 0.001
    
    var val: CGFloat
    var complete = false
    
    init(stiffness s: CGFloat = 0.0, mass m: CGFloat = 1.0, damping d: CGFloat = 0.9, velocity v: CGFloat = 0.0) {
        id = Springs.sharedInstance.uniqueId()
        stiffness = s
        mass = m
        damping = d
        velocity = v * CGFloat(1.0 / 60.0)
        val = 0
    }
    
    func start() {
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
        
        velocity += force * (1.0 / mass)
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
