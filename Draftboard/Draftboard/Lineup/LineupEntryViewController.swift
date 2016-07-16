//
//  LineupEntryViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 7/1/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class LineupEntryViewController: DraftboardViewController {
    
    var lineupEntryView: LineupEntryView { return view as! LineupEntryView }
    var lineup: Lineup?
    var entries: [LineupEntry] = []
    var flipAction: (() -> Void) = {}

    convenience init(lineup: Lineup) {
        self.init()
        self.lineup = lineup
    }
    
    override func loadView() {
        self.view = LineupEntryView()
    }
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tap)
    }
    
    func tapped() {
        flipAction()
    }

}

private typealias TableViewDelegate = LineupEntryViewController
extension TableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    
    // UITableViewDataSource
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let entry = entries[indexPath.row]
        let contestName = entry.contest.name
        let fee = entry.contest.buyin
        let action = {
            entry.unregister()
        }
        
        return cell
    }
    
}
