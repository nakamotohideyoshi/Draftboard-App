//
//  AccountModalView.swift
//  Draftboard
//
//  Created by devguru on 9/12/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class AccountModalView: DraftboardView {

    let titleLabel = DraftboardLabel()
    let panelView = UIView()
    let descriptionLabel = DraftboardLabel()
    let okButton = UIButton()
    let logoutButton = UIButton()

    override func setup() {
        addSubviews()
        addConstraints()
        setupSubviews()
    }
    
    func addSubviews() {
        addSubview(titleLabel)
        panelView.addSubview(descriptionLabel)
        panelView.addSubview(okButton)
        panelView.addSubview(logoutButton)
        addSubview(panelView)
    }
    
    func addConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            titleLabel.bottomRancor.constraintEqualToRancor(panelView.topRancor, constant: -50),
            titleLabel.centerXRancor.constraintEqualToRancor(centerXRancor),
            panelView.widthRancor.constraintEqualToRancor(widthRancor, constant: -60),
            panelView.centerXRancor.constraintEqualToRancor(centerXRancor),
            panelView.centerYRancor.constraintEqualToRancor(centerYRancor),
            descriptionLabel.topRancor.constraintEqualToRancor(panelView.topRancor, constant: 55),
            descriptionLabel.centerXRancor.constraintEqualToRancor(panelView.centerXRancor),
            descriptionLabel.widthRancor.constraintEqualToConstant(250),
            descriptionLabel.bottomRancor.constraintEqualToRancor(okButton.topRancor, constant: -55),
            okButton.widthRancor.constraintEqualToRancor(panelView.widthRancor, constant: -30),
            okButton.heightRancor.constraintEqualToConstant(50),
            okButton.centerXRancor.constraintEqualToRancor(panelView.centerXRancor),
            okButton.bottomRancor.constraintEqualToRancor(logoutButton.topRancor, constant: -15),
            logoutButton.widthRancor.constraintEqualToRancor(panelView.widthRancor, constant: -30),
            logoutButton.heightRancor.constraintEqualToConstant(50),
            logoutButton.centerXRancor.constraintEqualToRancor(panelView.centerXRancor),
            logoutButton.bottomRancor.constraintEqualToRancor(panelView.bottomRancor, constant: -15)
        ]
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        panelView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints(viewConstraints)
    }
    
    func setupSubviews() {
        titleLabel.font = .oswald(size: 15)
        titleLabel.textColor = .whiteColor()
        titleLabel.text = "My Account".uppercaseString
        
        descriptionLabel.font = .openSans(size: 14)
        descriptionLabel.textColor = .whiteColor()
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        
        let description = "\(API.username!),\n Please visit Draftboard.com to deposit, withdraw, or manage your account"
        
        let usernameRange = (description as NSString).rangeOfString(API.username!)
        let descAttrString = NSMutableAttributedString(string: description, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.openSans(size: 14)])
        descAttrString.addAttribute(NSFontAttributeName, value: UIFont.openSans(weight: .Bold, size: 14), range: usernameRange)
        descriptionLabel.attributedText = descAttrString
        
        okButton.titleLabel?.font = .openSans(weight: .Semibold, size: 10)
        okButton.titleLabel?.textAlignment = .Center
        okButton.setTitle("Ok".uppercaseString, forState: .Normal)
        okButton.setTitleColor(.whiteColor(), forState: .Normal)
        okButton.backgroundColor = .greenDraftboard()
        okButton.layer.borderWidth = 1
        okButton.layer.borderColor = UIColor.greenDraftboard().CGColor
        
        logoutButton.titleLabel?.font = .openSans(weight: .Semibold, size: 10)
        logoutButton.titleLabel?.textAlignment = .Center
        logoutButton.setTitle("Log out".uppercaseString, forState: .Normal)
        logoutButton.setTitleColor(.whiteColor(), forState: .Normal)
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        
        panelView.backgroundColor = .greyCool()
    }
}
