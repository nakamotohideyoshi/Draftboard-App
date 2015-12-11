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
    
//    @IBOutlet weak var statLiveIn: DraftboardLabel!
//    @IBOutlet weak var statRemSalary: DraftboardLabel!
//    @IBOutlet weak var statAvgPerPlayer: DraftboardLabel!
    
    var draftGroup: DraftGroup!
    var lineup: Lineup!
    var saveLineupAction: (([Player]) -> Void)?
    var positions = [String]()
    var positionPlaceholders = [String]()
    var cellViews = [LineupEditCellView]()
    var cellIndex = 0
    
    var statRemSalary: Double = 0
    var statAvgSalary: Double = 0
    
    override func viewDidLoad() {
        let _ = Data.draftGroup(id: draftGroup.id)
        
        // Temp
        draftGroup.start = NSDate(timeIntervalSinceNow: 3600 * 12)
        statRemSalary = draftGroup.sport.salary
        statAvgSalary = statRemSalary / 8.0
        
        positions = ["PG", "SG", "SF", "PF", "C", "FX", "FX", "FX"]
        positionPlaceholders = [
            "Select Point Guard",
            "Select Shooting Guard",
            "Select Small Forward",
            "Select Power Forward",
            "Select Center",
            "Select Flex Player",
            "Select Flex Player",
            "Select Flex Player"
        ]
        
        contentView.alwaysBounceVertical = true
        contentView.indicatorStyle = .White
        layoutCellViews()
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
            cellView.nameText = positionPlaceholders[i]
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
    
    func positionTextForAbbr(abbr: String) -> String? {
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
        } else if (abbr == "G") {
            return "Guard"
        } else if (abbr == "F") {
            return "Forward"
        } else if (abbr == "FX"){
            return "Flex"
        }
        
        return nil
    }
    
    func didTapCell(sender: LineupEditCellView) {

        cellIndex = sender.index
        
        var titleText = self.cellViews[cellIndex].abbrLabel.text
        titleText = positionTextForAbbr(titleText!)
        titleText = (titleText == nil) ? "Empty" : titleText
        
        let svc = LineupSearchViewController(titleText: titleText!, nibName: "LineupSearchViewController", bundle: nil)
        svc.draftGroup = draftGroup
        svc.filterBy = positions[cellIndex]
        svc.playerSelectedAction = {(player: Player) in
            let cellView = self.cellViews[self.cellIndex]
            cellView.avatarImageView.image = UIImage(named: "sample-avatar-big")
            cellView.player = player
            self.updateStats()
            self.navController?.popViewController()
        }
        
        navController?.pushViewController(svc)
    }
    
    func updateStats() {
        
        // Lame
        var lineupSalary: Double = 0
        var playersRemaining: Int = 0
        for cell in cellViews {
            if let player = cell.player {
                lineupSalary += player.salary
            } else {
                playersRemaining += 1
            }
        }
        
        statRemSalary = draftGroup.sport.salary - lineupSalary
        statAvgSalary = (playersRemaining == 0) ? 0 : statRemSalary / Double(playersRemaining)
    }
    
//    func updateStatLiveIn() {
//        // http://stackoverflow.com/questions/4933075/nstimeinterval-to-hhmmss
//        let interval = Int(draftGroup.start.timeIntervalSinceNow)
//        let seconds = abs(interval) % 60
//        let minutes = abs(interval / 60) % 60
//        let hours = abs(interval / 3600)
//        let sign = (interval < 0) ? "-" : ""
//        statLiveIn.text = String(format: "%@%02d:%02d:%02d", sign, hours, minutes, seconds)
//    }
    
    // MARK: - Titlebar datasource methods
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .DisabledValue) {
            print("You can't save a completely empty lineup")
            return
        }
        
        if (buttonType == .Value) {
            var players = [Player]()
            for cell in cellViews {
                if let player = cell.player {
                    players.append(player)
                }
            }
            // Make a full lineup even when they didn't pick all 8
            while players.count < 8 {
                players.append(players[0])
            }
            saveLineupAction?(players)
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
        for cell in self.cellViews {
            if cell.player != nil {
                return .Value
            }
        }
        
        return .DisabledValue
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