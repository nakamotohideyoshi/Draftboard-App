//
//  DraftboardModalViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/25/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardModalViewController: UIViewController {
    var navController: DraftboardModalNavController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    // TODO: Delete this, destroy all nibs
    override init(nibName: String?, bundle: NSBundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
