//
//  PermissionViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 12/7/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import CoreLocation

class NotificationViewController: DraftboardModalViewController {
    
    @IBOutlet weak var titleLabel: DraftboardLabel!
    @IBOutlet weak var bigIconView: DraftboardImageView!
    @IBOutlet weak var descriptionLabel: DraftboardLabel!
    @IBOutlet weak var grantBtn: DraftboardLoadingButton!
    @IBOutlet weak var secondaryBtn: DraftboardButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigIconView.tintColor = bigIconView.tintColor
        grantBtn.addTarget(self, action: .didTapGrantButton, forControlEvents: .TouchUpInside)
        secondaryBtn.addTarget(self, action: .didTapSecondaryButton, forControlEvents: .TouchUpInside)
    }
    
    func didTapGrantButton(button: DraftboardButton) {
        let application = UIApplication.sharedApplication()
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge, .Alert], categories: nil))
        application.registerForRemoteNotifications()
        
        RootViewController.sharedInstance.notificationPermissionsComplete()
    }
    
    func didTapSecondaryButton(button: DraftboardButton) {
        RootViewController.sharedInstance.notificationPermissionsComplete()
    }
}

private extension Selector {
    static let didTapGrantButton = #selector(NotificationViewController.didTapGrantButton(_:))
    static let didTapSecondaryButton = #selector(NotificationViewController.didTapSecondaryButton(_:))    
}