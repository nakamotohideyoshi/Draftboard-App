//
//  DraftboardModalViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/25/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

enum ModalError: CancellableErrorType {
    case Cancelled
    
    var cancelled: Bool {
        switch self {
            case .Cancelled: return true
        }
    }
}

protocol DraftboardModalChoiceDelegate {
    func didSelectModalChoice(idx: Int)
}

class Choice<T> {
    let title: String
    let subtitle: String?
    let value: T
    
    init(title: String, subtitle: String?, value: T) {
        self.title = title
        self.subtitle = subtitle
        self.value = value
    }
}

class DraftboardModalChoiceController<T>: DraftboardModalViewController {
    var delegate: DraftboardModalChoiceDelegate?
    var scrollView: UIScrollView!
    var titleLabel: DraftboardLabel!
    var closeButton: DraftboardButton!
    var titleText: String!
    var loaderView: LoaderView!
    
    var choiceData: [Choice<T>]? { didSet { reloadChoiceViews() } }
    var choiceViews: [DraftboardModalItemView] = []
    
    let (pendingPromise, fulfill, reject) = Promise<T>.pendingPromise()
    
    init(title: String, choices: [Choice<T>]?) {
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
        
        closeButton.addTarget(self, action: #selector(DraftboardModalChoiceController.didTapCancel(_:)), forControlEvents: .TouchUpInside)
        
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
    
    func promise() -> Promise<T> {
        RootViewController.sharedInstance.pushModalViewController(self)
        return pendingPromise
    }
    
    func didTapCancel(sender: DraftboardButton) {
        RootViewController.sharedInstance.popModalViewController()
        reject(ModalError.Cancelled)
//        RootViewController.sharedInstance.didCancelModal()
    }
    
    func didTapChoice(sender: DraftboardModalItemView) {
        fulfill(choiceData![sender.index].value)
//        RootViewController.sharedInstance.didSelectModalChoice(sender.index)
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
//            let title = data["title"] as? String ?? ""
            let title = data.title
//            let subtitle = data["subtitle"] as? String ?? ""
            let subtitle = data.subtitle ?? ""
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
            choiceView.addTarget(self, action: #selector(DraftboardModalChoiceController.didTapChoice(_:)), forControlEvents: .TouchUpInside)
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

//private extension Selector {
//    static let didTapCancel = #selector(DraftboardModalChoiceController<T>.didTapCancel(_:))
//    static let didTapChoice = #selector(DraftboardModalChoiceController<T>.didTapChoice(_:))
//}