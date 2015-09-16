//
//  LineupsListController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit
import Restraint

class LineupsListController: UIViewController, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    let tableView = UITableView()
    var lineupCardViews : [LineupCardView] = []
    var scrollView = UIScrollView()
    var lastConstraint : NSLayoutConstraint?
    
    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = .darkGrayColor()
        
        // Properties for navigation
        self.title = "Lineups"
        let filterButton = UIBarButtonItem(title: "Sport: All", style: .Plain, target: self, action: "filterLineups")
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addLineup")
        self.navigationItem.leftBarButtonItem = filterButton
        self.navigationItem.rightBarButtonItem = addButton
        
        // Configure scrollView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        scrollView.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
        scrollView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        scrollView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        
        // Fake lineups
        addLineup()
        addLineup()
        addLineup()
        addLineup()
        addLineup()
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
