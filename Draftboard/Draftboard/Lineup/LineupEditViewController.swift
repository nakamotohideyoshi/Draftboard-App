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
    
    var lineup: Lineup!
    var saveLineupAction: (([Player]) -> Void)?
    var positions = [String]()
    var cellViews = [LineupEmptyCellView]()
    var cellIndex = 0
    
    override func viewDidLoad() {
        view.backgroundColor = .clearColor()
        positions = ["PG", "SG", "SF", "PF", "C", "G", "F", "UTL"]
        layoutCellViews()
        nameTextField.delegate = self
        if lineup == nil {
            lineup = Lineup()
        }
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
        nameTextField.resignFirstResponder()
        
        cellIndex = sender.index
        let svc = LineupSearchViewController(nibName: "LineupSearchViewController", bundle: nil)
        
        svc.playerSelectedAction = {(player: Player) in
            self.navController?.popViewController()
            let cellView = self.cellViews[self.cellIndex]
            cellView.avatarImageView.image = UIImage(named: "sample-avatar")
            cellView.player = player
            
            self.nameTextField.returnKeyType = .Done
            for cell in self.cellViews {
                if cell.player == nil {
                    self.nameTextField.returnKeyType = .Next
                    break
                }
            }
        }
        
        navController?.pushViewController(svc)
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Value) {
            var players = [Player]()
            for cell in cellViews {
                if let player = cell.player {
                    players.append(player)
                } else {
                    print("You can't save an empty lineup")
                    return
                }
            }
            saveLineupAction?(players)
        }
    }
    
    override func titlebarTitle() -> String {
        if nameTextField.text == "My new lineup" {
            return "Create Lineup".uppercaseString
        }
        else if lineup.name == "" {
            return "Create Lineup".uppercaseString
        }
        else {
            return lineup.name.uppercaseString
        }
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

extension LineupEditViewController: UITextFieldDelegate {

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldString = textField.text! as NSString
        if oldString == "My new lineup" {
            lineup.name = ""
        } else {
            lineup.name = oldString.stringByReplacingCharactersInRange(range, withString: string)
        }
        self.navController?.updateTitlebar()
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        for cell in self.cellViews {
            if cell.player == nil {
                self.didTapCell(cell)
                return true
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
}