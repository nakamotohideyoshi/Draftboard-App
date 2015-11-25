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
    
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomInfoTopConstraint: NSLayoutConstraint!
    
    var topViewHeightBase = CGFloat()
    
    var player: Player?
    var draftable = true
    
    var playerUpdates = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        topViewHeightBase = topViewHeight.constant
        
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
        if player == nil {
            return "Kyle Korver".uppercaseString
        }
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
//        if(scrollView.contentOffset.y < 0) {
//            topViewTopConstraint.constant = abs(scrollView.contentOffset.y / 2)
//        } else {
//            topView.alpha = min(1 - (scrollView.contentOffset.y / 320), 1)
//        }
        if scrollView.contentOffset.y < 0 {
            topViewHeight.constant = topViewHeightBase + abs(scrollView.contentOffset.y)
        } else {
            topView.alpha = min(1 - (scrollView.contentOffset.y / 320), 1)
        }
        
        if draftable {
            if scrollView.contentOffset.y > topViewHeightBase - 24 {
                buttonTopConstraint.constant = -(scrollView.contentOffset.y - bottomInfoTopConstraint.constant)
                
                self.view.layoutIfNeeded()
                buttonLeadingConstraint.constant = 0
                buttonTrailingConstraint.constant = 0
                UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            } else {
                buttonTopConstraint.constant = 24
                
                self.view.layoutIfNeeded()
                buttonLeadingConstraint.constant = 45
                buttonTrailingConstraint.constant = -45
                UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
}