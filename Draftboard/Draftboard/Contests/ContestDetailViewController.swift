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
    @IBOutlet weak var enterContestBtn: DraftboardArrowButton!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundHeightConstraight: NSLayoutConstraint!
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomInfoTopConstraint: NSLayoutConstraint!
    
    var contestName: String?
    var contestEntered = false
    var topViewHeightBase = CGFloat()
    var lineupSelected: Int?
    
    var confirmationModal: ContestConfirmationModal?

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        topViewHeightBase = topViewHeight.constant
        
        scrollView.bottomRancor.constraintEqualToRancor(bottomInfoView.bottomRancor, constant: 40).active = true
        
        let payoutList = [
            "1st place",
            "2nd place",
            "3rd place",
            "4th place",
            "5th place",
            "6th place",
            "7th place",
            "8th place",
            "9th place",
            "10th place",
        ]
        
        var previousCell: DraftboardDetailListItem?
        
        for (i, update) in payoutList.enumerate() {
            let payoutCell = DraftboardDetailListItem(showRightArrow: false)
            
            infoList.addSubview(payoutCell)
            payoutCell.leftText.text = update
            payoutCell.rightText.text = "$1"
            
            payoutCell.leadingRancor.constraintEqualToRancor(infoList.leadingRancor).active = true
            payoutCell.trailingRancor.constraintEqualToRancor(infoList.trailingRancor).active = true
            
            // we're the first!
            if previousCell == nil {
                payoutCell.topRancor.constraintEqualToRancor(infoList.topRancor).active = true
            }
            
            // we're not first :(
            if let previous = previousCell {
                payoutCell.topRancor.constraintEqualToRancor(previous.bottomRancor).active = true
            }
            
            // we're the last… but A(nchor) for effort?
            if i == payoutList.count - 1 {
                payoutCell.bottomRancor.constraintEqualToRancor(infoList.bottomRancor).active = true
            }
            
            previousCell = payoutCell
        }
        
        enterContestBtn.addTarget(self, action: "handleButtonTap:", forControlEvents: .TouchUpInside)
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
    
    // MARK: Handle the tap when someone wants to enter the contest
    // TODO: Actual logic...
    
    func handleButtonTap(sender: DraftboardButton) {
        var choices = [[String: String]]()
        choices.append(["title": "Warriors Stack", "subtitle": "In 3 Contests"])
        choices.append(["title": "Optimal", "subtitle": "In 0 Contests"])
        choices.append(["title": "Bulls Stack", "subtitle": "In 0 Contests"])
        
        let mcc = DraftboardModalChoiceController(title: "Choose an Eligible Lineup", choices: choices)
        RootViewController.sharedInstance.pushModalViewController(mcc)
    }
    
    override func didSelectModalChoice(index: Int) {
        confirmationModal = ContestConfirmationModal(nibName: "ContestConfirmationModal", bundle: nil)
        RootViewController.sharedInstance.pushModalViewController(confirmationModal!)
        confirmationModal!.enterContestButton.addTarget(self, action: "enterContestTap:", forControlEvents: .TouchUpInside)
    }
    
    func enterContestTap(sender: DraftboardButton) {
        confirmationModal?.showSpinner()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue(),{
                self.confirmationModal?.showConfirmed()
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    dispatch_async(dispatch_get_main_queue(),{
                        RootViewController.sharedInstance.popModalViewController()
                        self.didEnterContest()
                    })
                }
            })
        }
    }
    
    func didEnterContest() {
        enterContestBtn.userInteractionEnabled = false
        enterContestBtn.backgroundColor = .greyCool()
        enterContestBtn.label.text = "Contest Entered".uppercaseString
        enterContestBtn.iconImageView.alpha = 0
    }
    
    override func didCancelModal() {
        RootViewController.sharedInstance.popModalViewController()
        lineupSelected = nil
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