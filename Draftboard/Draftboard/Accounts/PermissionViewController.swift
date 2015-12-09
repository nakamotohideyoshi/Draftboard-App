//
//  PermissionViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 12/7/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class PermissionViewController: DraftboardViewController {

    @IBOutlet weak var titleLabel: DraftboardLabel!
    @IBOutlet weak var bigIconView: DraftboardImageView!
    @IBOutlet weak var descriptionLabel: DraftboardLabel!
    @IBOutlet weak var grantBtn: DraftboardButton!
    @IBOutlet weak var secondaryBtn: DraftboardButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bigIconView.tintColor = bigIconView.tintColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
