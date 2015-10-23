//
//  LineupNewViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupNewViewController: DraftboardViewController {
    @IBOutlet weak var remSalaryLabel: DraftboardLabel!
    @IBOutlet weak var avgSalaryLabel: DraftboardLabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentView: UIScrollView!
    
    weak var listViewController: LineupsListController?
    
    var positions = [String]()
    
    override func viewDidLoad() {
        view.backgroundColor = .clearColor()
        positions = ["PG", "SG", "SF", "PF", "C", "G", "F", "UTL"]
        layoutCellViews()
    }
    
    func didTapEmptyCellView(cellView: LineupEmptyCellView) {
        print(cellView)
    }
    
    func layoutCellViews() {
        var previousCell: LineupEmptyCellView?
        
        for (i, position) in positions.enumerate() {
            let cellView = LineupEmptyCellView()
            cellView.abbrvText = position
            cellView.positionText = ""
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
        }
    }
    
    func didTapCell(sender: LineupEmptyCellView) {
        let svc = LineupSearchViewController(nibName: "LineupSearchViewController", bundle: nil)
        navController?.pushViewController(svc)
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Value) {
            listViewController?.didSaveLineup()
            navController?.popViewController()
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
