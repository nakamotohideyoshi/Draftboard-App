//
//  LineupsDetailController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupsDetailController: UIViewController {
    
    let titleLabel = UILabel()
    
    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.titleLabel.text = "Lineup Name"
        self.titleLabel.sizeToFit()
        self.titleLabel.center = self.view.center
        self.view.addSubview(self.titleLabel)
    }
    
}
