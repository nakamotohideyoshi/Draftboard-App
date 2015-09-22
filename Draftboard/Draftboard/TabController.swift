//
//  TabController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    
    let results = ResultsViewController()
    let lineups = LineupsNavigationController()
    let contests = ContestsNavigationController()
    let account = AccountViewController()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        self.viewControllers = [self.results, self.lineups, self.contests, self.account]
        self.selectedViewController = self.lineups
    }
}
