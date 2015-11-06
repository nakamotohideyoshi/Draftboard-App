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
    var cancelView: DraftboardModalCancelView!
    var choiceData: [Dictionary<String, String>]!
    var choiceViews: [DraftboardModalItemView]!
    var titleText: String!
    
    init(title: String, choices: [Dictionary<String, String>]) {
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
        
        // Add choices
        self.addChoiceViews()
        
        // Create cancel view
        cancelView = DraftboardModalCancelView()
        view.addSubview(cancelView)

        cancelView.translatesAutoresizingMaskIntoConstraints = false
        cancelView.widthRancor.constraintEqualToConstant(275.0).active = true
        cancelView.heightRancor.constraintEqualToConstant(77.0).active = true
        cancelView.centerXRancor.constraintEqualToRancor(view.centerXRancor).active = true
        cancelView.bottomRancor.constraintEqualToRancor(view.bottomRancor, constant: -30.0).active = true
        
        cancelView.layer.shadowColor = UIColor.blackColor().CGColor
        cancelView.layer.shadowRadius = 10.0
        cancelView.layer.shadowOffset = CGSizeMake(0, 0);
        cancelView.layer.shadowOpacity = 0.5;
        cancelView.layer.masksToBounds = false
        cancelView.layer.shouldRasterize = true
        cancelView.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        cancelView.addTarget(self, action: Selector("didTapCancel:"), forControlEvents: .TouchUpInside)
    }
    
    func didTapCancel(sender: DraftboardModalCancelView) {
        RootViewController.sharedInstance.didCancelModal()
    }
    
    func didTapChoice(sender: DraftboardModalItemView) {
        RootViewController.sharedInstance.didSelectModalChoice(sender.index)
    }
    
    func addChoiceViews() {
        
        // Choice dimensions
        let itemWidth: CGFloat = 275.0
        let itemHeight: CGFloat = 77.0
        
        // Choice views
        var choiceViews = [DraftboardModalItemView]()
        var lastChoiceView: DraftboardModalItemView?
         for (i, data) in choiceData.enumerate() {
            
            // Choice view
            let choiceView = DraftboardModalItemView(title: data["title"]!, subtitle: data["subtitle"]!)
            choiceViews.append(choiceView)
            
            // Add choice to scroll view
            scrollView.addSubview(choiceView)
            choiceView.translatesAutoresizingMaskIntoConstraints = false
            choiceView.widthRancor.constraintEqualToConstant(itemWidth).active = true
            choiceView.heightRancor.constraintEqualToConstant(itemHeight).active = true
            choiceView.centerXRancor.constraintEqualToRancor(scrollView.centerXRancor).active = true
            
            // Constrain to top of scroll view
            if (lastChoiceView == nil) {
                choiceView.topRancor.constraintEqualToRancor(titleLabel?.bottomRancor).active = true
            } else { // Or the top of the last choice
                choiceView.topRancor.constraintEqualToRancor(lastChoiceView!.bottomRancor).active = true
            }
            
            // Constrain to the bottom of the scroll view as well
            if (i == choiceData.count-1) {
                choiceView.bottomRancor.constraintEqualToRancor(scrollView.bottomRancor).active = true
            }
            
            // Add action
            choiceView.addTarget(self, action: Selector("didTapChoice:"), forControlEvents: .TouchUpInside)
            choiceView.index = i
            
            // Store last choice
            lastChoiceView = choiceView
        }
        
        // Center content if shorter than scroll view
        self.view.layoutIfNeeded()
        let titleHeight = titleLabel.bounds.size.height
        let totalHeight = CGFloat(choiceViews.count) * itemHeight + titleHeight + 77.0 + 30.0 + 30.0
        let scrollViewHeight = scrollView.bounds.size.height
        
        // Total height
        if (totalHeight < scrollViewHeight) {
            let heightDelta = scrollViewHeight - totalHeight
            scrollView.contentInset = UIEdgeInsetsMake(heightDelta * 0.5, 0.0, 0.0, 0.0)
            scrollView.delaysContentTouches = false
        } else {
            scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 77.0 + 30.0 + 30.0, 0.0) // 137 is 77 + 30 + 30
            scrollView.contentOffset = CGPointMake(0.0, 0.0)
            
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.scrollView.flashScrollIndicators()
            })
        }
        
        scrollView.alwaysBounceVertical = true
    }
}
