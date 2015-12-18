//
//  PlayerDetailLiveViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 11/18/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class PlayerDetailLiveViewController: DraftboardViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var bottomInfoView: UIView!
    @IBOutlet weak var infoList: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoListDividerHeight: NSLayoutConstraint!
    @IBOutlet weak var statsDividerHeight: NSLayoutConstraint!
    
    var topViewHeightBase = CGFloat()
    
    var player: Player?
    var draftable = false
    
    var playerPoints = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        topViewHeightBase = topViewHeight.constant
        
        topView.backgroundColor = .clearColor()
        infoListDividerHeight.constant = 1 / UIScreen.mainScreen().scale
        statsDividerHeight.constant = infoListDividerHeight.constant
        
        // set the bottom of the scroll
        scrollView.bottomRancor.constraintEqualToRancor(bottomInfoView.bottomRancor).active = true
        
        // temporary player points
        let playerPoints = [
            "Assist",
            "Turnover",
            "Assist",
            "Two pointer",
            "Assist",
            "Two pointer",
            "Three pointer",
            "Two pointer",
        ]
        
        var previousCell: DraftboardDetailListItem?
        
        for (i, point) in playerPoints.enumerate() {
            let playerPointCell = DraftboardDetailListItem()
            
            infoList.addSubview(playerPointCell)
            playerPointCell.leftText.text = point
            playerPointCell.rightText.text = "2PTS"
            
            playerPointCell.leadingRancor.constraintEqualToRancor(infoList.leadingRancor).active = true
            playerPointCell.trailingRancor.constraintEqualToRancor(infoList.trailingRancor).active = true
            
            // we're the first!
            if previousCell == nil {
                playerPointCell.topRancor.constraintEqualToRancor(infoList.topRancor).active = true
            }
            
            // we're not first :(
            if let previous = previousCell {
                playerPointCell.topRancor.constraintEqualToRancor(previous.bottomRancor).active = true
            }
            
            // we're the last… but A(nchor) for effort?
            if i == playerPoints.count - 1 {
                playerPointCell.bottomRancor.constraintEqualToRancor(infoList.bottomRancor).active = true
            }
            
            previousCell = playerPointCell
        }
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Back) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String? {
        return player?.name.uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
    
    override func titlebarBgHidden() -> Bool {
        return false
    }
}

// MARK: - UIScrollViewDelegate
extension PlayerDetailLiveViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            topViewHeight.constant = topViewHeightBase + abs(scrollView.contentOffset.y)
        } else {
            topView.alpha = min(1 - (scrollView.contentOffset.y / 320), 1)
        }
    }
}
