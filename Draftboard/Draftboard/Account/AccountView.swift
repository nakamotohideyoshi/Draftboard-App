//
//  AccountView.swift
//  Draftboard
//
//  Created by Anson Schall on 9/23/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class AccountView: DraftboardView {
    
    let scrollView = UIScrollView()
    let instructionTextView = UITextView()
    let usernameField = DraftboardLabeledField()
    let logoutButton = DraftboardTextButton()
    
    override func setup() {
        super.setup()
        
        addSubview(scrollView)
        scrollView.addSubview(instructionTextView)
        scrollView.addSubview(usernameField)
        scrollView.addSubview(logoutButton)
        
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = UIColor.blueDarker().colorWithAlphaComponent(0.5)

        instructionTextView.dataDetectorTypes = .Link
        instructionTextView.editable = false
        instructionTextView.backgroundColor = .clearColor()
        let text = "To manage your account settings, request withdrawals, or add funds to your Draftboard account balance, please visit \(API.baseURL)account/settings/."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        let attributes = [
            NSFontAttributeName: UIFont.openSans(size: 10),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        instructionTextView.attributedText = NSAttributedString(string: text, attributes: attributes)
        instructionTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.greenDraftboard()]
        
        usernameField.label.text = "Username".uppercaseString
        usernameField.textField.enabled = false
        
        logoutButton.label.text = "Log Out".uppercaseString
    }
    
    override func layoutSubviews() {
        let boundsW = bounds.size.width
        let boundsH = bounds.size.height
        
        let titleBarH = CGFloat(76)
        let tabBarH = CGFloat(50)
        
        let scrollViewX = CGFloat(0)
        let scrollViewY = titleBarH
        let scrollViewW = boundsW
        let scrollViewH = boundsH - titleBarH - tabBarH
        
        let instructionTextViewSize = instructionTextView.sizeThatFits(CGSizeMake(boundsW - 70, 0))
        let instructionTextViewW = instructionTextViewSize.width
        let instructionTextViewH = instructionTextViewSize.height
        let instructionTextViewX = fitToPixel(boundsW / 2 - instructionTextViewW / 2)
        let instructionTextViewY = CGFloat(35)
        
        let logoutButtonW = boundsW - 70
        let logoutButtonH = CGFloat(50)
        let logoutButtonX = fitToPixel(boundsW / 2 - logoutButtonW / 2)
        let logoutButtonY = scrollViewH - logoutButtonH - 45
        
        let usernameFieldW = boundsW - 70
        let usernameFieldH = CGFloat(50)
        let usernameFieldX = fitToPixel(boundsW / 2 - usernameFieldW / 2)
        let usernameFieldY = logoutButtonY - usernameFieldH - 25

        scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH)
        instructionTextView.frame = CGRectMake(instructionTextViewX, instructionTextViewY, instructionTextViewW, instructionTextViewH)
        usernameField.frame = CGRectMake(usernameFieldX, usernameFieldY, usernameFieldW, usernameFieldH)
        logoutButton.frame = CGRectMake(logoutButtonX, logoutButtonY, logoutButtonW, logoutButtonH)
    }
    
}
