//
//  ContestDetailViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 10/27/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailViewController: DraftboardViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomInfoView: UIView!
    @IBOutlet weak var infoList: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundHeightConstraight: NSLayoutConstraint!
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomInfoTopConstraint: NSLayoutConstraint!
    
    var contestName: String?
    var topViewHeightBase = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        topViewHeightBase = topViewHeight.constant
        
        scrollView.bottomRancor.constraintEqualToRancor(bottomInfoView.bottomRancor, constant: 40).active = true
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Back) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String? {
        return contestName?.uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
}

// MARK: - UIScrollViewDelegate
extension ContestDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            topViewHeight.constant = topViewHeightBase + abs(scrollView.contentOffset.y)
        } else {
            topView.alpha = min(1 - (scrollView.contentOffset.y / 320), 1)
        }
        
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