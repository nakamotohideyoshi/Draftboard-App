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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentView: UIScrollView!
    
    var saveLineupAction: (() -> Void)?
    var positions = [String]()
    var cellViews = [LineupEmptyCellView]()
    var cellIndex = 0
    
    override func viewDidLoad() {
        view.backgroundColor = .clearColor()
        positions = ["PG", "SG", "SF", "PF", "C", "G", "F", "UTL"]
        layoutCellViews()
    }
    
    func layoutCellViews() {
        var previousCell: LineupEmptyCellView?
        
        for (i, position) in positions.enumerate() {
            let cellView = LineupEmptyCellView()
            cellView.abbrText = position
            cellView.nameText = ""
            cellView.salaryText = ""
            cellView.teamText = ""
                
            contentView.addSubview(cellView)
            
            cellView.translatesAutoresizingMaskIntoConstraints = false
            cellView.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
            cellView.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
            cellView.heightRancor.constraintEqualToRancor(contentView.heightRancor, multiplier: 1.0 / 8.0).active = true
            cellView.centerXRancor.constraintEqualToRancor(contentView.centerXRancor).active = true
            
            cellView.addTarget(self, action: Selector("didTapCell:"), forControlEvents: .TouchUpInside)
            cellView.bottomBorder = true
            
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
    
    func didTapCell(sender: LineupEmptyCellView) {
        cellIndex = sender.index
        let svc = LineupSearchViewController(nibName: "LineupSearchViewController", bundle: nil)
        
        svc.playerSelectedAction = {(player: Player) in
            self.navController?.popViewController()
            let cellView = self.cellViews[self.cellIndex]
            cellView.avatarImageView.image = UIImage(named: "sample-avatar")
            cellView.nameText = "Kevin Korver"
            cellView.salaryText = "$6,000"
            cellView.teamText = " - DET"
        }
        
        navController?.pushViewController(svc)
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Value) {
            saveLineupAction?()
        }
    }
    
    override func titlebarTitle() -> String {
        return "Create Lineup".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Menu
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType {
        return .Value
    }
    
    override func titlebarRightButtonText() -> String? {
        return "Save".uppercaseString
    }
    
    override func titlebarBgHidden() -> Bool {
        return false
    }
}
