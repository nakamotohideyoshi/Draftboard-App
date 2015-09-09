//
//  ResultsViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    let label = UILabel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Results", image: UIImage(named: "second"), selectedImage: nil)
        self.tabBarItem.badgeValue = "!"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        
        self.label.text = "Live Results"
        self.label.sizeToFit()
        self.label.center = self.view.center
        self.view.addSubview(label)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarItem.badgeValue = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
