//
//  RootViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import GLKit
import CoreLocation
import PromiseKit

final class RootViewController: UIViewController {
    
    static let sharedInstance = RootViewController(nibName: "RootViewController", bundle: nil)
    var topConstraint: NSLayoutConstraint!
    
    var tabController = DraftboardTabController()
    var modalController = DraftboardModalNavController()
    var modalAlertController = DraftboardModalNavController()
    var loginViewController: LoginViewController?
    
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        
        addTabController()
        addModalControllerView(modalController.view)
        addModalControllerView(modalAlertController.view)
        setAppearanceProperties()
        
    }
    
    func addModalControllerView(v: UIView) {
        
        // Add modal controller view
        view.addSubview(v)
        
        // Constrain modal controller view
        v.translatesAutoresizingMaskIntoConstraints = false
        v.topRancor.constraintEqualToRancor(view.topRancor).active = true
        v.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        v.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        v.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        
        // Starts hidden
        v.hidden = true
    }
    
    func addTabController() {
        
        // Add tab controller view
        let tabControllerView = tabController.view
        view.addSubview(tabControllerView)
        
        // Constrain tab controller view
        tabControllerView.translatesAutoresizingMaskIntoConstraints = false
        tabControllerView.topRancor.constraintEqualToRancor(view.topRancor).active = true
        tabControllerView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        tabControllerView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        tabControllerView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
    }
    
    func didSelectGlobalFilter(index: Int) {
        print("RootViewController::didSelectGlobalFilter", index)
    }
    
    func setAppearanceProperties() {
        if #available(iOS 9, *) {
            UISearchBar.appearance().searchBarStyle = .Minimal
            UISearchBar.appearance().barTintColor = .blueDarker()
            UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = .greenDraftboard()
            UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).textColor = .whiteColor()
            /*
            // This works but the icon colors won't budge, so...
            UILabel.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).textColor = .greyCool()
            // This would need image to have renderingMode .AlwaysTemplate, but it doesn't work anyway
            UIImageView.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = .greyCool()
            */
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return tabController.preferredStatusBarStyle()
    }
}

// MARK - Modals

extension RootViewController {
    
    func pushModalViewController(nvc: DraftboardModalViewController, animated: Bool = true) {
        modalController.pushViewController(nvc, animated: animated)
        if (modalController.vcs.count == 1) {
            showModalViewController(animated)
        }
    }
    
    func popModalViewController(animated: Bool = true) {
//        modalController.popViewController(animated)
//        if (modalController.vcs.count == 0) {
//            hideModalViewController()
//        }
        
        modalController.popOutViewController(animated)
        hideModalViewController(animated)
    }
    
    func showModalViewController(animated: Bool = true) {
        modalController.view.layer.removeAllAnimations()
        modalController.view.hidden = false
        
        if (animated) {
            modalController.view.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.modalController.view.alpha = 1.0
                }) { (completed) -> Void in
                    // mt
            }
        }
    }
    
    func hideModalViewController(animated: Bool = true) {
        modalController.view.layer.removeAllAnimations()
        
        if (animated) {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.modalController.view.alpha = 0.0
                }) { (completed) -> Void in
                    self.modalController.view.hidden = true
            }
            
            return
        }
        
        self.modalController.view.hidden = true
        self.modalController.view.alpha = 0.0
    }
    
    func didSelectModalChoice(index: Int) {
        tabController.cnc.vcs.last?.didSelectModalChoice(index)
    }
    
    func didCancelModal() {
        tabController.cnc.vcs.last?.didCancelModal()
    }
}

extension RootViewController {
    
    func pushAlertViewController(nvc: DraftboardModalViewController, animated: Bool = true) {
        modalAlertController.pushViewController(nvc, animated: animated)
        if (modalAlertController.vcs.count == 1) {
            showAlertViewController(animated)
        }
    }
    
    func popAlertViewController(animated: Bool = true) {
        modalAlertController.popOutViewController(animated)
        hideAlertViewController(animated)
    }
    
    func showAlertViewController(animated: Bool = true) {
        modalAlertController.view.layer.removeAllAnimations()
        modalAlertController.view.hidden = false
        
        if (animated) {
            modalAlertController.view.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.modalAlertController.view.alpha = 1.0
                }) { (completed) -> Void in
                    // mt
            }
        }
    }
    
    func hideAlertViewController(animated: Bool = true) {
        modalAlertController.view.layer.removeAllAnimations()
        
        if (animated) {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.modalAlertController.view.alpha = 0.0
                }) { (completed) -> Void in
                    self.modalAlertController.view.hidden = true
            }
            
            return
        }
        
        self.modalAlertController.view.hidden = true
        self.modalAlertController.view.alpha = 0.0
    }
}

// MARK - Permissions

extension RootViewController {
    
    func showLoginController() -> Promise<Void> {
        if let vc = modalController.vcs.last as? LoginViewController {
            return vc.promise
        }
        let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
        pushModalViewController(vc, animated: true)
        return vc.promise
    }

    func authComplete() {
        checkLocationPermissions()
    }
    
    func checkLocationPermissions() {
        let locAuthStatus = CLLocationManager.authorizationStatus()
        
        if locAuthStatus == .NotDetermined {
            let vc = PermissionViewController(nibName: "PermissionViewController", bundle: nil)
            pushModalViewController(vc, animated: true)
        }
        else if locAuthStatus == .Denied || locAuthStatus == .Restricted {
            let vc = PermissionViewController(nibName: "PermissionViewController", bundle: nil)
            pushModalViewController(vc, animated: true)
        }
        else {
            checkNotificationPermissions()
        }
    }
    
    func locationPermissionsComplete() {
        checkNotificationPermissions()
    }
    
    func checkNotificationPermissions() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey(App.DefaultsDidSeeNotifications) {
            notificationPermissionsComplete()
            return
        }
        
        defaults.setBool(true, forKey: App.DefaultsDidSeeNotifications)
        defaults.synchronize()
        
        let vc = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
        pushModalViewController(vc, animated: true)
    }
    
    func notificationPermissionsComplete() {
        self.tabController.view.hidden = false
        self.popModalViewController(true)
    }
}
