//
//  ContestLiveDetailViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 11/9/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestConfirmationModal: DraftboardModalViewController {
    
    @IBOutlet weak var titleView: DraftboardLabel!
    @IBOutlet weak var confirmIcon: UIImageView!
    @IBOutlet weak var enterContestButton: DraftboardArrowButton!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var loaderLabel: DraftboardLabel!
    @IBOutlet weak var loaderContainerView: UIView!
    
    var spring: Spring?
    var closeButton: DraftboardButton!
    var loaderView: LoaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clearColor()
        confirmIcon.tintColor = .whiteColor()
        
        closeButton = createCloseButton()
        closeButton.addTarget(self, action: Selector("didTapCancel:"), forControlEvents: .TouchUpInside)
    }
    
    func createCloseButton() -> DraftboardButton {
        let button = DraftboardButton()
        
        button.bgColor = .clearColor()
        button.bgHighlightColor = .clearColor()
        button.iconImageView.image = UIImage(named: "titlebar-icon-close")
        button.iconHighlightColor = .greenDraftboard()
        button.iconColor = .whiteColor()
        button.textValue = ""
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingRancor.constraintEqualToRancor(view.leadingRancor).active = true
        button.widthRancor.constraintEqualToRancor(view.widthRancor, multiplier: 0.16).active = true
        button.topRancor.constraintEqualToRancor(view.topRancor, constant: 20).active = true
        button.heightRancor.constraintEqualToConstant(56).active = true
        
        return button
    }
    
    func showSpinner() {
        if (loaderView == nil) {
            let loaderSize = loaderContainerView.bounds
            loaderView = LoaderView(frame: CGRectMake(0, 0, loaderSize.width, loaderSize.height))
            loaderContainerView.addSubview(loaderView)
        }
        
        titleView.hidden = true
        contentView.hidden = true
        closeButton.hidden = true
        
        loaderLabel.hidden = false
        loaderContainerView.hidden = false
        loaderView.spinning = true
    }
    
    func didTapCancel(sender: DraftboardButton) {
        RootViewController.sharedInstance.didCancelModal()
    }
    
    func bounceIn(view: UIView) {
        spring?.cancel()
        spring = nil
        
        let endScale: CGFloat = 1.0
        let startScale: CGFloat = 0.5
        let deltaScale: CGFloat = endScale - startScale
        
        spring = Spring(stiffness: 3.0, damping: 0.6, velocity: 0.0)
        spring!.updateBlock = { (value) -> Void in
            let scale = startScale + (deltaScale * value)
            view.layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
        }
        
        view.layer.transform = CATransform3DMakeScale(startScale, startScale, 1.0)
        spring!.start()
    }
    
    func showConfirmed() {
        loaderLabel.text = "Contest Entered!".uppercaseString
        loaderView.hidden = true
        confirmIcon.hidden = false
        self.bounceIn(confirmIcon)
    }
}