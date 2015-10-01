//
//  LineupsListController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupsListController: DraftboardViewController, UIActionSheetDelegate {
    
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var createViewButton: DraftboardRoundButton!
    @IBOutlet weak var createImageView: UIImageView!
    @IBOutlet weak var createIconImageView: UIImageView!
    
    var lineupCardViews : [LineupCardView] = []
    var lastConstraint : NSLayoutConstraint?
    var newLineupVc: LineupNewViewController?
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tap recognizer
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapCreateView:")
        self.createView.addGestureRecognizer(tapRecognizer)
        
        // Scroll view
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        scrollView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        scrollView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        scrollView.topRancor.constraintEqualToRancor(view.topRancor).active = true
        scrollView.alwaysBounceVertical = true
        
        // Create goes on top
        view.bringSubviewToFront(self.createView)
    }
    
    func didTapCreateView(gestureRecognizer: UITapGestureRecognizer) {
        createNewLineup()
    }

    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Plus) {
            createNewLineup()
        }
    }
    
    func createNewLineup() {
        let nvc = LineupNewViewController(nibName: "LineupNewViewController", bundle: nil)
        nvc.listViewController = self
        newLineupVc = nvc
        
        RootViewController.sharedInstance.pushViewController(nvc)
    }
    
    func didSaveLineup() {
        self.createView.hidden = true
        addLineup()
    }
    
    func filterLineups() {
        let sheet = UIAlertController(title: "Filter by sport:", message:"", preferredStyle: .ActionSheet)
        let options = ["All sports", "NBA", "NFL"]
        
        for (i, option) in options.enumerate() {
            let selected = (i == 0)
            let title = (selected ? "    " + option + " ✔︎" : option)
            sheet.addAction(UIAlertAction(title: title, style: .Default, handler: { (action) -> Void in
                // TODO: select the sport
            }))
        }
        
        self.presentViewController(sheet, animated: true) { () -> Void in
            // TODO: anything?
        }
    }
    
    func addLineup() {
        let cardView = LineupCardView()
        scrollView.addSubview(cardView)
        
        // Set card dimensions
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.widthRancor.constraintEqualToRancor(scrollView.widthRancor, multiplier: 0.9).active = true
        cardView.centerXRancor.constraintEqualToRancor(scrollView.centerXRancor).active = true
        cardView.heightRancor.constraintEqualToConstant(cardView.totalHeight).active = true
        
        // Position card vertically
        let lastCardView = lineupCardViews.last
        if (lastCardView == nil) {
            cardView.topRancor.constraintEqualToRancor(scrollView.topRancor).active = true
        } else {
            cardView.topRancor.constraintEqualToRancor(lastCardView!.bottomRancor, constant: 20).active = true
        }
        
        // Attach to bottom of scrollView
        lastConstraint?.active = false
        lastConstraint = cardView.bottomRancor.constraintEqualToRancor(scrollView.bottomRancor)
        lastConstraint?.active = true
        
        // Store card
        self.lineupCardViews.append(cardView)
    }
    
    override func titlebarTitle() -> String {
        return "Lineups".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Menu
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType {
        return .Plus
    }
}
