//
//  GlobalFilterViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 10/29/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class GlobalFilterViewController: DraftboardModalViewController {
    @IBOutlet var textContainer: UIView!
    @IBOutlet weak var closeButton: DraftboardButton!
    @IBOutlet weak var allControl: GlobalFilterItem!
    @IBOutlet weak var nbaControl: GlobalFilterItem!
    @IBOutlet weak var mlbControl: GlobalFilterItem!
    @IBOutlet weak var nflControl: GlobalFilterItem!
    
    var filterControls = [GlobalFilterItem]()
    var currentControl: GlobalFilterItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clearColor()
        
        filterControls = [
            allControl,
            nbaControl,
            nflControl,
            mlbControl,
        ]
        
        self.view.layoutIfNeeded()
        
        for (i, control) in filterControls.enumerate() {
            control.addTarget(self, action: .didTapControl, forControlEvents: .TouchUpInside)
            control.underlined(false, animated: false)
            control.index = i
        }
        
        currentControl = filterControls[0]
        currentControl.underlined(true, animated: false)
        currentControl.selected = true
        
        closeButton.addTarget(self, action: .didTapClose, forControlEvents: .TouchUpInside)
    }
    
    func didTapControl(sender: GlobalFilterItem) {
        if (sender == currentControl) {
            return
        }
        
        RootViewController.sharedInstance.didSelectGlobalFilter(sender.index)
        currentControl.underlined(false)
        currentControl.selected = false
        
        currentControl = sender
        currentControl.underlined(true)
        currentControl.selected = true
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.20 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue(),{
                RootViewController.sharedInstance.popModalViewController()
            })
        }
    }
    
    func didTapClose(sender: DraftboardButton) {
        RootViewController.sharedInstance.popModalViewController()
    }
}

@IBDesignable
class FilterLabel: DraftboardLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.textColor = UIColor.whiteLowOpacity()
        self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
    }
}

private extension Selector {
    static let didTapControl = #selector(GlobalFilterViewController.didTapControl(_:))
    static let didTapClose = #selector(GlobalFilterViewController.didTapClose(_:))
}