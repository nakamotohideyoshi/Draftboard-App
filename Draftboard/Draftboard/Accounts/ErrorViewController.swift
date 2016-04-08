//
//  LoginViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 10/30/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class ErrorViewController: DraftboardModalViewController {

    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: DraftboardLabel!
    @IBOutlet weak var titleLabel: DraftboardLabel!
    @IBOutlet weak var errorViewCenter: NSLayoutConstraint!
    @IBOutlet weak var lineHeight: NSLayoutConstraint!
    
    let (promise, fulfill, reject) = Promise<Int>.pendingPromise()
    var actions: [String]?
    var buttons: [DraftboardButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clearColor()
        let onePixel = 1 / UIScreen.mainScreen().scale
        lineHeight.constant = onePixel
        
        buttons = [DraftboardButton]()
        if let actions = actions {
            var lastAction: DraftboardButton?
            for (i, buttonText) in actions.enumerate() {
                
                // Create button
                let button = DraftboardButton()
                button.textValue = buttonText.uppercaseString
                button.addTarget(self, action: .didTapAction, forControlEvents: .TouchUpInside)
                
                // Style button
                button.textBold = true;
                if (i < actions.count - 1) {
                    button.bgColor = .whiteColor()
                    button.bgHighlightColor = .greenDraftboard()
                    button.textColor = .greyCool()
                }
                
                // Constrain button
                view.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.widthRancor.constraintEqualToRancor(errorView.widthRancor).active = true
                button.heightRancor.constraintEqualToConstant(50.0).active = true
                button.centerXRancor.constraintEqualToRancor(view.centerXRancor).active = true
                
                if lastAction == nil {
                    button.topRancor.constraintEqualToRancor(errorView.bottomRancor).active = true
                }
                else {
                    button.topRancor.constraintEqualToRancor(lastAction?.bottomRancor).active = true
                }
                
                // Adjust error center
                errorViewCenter.constant -= 25.0
                
                // Keep button
                buttons.append(button)
                lastAction = button
            }
        }
    }
    
    func didTapAction(button: DraftboardButton) {
        let x = buttons.indexOf{$0 === button}
        fulfill(x!)
    }
}

private extension Selector {
    static let didTapAction = #selector(ErrorViewController.didTapAction(_:))
}