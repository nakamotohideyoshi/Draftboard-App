//
//  GlobalFilterViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 10/29/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class GlobalFilterViewController: DraftboardModalViewController {

    @IBOutlet var allLabel: DraftboardLabel!
    @IBOutlet var mlbLabel: DraftboardLabel!
    @IBOutlet var nbaLabel: DraftboardLabel!
    @IBOutlet var nflLabel: DraftboardLabel!
    @IBOutlet weak var filterLabel: FilterLabel!
    @IBOutlet weak var closeButton: DraftboardButton!
    
    // the textContainer that contains all labels
    @IBOutlet var textContainer: UIView!
    @IBOutlet var containerHeight: NSLayoutConstraint!
    
    // all will always be present, let's reference it's height
    @IBOutlet var allLabelHeight: NSLayoutConstraint!
    
    var filterItems = [DraftboardLabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterItems = [
            allLabel,
            mlbLabel,
            nbaLabel,
            nflLabel
        ]
        
        // items that are selected are whiteColor
        allLabel.textColor = UIColor.whiteColor()
        
        // items that aren't selected get whiteLowOpacity
        mlbLabel.textColor = UIColor.whiteLowOpacity()
        nbaLabel.textColor = UIColor.whiteLowOpacity()
        nflLabel.textColor = UIColor.whiteLowOpacity()
        
        closeButton.addTarget(self, action: Selector("didTapClose:"), forControlEvents: .TouchUpInside)
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