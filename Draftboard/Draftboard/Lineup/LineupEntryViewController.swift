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

    convenience init(lineup: Lineup) {
        self.init()
        self.lineup = lineup
    }
    
    override func loadView() {
        self.view = LineupEntryView()
    }

}