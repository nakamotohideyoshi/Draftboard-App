//
//  GlobalFilterViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 10/29/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class GlobalFilterViewController: DraftboardViewController {

    @IBOutlet var allLabel: DraftboardLabel!
    @IBOutlet var mlbLabel: DraftboardLabel!
    @IBOutlet var nbaLabel: DraftboardLabel!
    @IBOutlet var nflLabel: DraftboardLabel!
    
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
        
        // the height of textContainer needs to be a multiple of the items
        // that are inside of it for it to center correctly
        let heightMultiplier = CGFloat(filterItems.count)
        containerHeight = textContainer.heightRancor
            .constraintEqualToRancor(allLabel.heightRancor, multiplier: heightMultiplier, constant: 4)
        containerHeight.active = true
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Close) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String? {
        // The global filters view doesn't have a title
        return ""
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Close
    }
}

@IBDesignable
class FilterLabel: DraftboardLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = UIColor.whiteLowOpacity()
        self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}