//
//  PermissionViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 12/7/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import CoreLocation

class PermissionViewController: DraftboardModalViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var titleLabel: DraftboardLabel!
    @IBOutlet weak var bigIconView: DraftboardImageView!
    @IBOutlet weak var descriptionLabel: DraftboardLabel!
    @IBOutlet weak var grantBtn: DraftboardLoadingButton!
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigIconView.tintColor = bigIconView.tintColor
        grantBtn.addTarget(self, action: .didTapGrantButton, forControlEvents: .TouchUpInside)
        manager.delegate = self
    }
    
    var denied: Bool = false {
        didSet {
            if (denied) {
                titleLabel.text = "PERMISSION DENIED"
                descriptionLabel.text = permissionDeniedText()
                grantBtn.userInteractionEnabled = true
                grantBtn.textValue = "ALLOW"
                grantBtn.loading = false
            }
        }
    }
    
    func permissionDeniedText() -> String {
        return "You must allow the app to check your location before continuing."
    }
    
    func didTapGrantButton(button: DraftboardButton) {
        if denied {
            if let settingsURL = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(settingsURL);
            }
            
            return
        }
        
        grantBtn.loading = true
        grantBtn.userInteractionEnabled = false
        manager.requestWhenInUseAuthorization()
    }
    
    func updateAuthStatus(status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            RootViewController.sharedInstance.locationPermissionsComplete()
        }
        else if status == .Denied || status == .Restricted {
            denied = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        updateAuthStatus(status)
    }
}

private extension Selector {
    static let didTapGrantButton = #selector(PermissionViewController.didTapGrantButton(_:))
}
