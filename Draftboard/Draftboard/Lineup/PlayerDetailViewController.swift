//
//  PlayerDetailViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 10/29/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class PlayerDetailViewController: DraftboardViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var bottomInfoView: UIView!
    @IBOutlet weak var infoList: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var draftPlayerBtn: DraftboardArrowButton!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoListDividerHeight: NSLayoutConstraint!
    
    var player: Player?
    var draftable = true
    
    var playerUpdates = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        topView.backgroundColor = .clearColor()
        infoListDividerHeight.constant = 1 / UIScreen.mainScreen().scale
        
        let playerUpdates = [
            "John Lackey beats Royals for ninth win",
            "Matthew Berry dishes out his player advice",
            "McHale firing signals revisions in coach's job",
            "Ford/Pelton: Was Russell right for Lakers?",
            "Drummond best center in the NBA?",
            "Surprising pace leaders",
            "DeRozan's career-best start",
            "Finding fantasy NBA studs with usage rate",
        ]
        
        if draftable == false {
            draftPlayerBtn.removeFromSuperview()
        }
        
        var previousCell: DraftboardDetailListItem?
        
        for (i, update) in playerUpdates.enumerate() {
            let playerUpdateCell = DraftboardDetailListItem(showRightArrow: true)
            
            infoList.addSubview(playerUpdateCell)
            playerUpdateCell.leftText.text = update
            
            playerUpdateCell.leadingRancor.constraintEqualToRancor(infoList.leadingRancor).active = true
            playerUpdateCell.trailingRancor.constraintEqualToRancor(infoList.trailingRancor).active = true
            
            // we're the first!
            if previousCell == nil {
                playerUpdateCell.topRancor.constraintEqualToRancor(infoList.topRancor).active = true
            }
            
            // we're not first :(
            if let previous = previousCell {
                playerUpdateCell.topRancor.constraintEqualToRancor(previous.bottomRancor).active = true
            }
            
            // we're the last… but A(nchor) for effort?
            if i == playerUpdates.count - 1 {
                playerUpdateCell.bottomRancor.constraintEqualToRancor(infoList.bottomRancor).active = true
            }
            
            previousCell = playerUpdateCell
        }
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Back) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String? {
        return player?.name?.uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
    
    override func titlebarBgHidden() -> Bool {
        return false
    }
}

// MARK: - UIScrollViewDelegate
extension PlayerDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView.contentOffset.y < 0) {
            topViewTopConstraint.constant = abs(scrollView.contentOffset.y / 2)
        } else {
            topView.alpha = min(1 - (scrollView.contentOffset.y / 320), 1)
        }
    }
}