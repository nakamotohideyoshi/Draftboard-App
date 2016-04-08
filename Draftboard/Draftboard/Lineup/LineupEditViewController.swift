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
    
    var lineup: Lineup = Lineup() {
        didSet { updateCellViews() }
    }
    var saveLineupAction: (Lineup -> Void)?
    var cellViews = [LineupEditCellView]()
    
    var statRemSalary: Double = 0
    var statAvgSalary: Double = 0
    
    var draftGroup = DraftGroup()
    
    override func viewDidLoad() {
        API.draftGroup(id: lineup.draftGroup.id).then { draftGroup -> Void in
            self.draftGroup = draftGroup
        }
        
        contentView.alwaysBounceVertical = true
        contentView.indicatorStyle = .White
        layoutCellViews()
        updateStats()
        
        // Temp:
        // Pick an MVP, then double-tap contentView to fill junk lineup
        let junkGesture = UIScreenEdgePanGestureRecognizer(target: self, action: .fillJunkLineup)
        junkGesture.edges = .Right
        view.addGestureRecognizer(junkGesture)
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
        
        let positions = lineup.sport.positions
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
            
            cellView.addTarget(self, action: .didTapCell, forControlEvents: .TouchUpInside)
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
            
            if let player = lineup.players[i] {
                cellView.player = player
            }
        }
    }
    
    func updateCellViews() {
        for (i, cellView) in cellViews.enumerate() {
            if let player = lineup.players[i] {
                cellView.player = player
            }
        }
    }
    
    func positionTextForAbbr(abbr: String) -> String {
        if (abbr == "G") {
            return "Guard"
        } else if (abbr == "F") {
            return "Forward"
        } else if (abbr == "C") {
            return "Center"
        } else if (abbr == "FX"){
            return "Flex Player"
        }
        
        return ""
    }
    
    func didTapCell(cell: LineupEditCellView) {
        let positions = lineup.sport.positions
        let titleText = positionTextForAbbr(positions[cell.index])
        let svc = LineupSearchViewController(titleText: titleText, lineup: lineup, nibName: "LineupSearchViewController", bundle: nil)
        svc.replacingPlayer = cell.player
        svc.updateStats()
        
        svc.draftGroup = lineup.draftGroup
        svc.filterBy = lineup.sport.positionMatches[cell.index]
        svc.playerSelectedAction = { player in
            cell.player = player
            self.lineup.players[cell.index] = player
            self.updateStats()
            self.navController?.popViewController()
        }
        
        navController?.pushViewController(svc)
    }
    
    func updateStats() {
        let playersRemaining = lineup.players.filter {$0 == nil}.count
        statRemSalary = lineup.sport.salary - lineup.salary
        statAvgSalary = (playersRemaining > 0) ? statRemSalary / Double(playersRemaining) : 0
    }
    
    // Temp:
    // Pick an MVP, then double-tap contentView to fill junk lineup
    func fillJunkLineup() {
        if let mvp = lineup.mvp {
            for (i, player) in lineup.players.enumerate() {
                if player === mvp { continue }
                if player != nil { continue }
                let position = lineup.sport.positions[i]
                var draftable = draftGroup.players.filter { $0.salary <= statAvgSalary }
                draftable.sortInPlace { $0.salary > $1.salary }
                if position == "FX" {
                    let rand = Int(arc4random()) % draftable.count
                    lineup.players[i] = draftable[rand]
                } else {
                    lineup.players[i] = draftable.filter { $0.position == position }.first
                }
                updateStats()
            }
            updateCellViews()
            updateStats()
            navController?.updateFooterForViewController(self)
            navController?.titlebar.updateElements()
            navController?.titlebar.transitionElements(.None)
        }
    }
    
    // MARK: - Titlebar datasource methods
    
    func showInvalidModal() {
        var errorMsg = ""
        let playersRemaining = lineup.players.filter {$0 == nil}.count
        
        if playersRemaining > 0 {
            errorMsg = "You must select a player for all positions"
        }
        if statRemSalary < 0 {
            errorMsg = "You overshot your budget"
        }
        
        let vc = ErrorViewController(nibName: "ErrorViewController", bundle: nil)
        let actions = ["Okay"]
        
        vc.actions = actions
        vc.promise.then { index -> Void in
            RootViewController.sharedInstance.popAlertViewController()
        }
        
        RootViewController.sharedInstance.pushAlertViewController(vc)
        vc.titleLabel.text = "FOUL"
        vc.errorLabel.text = errorMsg
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .DisabledValue) {
            showInvalidModal()
        }
        else if (buttonType == .Value) {
            if let mvp = lineup.mvp {
                lineup.name = Data.teamNames[mvp.name] ?? mvp.name + " Stack"
            }
            saveLineupAction?(lineup)
        }
        else if (buttonType == .Close) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String {
        if lineup.name != "" {
            return lineup.name.uppercaseString
        }
        return "New \(lineup.sport.name) Lineup".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Close
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType {
        let playersRemaining = lineup.players.filter {$0 == nil}.count
        
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
        return lineup.draftGroup.start
    }
}

private extension Selector {
    static let fillJunkLineup = #selector(LineupEditViewController.fillJunkLineup)
    static let didTapCell = #selector(LineupEditViewController.didTapCell(_:))
}