//
//  LocationErrorViewController.swift
//  Draftboard
//
//  Created by devguru on 9/5/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class LocationErrorViewController: DraftboardModalViewController {

    @IBOutlet weak var descriptionLabel: DraftboardLabel!
    @IBOutlet weak var gotItButton: DraftboardLoadingButton!
    
    var descriptionText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gotItButton.addTarget(self, action: .didTapGotItButton, forControlEvents: .TouchUpInside)
        descriptionLabel.text = descriptionText
    }
    
    func didTapGotItButton(button: DraftboardButton) {
        RootViewController.sharedInstance.popModalViewController()
    }
}

private extension Selector {
    static let didTapGotItButton = #selector(LocationErrorViewController.didTapGotItButton(_:))
}
