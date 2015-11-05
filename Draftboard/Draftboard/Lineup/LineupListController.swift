//
//  LineupsListController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupListController: DraftboardViewController, UIActionSheetDelegate {
    
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var createViewButton: DraftboardRoundButton!
    @IBOutlet weak var createImageView: UIImageView!
    @IBOutlet weak var createIconImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    var lineupCardViews : [LineupCardView] = []
    var lastConstraint : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clearColor()
        
        // Create view tap
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapCreateView:")
        self.createView.addGestureRecognizer(tapRecognizer)
        
        // Scroll view
        scrollView.clipsToBounds = false
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
        
        // Create goes on top
        view.bringSubviewToFront(self.createView)
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Plus) {
            createNewLineup()
        }
    }
    
    func didTapCreateView(gestureRecognizer: UITapGestureRecognizer) {
        createNewLineup()
    }
    
    func createNewLineup() {
        let nvc = LineupEditViewController(nibName: "LineupEditViewController", bundle: nil)
        nvc.saveLineupAction = { (lineup: [Player]) in
            self.didSaveLineup(lineup)
            self.navController?.popViewControllerToCardView(self.lineupCardViews.last!, animated: true)
        }
        
        if lineupCardViews.count > 0 {
            navController?.pushViewController(nvc, fromCardView: self.lineupCardViews.last!, animated: true)
        } else {
            navController?.pushViewController(nvc)
        }
    }
    
    func didSaveLineup(lineup: [Player]) {
        self.createView.hidden = true
        addLineup(lineup)
    }
    
    func addLineup(lineup: [Player]) {
        let cardView = LineupCardView()
        cardView.lineup = lineup
        scrollView.addSubview(cardView)
        
        // Set card dimensions
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.widthRancor.constraintEqualToRancor(scrollView.widthRancor).active = true
        cardView.heightRancor.constraintEqualToRancor(scrollView.heightRancor).active = true
        cardView.topRancor.constraintEqualToRancor(scrollView.topRancor).active = true
        
        // Position card horizontally
        if let lastCardView = lineupCardViews.last {
            cardView.leftRancor.constraintEqualToRancor(lastCardView.rightRancor).active = true
        } else {
            cardView.leftRancor.constraintEqualToRancor(scrollView.leftRancor).active = true
        }
        
        // Attach to right edge / end of scrollView
        lastConstraint?.active = false
        lastConstraint = cardView.rightRancor.constraintEqualToRancor(scrollView.rightRancor)
        lastConstraint?.active = true
        
        // Store card
        self.lineupCardViews.append(cardView)
        
        // Scroll to card
        view.layoutIfNeeded()
        scrollView.setContentOffset(cardView.frame.origin, animated: false)
//        cardView.contentView.flashScrollIndicators() // TODO: Maybe someday...
    }
    
    override func titlebarTitle() -> String {
        return "Lineups".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Menu
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType {
        return .Plus
    }
}

// MARK: - UIScrollViewDelegate

extension LineupListController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let pageOffset = Double(scrollView.contentOffset.x / scrollView.frame.size.width)
        let views: [UIView] = (lineupCardViews.count > 0) ? lineupCardViews : [createView]
        
        for (pageIndex, card) in views.enumerate() {
            // Page delta is number of pages from perfect center and can be negative
            let pageDelta = Double(pageIndex) - pageOffset
            // Clamp values from -1.0 to 1.0
            let magnitude = min(Double.abs(pageDelta), 1.0)
            let direction = (pageDelta < 0) ? -1.0 : 1.0
            // Lame attempt to fix a visual glitch in fake carousel rotation
            let m = max(magnitude - 0.05, 0.0) * 1.1
            card.rotate(m * direction)
            card.fade(magnitude)
        }
        
    }
}
