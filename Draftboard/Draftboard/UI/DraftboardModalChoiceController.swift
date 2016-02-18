//
//  DraftboardModalViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/25/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

protocol DraftboardModalChoiceDelegate {
    func didSelectModalChoice(idx: Int)
}

class DraftboardModalChoiceController: DraftboardModalViewController {
    var delegate: DraftboardModalChoiceDelegate?
    var scrollView: UIScrollView!
    var titleLabel: DraftboardLabel!
    var closeButton: DraftboardButton!
    var titleText: String!
    var loaderView: LoaderView!
    
    var choiceData: [NSDictionary]?
    var choiceViews: [DraftboardModalItemView] = []
    
    init(title: String, choices: [NSDictionary]?) {
        super.init(nibName: nil, bundle: nil)
        choiceData = choices
        titleText = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create scroll view
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topRancor.constraintEqualToRancor(view.topRancor, constant: 20.0).active = true
        scrollView.rightRancor.constraintEqualToRancor(view.rightRancor).active = true
        scrollView.bottomRancor.constraintEqualToRancor(view.bottomRancor).active = true
        scrollView.leftRancor.constraintEqualToRancor(view.leftRancor).active = true
        scrollView.indicatorStyle = .White
        
        // Create title label
        titleLabel = DraftboardLabel()
        titleLabel.font = UIFont(name: "Oswald-Regular", size: 15.0)
        titleLabel.textColor = .whiteColor()
        titleLabel.text = titleText.uppercaseString
        
        scrollView.addSubview(titleLabel!)
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topRancor.constraintEqualToRancor(scrollView.topRancor).active = true
        titleLabel.heightRancor.constraintEqualToConstant(50.0).active = true
        titleLabel.centerXRancor.constraintEqualToRancor(scrollView.centerXRancor).active = true
        
        // Create close button
        closeButton = DraftboardButton()
        view.addSubview(closeButton)

        closeButton.bgColor = .clearColor()
        closeButton.bgHighlightColor = .clearColor()
        closeButton.iconHighlightColor = .greenDraftboard()
        closeButton.iconColor = .whiteColor()
        closeButton.textValue = ""
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.leadingRancor.constraintEqualToRancor(view.leadingRancor).active = true
        closeButton.widthRancor.constraintEqualToRancor(view.widthRancor, multiplier: 0.16).active = true
        closeButton.topRancor.constraintEqualToRancor(view.topRancor, constant: 20).active = true
        closeButton.heightRancor.constraintEqualToConstant(56).active = true
        closeButton.iconImageView.image = UIImage(named: "titlebar-icon-close")
        
        closeButton.addTarget(self, action: Selector("didTapCancel:"), forControlEvents: .TouchUpInside)
        
        addLoaderView()
        showLoader(false)
        
        if choiceData != nil {
            reloadChoiceViews()
            hideLoader(false)
        }
    }
    
    func showLoader(animated: Bool = true) {
        loaderView.hidden = false
        scrollView.hidden = true
    }
    
    func hideLoader(animated: Bool = true) {
        loaderView.hidden = true
        scrollView.hidden = false
    }
    
    func didTapCancel(sender: DraftboardButton) {
        RootViewController.sharedInstance.didCancelModal()
    }
    
    func didTapChoice(sender: DraftboardModalItemView) {
        RootViewController.sharedInstance.didSelectModalChoice(sender.index)
    }
    
    func reloadChoiceViews() {
        hideLoader()
        for (_, choiceView) in choiceViews.enumerate() {
            choiceView.removeFromSuperview()
        }
        
        if choiceData == nil {
            return
        }
        
        let data = choiceData!
        let itemWidth: CGFloat = 275.0
        let itemHeight: CGFloat = 77.0
        
        // Choice views
        for (i, data) in data.enumerate() {
            
            // Choice view
            let title = data["title"] as? String ?? ""
            let subtitle = data["subtitle"] as? String ?? ""
            let choiceView = DraftboardModalItemView(title: title, subtitle: subtitle)
            
            // Add choice to scroll view
            scrollView.addSubview(choiceView)
            choiceView.translatesAutoresizingMaskIntoConstraints = false
            choiceView.widthRancor.constraintEqualToConstant(itemWidth).active = true
            choiceView.heightRancor.constraintEqualToConstant(itemHeight).active = true
            choiceView.centerXRancor.constraintEqualToRancor(scrollView.centerXRancor).active = true
            
            // Constrain to last choice
            if let lastChoiceView = choiceViews.last {
                choiceView.topRancor.constraintEqualToRancor(lastChoiceView.bottomRancor).active = true
            }
            else { // First one goes under the title
                choiceView.topRancor.constraintEqualToRancor(titleLabel?.bottomRancor).active = true
            }
            
            // Add action
            choiceView.addTarget(self, action: Selector("didTapChoice:"), forControlEvents: .TouchUpInside)
            choiceView.index = i
            
            // Store last choice
            choiceViews.append(choiceView)
        }
        
        if let lastChoiceView = choiceViews.last {
            lastChoiceView.bottomRancor.constraintEqualToRancor(scrollView.bottomRancor).active = true
        }
        
        self.view.layoutIfNeeded()
        let titleHeight = titleLabel.bounds.size.height
        let totalHeight = CGFloat(choiceViews.count) * itemHeight + (titleHeight * 2)
        let scrollViewHeight = scrollView.bounds.size.height
        
        // Center content if shorter than scroll view
        if (totalHeight < scrollViewHeight) {
            let heightDelta = scrollViewHeight - totalHeight
            scrollView.contentInset = UIEdgeInsetsMake(heightDelta * 0.5, 0.0, 0.0, 0.0)
        }
        
        scrollView.alwaysBounceVertical = true
    }
    
    func addLoaderView() {
        loaderView = LoaderView(frame: CGRectZero)
        loaderView.thickness = 2.0
        view.addSubview(loaderView)
        
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.widthRancor.constraintEqualToConstant(42.0).active = true
        loaderView.heightRancor.constraintEqualToConstant(42.0).active = true
        loaderView.centerYRancor.constraintEqualToRancor(view.centerYRancor).active = true
        loaderView.centerXRancor.constraintEqualToRancor(view.centerXRancor).active = true
        
        loaderView.spinning = true
    }
}
