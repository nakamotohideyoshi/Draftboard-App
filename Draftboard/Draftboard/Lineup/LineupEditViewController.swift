//
//  LineupEditViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupEditViewController: DraftboardViewController {
    @IBOutlet weak var contentView: UIScrollView!
    
    var draftGroup: DraftGroup!
    var positions: [String]!
    var players: [Player?]!
    var lineup: Lineup?
    var saveLineupAction: (([Player]) -> Void)?
    var cellViews = [LineupEditCellView]()
    
    var statRemSalary: Double = 0
    var statAvgSalary: Double = 0
    
    override func viewDidLoad() {
        let _ = Data.draftGroup(id: draftGroup.id)
        
        if let lineup = lineup {
            positions = lineup.sport.positions
            players = lineup.players
        }
        else {
            positions = draftGroup.sport.positions
            players = [Player?](count: positions.count, repeatedValue: nil)
        }
        
        contentView.alwaysBounceVertical = true
        contentView.indicatorStyle = .White
        layoutCellViews()
        updateStats()
    }
    
    func layoutCellViews() {
        var previousCell: LineupEditCellView?
        
        var divisor: CGFloat = 5.0 // iPhone 4S
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        if (screenHeight > 568) { // iPhone 6 and up
            divisor = 8.0
        }
        else if (screenHeight > 480.0) { // iPhone 5 and up
            divisor = 7.0
        }
        
        for (i, position) in positions.enumerate() {
            let cellView = LineupEditCellView()
            cellView.abbrText = position
            cellView.nameText = "Select " + positionTextForAbbr(position)
            cellView.salaryText = ""
            cellView.teamText = ""
                
            contentView.addSubview(cellView)
            
            cellView.translatesAutoresizingMaskIntoConstraints = false
            cellView.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
            cellView.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
            cellView.heightRancor.constraintEqualToRancor(contentView.heightRancor, multiplier: 1.0 / divisor).active = true
            cellView.centerXRancor.constraintEqualToRancor(contentView.centerXRancor).active = true
            
            cellView.addTarget(self, action: Selector("didTapCell:"), forControlEvents: .TouchUpInside)
            cellView.bottomBorder = true
            cellView.topBorder = false
            
            if (previousCell == nil) { // First cell
                cellView.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
            }
            else { // Middle cells
                cellView.topRancor.constraintEqualToRancor(previousCell!.bottomRancor).active = true
            }
            if (i == (positions.count - 1)) { // Last cell
                cellView.bottomRancor.constraintEqualToRancor(contentView!.bottomRancor).active = true
                cellView.bottomBorder = false
            }
            
            previousCell = cellView
            cellViews.append(cellView)
            cellView.index = i
        }
    }
    
    func positionTextForAbbr(abbr: String) -> String {
        if (abbr == "PG") {
            return "Point Guard"
        } else if (abbr == "SG") {
            return "Shooting Guard"
        } else if (abbr == "SF") {
            return "Small Forward"
        } else if (abbr == "PF") {
            return "Power Forward"
        } else if (abbr == "C") {
            return "Center"
        } else if (abbr == "FX"){
            return "Flex Player"
        }
        
        return ""
    }
    
    func didTapCell(cell: LineupEditCellView) {
        let titleText = positionTextForAbbr(positions[cell.index])
        let svc = LineupSearchViewController(titleText: titleText, nibName: "LineupSearchViewController", bundle: nil)
        svc.draftGroup = draftGroup
        svc.filterBy = positions[cell.index]
        svc.playerSelectedAction = { player in
            cell.avatarImageView.image = UIImage(named: "sample-avatar-big")
            cell.player = player
            self.players[cell.index] = player
            self.updateStats()
            self.navController?.popViewController()
        }
        
        navController?.pushViewController(svc)
    }
    
    func updateStats() {
        let lineupSalary = players.reduce(0) {$0 + ($1?.salary ?? 0)}
        let playersRemaining = players.filter {$0 == nil}.count
        statRemSalary = draftGroup.sport.salary - lineupSalary
        statAvgSalary = (playersRemaining > 0) ? statRemSalary / Double(playersRemaining) : 0
    }
    
    // MARK: - Titlebar datasource methods
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .DisabledValue) {
            print("You can't save an invalid lineup")
        }
        else if (buttonType == .Value) {
            let p = players.flatMap{$0}
            saveLineupAction?(p)
        }
        else if (buttonType == .Close) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String {
        return "Create \(draftGroup.sport.name) Lineup".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Close
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType {
        let playersRemaining = players.filter {$0 == nil}.count
        
        if playersRemaining > 0 {
            return .DisabledValue
        }
        if statRemSalary < 0 {
            return .DisabledValue
        }
        
        return .Value
    }
    
    override func titlebarRightButtonText() -> String? {
        return "Save".uppercaseString
    }
    
    override func titlebarBgHidden() -> Bool {
        return false
    }
    
    override func footerType() -> FooterType {
        return .Stats
    }
}

extension LineupEditViewController: StatFooterDataSource {
    
    func footerStatAvgSalary() -> Double? {
        if (statAvgSalary < 0) {
            return 0.0
        }
        
        return statAvgSalary
    }
    
    func footerStatRemSalary() -> Double? {
        return statRemSalary
    }
    
    func footerStatLiveInDate() -> NSDate? {
        return draftGroup.start
    }
}