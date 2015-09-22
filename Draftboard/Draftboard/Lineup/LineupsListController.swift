//
//  LineupsListController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupsListController: UIViewController, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var createViewButton: DraftboardRoundedButton!
    @IBOutlet weak var floorImageView: UIImageView!
    @IBOutlet weak var createImageView: UIImageView!
    @IBOutlet weak var createIconImageView: UIImageView!
    
    var lineupCardViews : [LineupCardView] = []
    var lastConstraint : NSLayoutConstraint?
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        
        // Properties for navigation
        self.title = "Lineups"
        let filterButton = UIBarButtonItem(title: "Sport: All", style: .Plain, target: self, action: "filterLineups")
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createNewLineup")
        self.navigationItem.leftBarButtonItem = filterButton
        self.navigationItem.rightBarButtonItem = addButton
        
        // Tap recognizer
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapCreateView:")
        self.createView.addGestureRecognizer(tapRecognizer)
        
        // Interface builder sucks
        self.createView.sendSubviewToBack(createImageView)
        
        // Configure scrollView
        view.addSubview(scrollView)
        view.bringSubviewToFront(self.createView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        scrollView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        scrollView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        scrollView.topRancor.constraintEqualToRancor(view.topRancor).active = true
        scrollView.contentInset = UIEdgeInsetsMake(84, 0, 48, 0)
        scrollView.alwaysBounceVertical = true
    }
    
    func didTapCreateView(gestureRecognizer: UITapGestureRecognizer) {
        createNewLineup()
    }
    
    func createNewLineup() {
        let nvc = LineupNewViewController(nibName: "LineupNewViewController", bundle: nil)
        nvc.listViewController = self
        self.presentViewController(nvc, animated: true) { () -> Void in

        }
    }
    
    func didSaveLineup() {
        self.scrollView.hidden = false
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
}
