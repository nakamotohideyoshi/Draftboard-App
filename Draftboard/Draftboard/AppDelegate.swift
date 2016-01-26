//
//  AppDelegate.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

// Globals
struct App {
    static var screenPixel: CGFloat = 0
    static var screenScale: CGFloat = 0
    static var screenBounds: CGRect = CGRectZero
    static var authenticated = true
    static var libraryPath = ""
    static var cachesPath = ""
    static var nibCache = [String: UINib]()
    static var DefaultsDidSeeNotifications = "draftboard_defaults_did_see_notifications"
    
    func roundToScreenPixel(v: CGFloat) -> CGFloat {
        return round(v * App.screenScale) / App.screenScale;
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setConstants()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = RootViewController.sharedInstance
        window!.makeKeyAndVisible()
        
        preloadKeyboard()
        
        return true
    }
    
    func preloadKeyboard() {
        let lagFreeField: UITextField = UITextField()
        self.window?.addSubview(lagFreeField)
        lagFreeField.becomeFirstResponder()
        lagFreeField.resignFirstResponder()
        lagFreeField.removeFromSuperview()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func setConstants() {
        
        // Screen
        let screen = UIScreen.mainScreen()
        App.screenBounds = screen.bounds
        App.screenScale = screen.scale
        App.screenPixel = 1.0 / screen.scale
        
        // Paths
        App.libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        App.cachesPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
    }
}
