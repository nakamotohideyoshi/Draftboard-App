//
//  PermissionViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 12/7/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import CoreLocation
import PromiseKit

enum LocationError: ErrorType {
    case InvalidState(String)
    case InvalidCountry(String)
    case Unknown
}


class PermissionViewController: DraftboardModalViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var titleLabel: DraftboardLabel!
    @IBOutlet weak var bigIconView: DraftboardImageView!
    @IBOutlet weak var descriptionLabel: DraftboardLabel!
    @IBOutlet weak var grantBtn: DraftboardLoadingButton!
    
    let titleLabel1 = DraftboardLabel()
    let loaderView = LoaderView()
    
    let (pendingPromise, fulfill, reject) = Promise<Void>.pendingPromise()
    
    let manager = CLLocationManager()
    let coder = CLGeocoder()
    
    let allowedStates = ["CA", "PA", "OH", "NC", "MI", "NJ", "WI", "MN", "SC", "KY", "OR", "OK", "CT", "UT", "NM", "NE",
                         "WV", "RI", "SD", "ND", "AK", "WY", "MA", "TN", "MD", "CO", "AR", "KS", "ME", "MS"]
    
    var descriptionText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigIconView.tintColor = bigIconView.tintColor
        grantBtn.addTarget(self, action: .didTapGrantButton, forControlEvents: .TouchUpInside)
        manager.delegate = self
        
        // UI for getting location state
        view.addSubview(titleLabel1)
        view.addSubview(loaderView)
        
        let viewConstraints: [NSLayoutConstraint] = [
            titleLabel1.centerXRancor.constraintEqualToRancor(view.centerXRancor),
            titleLabel1.centerYRancor.constraintEqualToRancor(view.centerYRancor, constant: -61),
            loaderView.widthRancor.constraintEqualToConstant(42.0),
            loaderView.heightRancor.constraintEqualToConstant(42.0),
            loaderView.centerXRancor.constraintEqualToRancor(view.centerXRancor),
            loaderView.centerYRancor.constraintEqualToRancor(view.centerYRancor, constant: 0.0),
        ]
        titleLabel1.translatesAutoresizingMaskIntoConstraints = false
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
        
        titleLabel1.textColor = .whiteColor()
        titleLabel1.font = .oswald(size: 15)
        titleLabel1.text = "Getting Location".uppercaseString
        
        loaderView.hidden = true
        titleLabel1.hidden = true
        
        descriptionLabel.text = descriptionText
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
    
    func promise() -> Promise<Void> {
        RootViewController.sharedInstance.pushModalViewController(self)
        return pendingPromise
    }
    
    func permissionDeniedText() -> String {
        return "You must allow the app to check your location before continuing."
    }
    
    func didTapGrantButton(button: DraftboardButton) {
        if denied {
            if let settingsURL = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(settingsURL, options: [:], completionHandler: nil)
            }
            
            return
        }
        
        grantBtn.loading = true
        grantBtn.userInteractionEnabled = false
        manager.requestWhenInUseAuthorization()
    }
    
    func updateAuthStatus(status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            titleLabel.hidden = true
            bigIconView.hidden = true
            descriptionLabel.hidden = true
            grantBtn.hidden = true
            titleLabel1.hidden = false
            loaderView.hidden = false
            loaderView.resumeSpinning()
            CLLocationManager.promise().then { location in
                return self.coder.reverseGeocodeLocation(location)
            }.then { placemark -> Void in
                if placemark.ISOcountryCode == "CA" {
                    self.fulfill()
                } else if placemark.ISOcountryCode == "US" {
                    if self.allowedStates.contains(placemark.administrativeArea ?? "") {
                        self.fulfill()
                    } else {
                        self.reject(LocationError.InvalidState(placemark.administrativeArea ?? ""))
                    }
                } else {
                    self.reject(LocationError.InvalidCountry(placemark.ISOcountryCode ?? ""))
                }
            }

            //RootViewController.sharedInstance.locationPermissionsComplete()
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
