//
//  ContestsDetailViewController.swift
//  RedMesa
//
//  Created by Karl Weber on 9/17/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestsDetailViewController: UIViewController {

    let headerStackView: UIView = UIView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .draftColorDarkBlue()
    }
    
    // add fancy views to the thing.
    func setupData() {
    
    }

}
