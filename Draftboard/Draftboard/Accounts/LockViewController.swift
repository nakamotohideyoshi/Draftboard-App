//
//  LockViewController.swift
//  Draftboard
//
//  Created by devguru on 4/11/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class LockViewController: DraftboardModalViewController {

    let (promise, fulfill, reject) = Promise<Int>.pendingPromise()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clearColor()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: .didTapAction)
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func didTapAction(button: DraftboardButton) {
        fulfill(0)
    }
}

private extension Selector {
    static let didTapAction = #selector(ErrorViewController.didTapAction(_:))
}
