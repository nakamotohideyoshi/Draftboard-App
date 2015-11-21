//
//  LineupEditViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupEditViewController: DraftboardViewController {
    @IBOutlet weak var remSalaryLabel: DraftboardLabel!
    @IBOutlet weak var avgSalaryLabel: DraftboardLabel!
    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var statContainer: UIView!
    @IBOutlet weak var dividerHeight: NSLayoutConstraint!
    
    var draftGroup: DraftGroup!
    var lineup: Lineup!
    var saveLineupAction: (([Player]) -> Void)?
    var positions = [String]()
    var positionPlaceholders = [String]()
    var cellViews = [LineupEmptyCellView]()
    var cellIndex = 0
    
    override func viewDidLoad() {
        let _ = Data.draftGroup(id: draftGroup.id)
        
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
//        statContainer.backgroundColor = UIColor(0x152133, alpha: 0.96)
        let onePixel = 1 / UIScreen.mainScreen().scale
        dividerHeight.constant = onePixel
        layoutCellViews()
        
        /*
        var players = [Player]()
        for i in 0..<8 {
            let playerDict = [
                "player_id": i,
                "name": "Koral Karver",
                "salary": 5000,
                "position": "PG",
                "fppg": 25.5,
                "team_alias": "MEM"
            ]
            players.append(Player(data: playerDict)!)
        }
        lineup = Lineup(data: [
            "id": 100,
            "name": "Warriors Stack",
            "sport": "nba",
            "draft_group": 1
        ])
        */
    }
    
    func layoutCellViews() {
        var previousCell: LineupEmptyCellView?
        
        var divisor: CGFloat = 5.0 // iPhone 4S
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        if (screenHeight > 568) { // iPhone 6 and up
            divisor = 8.0
        }
        else if (screenHeight > 480.0) { // iPhone 5 and up
            divisor = 7.0
        }
        
        for (i, position) in positions.enumerate() {
            let cellView = LineupEmptyCellView()
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
    
    func didTapCell(sender: LineupEmptyCellView) {

        cellIndex = sender.index
        
        var titleText = self.cellViews[cellIndex].abbrLabel.text
        titleText = positionTextForAbbr(titleText!)
        titleText = (titleText == nil) ? "Empty" : titleText
        
        let svc = LineupSearchViewController(titleText: titleText!, nibName: "LineupSearchViewController", bundle: nil)
        svc.draftGroup = draftGroup
        
        svc.playerSelectedAction = {(player: Player) in
            self.navController?.popViewController()
            let cellView = self.cellViews[self.cellIndex]
            cellView.avatarImageView.image = UIImage(named: "sample-avatar-big")
            cellView.player = player
        }
        
        navController?.pushViewController(svc)
    }
    
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
}