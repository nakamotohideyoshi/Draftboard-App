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
    var lineups : [LineupCard] = []
    var scrollView = UIScrollView()
    
    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.backgroundColor = .greenColor()
        
        // Derp UIKit
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Properties for navigation
        self.title = "Lineups"
        let filterButton = UIBarButtonItem(title: "Sport: All", style: .Plain, target: self, action: "filterLineups")
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addLineup")
        self.navigationItem.leftBarButtonItem = filterButton
        self.navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .blueColor()
        
//        let exv = UIView()
//        view.addSubview(exv)
//        exv.backgroundColor = .yellowColor()
//        exv.translatesAutoresizingMaskIntoConstraints = false
//        exv.addConstraints(Constraint.makeEq(exv, [.Width, .Height], 200))
//        view.addConstraints(Constraint.makeEq(exv, view, [.CenterX, .CenterY]))
        
//        var cs = [NSLayoutConstraint]()
//        cs.append(Restraint(scrollView, .Top, .Equal, view, .Top).constraint())
//        cs.append(Restraint(scrollView, .Left, .Equal, view, .Left).constraint())
//        cs.append(Restraint(scrollView, .Right, .Equal, view, .Right).constraint())
//        cs.append(Restraint(scrollView, .Bottom, .Equal, view, .Bottom).constraint())
//        view.addConstraints(cs)
        
//        Constraint.makeEqual(scrollView, view, .Top).addToView(view)
//        Constraint.makeEqual(scrollView, view, .Left).addToView(view)
//        Constraint.makeEqual(scrollView, view, .Right).addToView(view)
//        Constraint.makeEqual(scrollView, view, .Bottom).addToView(view)
        
        view.addConstraints(Constraint.makeEq(scrollView, view, [.Top, .Left, .Bottom, .Right]))
        
        lineups.append(LineupCard())
        lineups.append(LineupCard())
        lineups.append(LineupCard())
        lineups.append(LineupCard())
        lineups.append(LineupCard())
        lineups.append(LineupCard())
        
        layoutCards()
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
        let lineupCard = LineupCard()
        self.lineups.append(lineupCard)
        layoutCards()
    }
    
    func layoutCards() {
        
        var previousCard : LineupCard?
        
        for (_, card) in lineups.enumerate() {
            
            // Add card
            scrollView.addSubview(card)
            card.translatesAutoresizingMaskIntoConstraints = false
            
            // Set card dimensions
            let w = Restraint(card, .Width, .Equal, scrollView, .Width).constraint()
            let h = Restraint(card, .Height, .Equal, 200.0).constraint()
            
            scrollView.addConstraint(w)
            card.addConstraint(h)
            
            // Position first card
            if (previousCard == nil) {
                let t = Restraint(card, .Top, .Equal, scrollView, .Top).constraint()
                scrollView.addConstraint(t)
            } else {
                let t = Restraint(card, .Top, .Equal, previousCard!, .Bottom, 1, 20.0).constraint()
                scrollView.addConstraint(t)
            }
            
            previousCard = card
        }
        
        let t = Restraint(previousCard!, .Bottom, .Equal, scrollView, .Bottom).constraint()
        scrollView.addConstraint(t)
    }
}
