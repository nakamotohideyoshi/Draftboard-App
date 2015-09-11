//
//  LineupCard.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import Restraint

class LineupCard: UIView {
    
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    let cellReuseId = "lineup-card-cell"
    
    let headerView = UIView()
    let footerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .redColor()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .yellowColor()
        
        self.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .greenColor()
        
        self.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .orangeColor()
        
        var hvc = [NSLayoutConstraint]()
        hvc.append(Restraint(headerView, .Top, .Equal, self, .Top).constraint())
        hvc.append(Restraint(headerView, .Width, .Equal, self, .Width).constraint())
        hvc.append(Restraint(headerView, .Height, .Equal, 20.0).constraint())
        self.addConstraints(hvc)
        
        var fvc = [NSLayoutConstraint]()
        fvc.append(Restraint(footerView, .Bottom, .Equal, self, .Bottom).constraint())
        fvc.append(Restraint(footerView, .Width, .Equal, self, .Width).constraint())
        fvc.append(Restraint(footerView, .Height, .Equal, 20.0).constraint())
        self.addConstraints(fvc)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LineupCard: UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: cellReuseId)
        cell.textLabel?.text = "K. Korver"
        return cell
    }
}