//
//  ContestsNavigationController.swift
//  Draftboard
//
//  Created by Karl Weber on 9/18/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestsNavigationController: UINavigationController {

    let list = ContestsListController()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Contests", image: UIImage(named: "first"), selectedImage: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.viewControllers = [list]
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
