//
//  DraftboardDetailListItem.swift
//  Draftboard
//
//  Created by Geof Crowl on 11/19/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardDetailListItem: UIView {

    var leftText = UILabel()
    var rightText = UILabel()
    
    var rightArrow = UIImageView()
    var bottomDivider = UIView()
    
    convenience init(showRightArrow: Bool) {
        self.init()
        if showRightArrow {
            rightArrow = UIImageView(image: UIImage(named: "icon-arrow"))
            rightArrow.translatesAutoresizingMaskIntoConstraints = false
            addSubview(rightArrow)
            
            rightArrow.tintColor = .greyCool()
            
            rightArrow.trailingRancor.constraintEqualToRancor(self.trailingRancor, constant: -15).active = true
            rightArrow.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
            rightArrow.heightRancor.constraintEqualToConstant(10).active = true
            rightArrow.widthRancor.constraintEqualToConstant(16).active = true
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.heightRancor.constraintEqualToConstant(40).active = true
        
        leftText.translatesAutoresizingMaskIntoConstraints = false
        rightText.translatesAutoresizingMaskIntoConstraints = false
        bottomDivider.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(leftText)
        addSubview(rightText)
        addSubview(bottomDivider)

        bottomDivider.backgroundColor = .dividerOnWhiteColor()
        
        leftText.font = UIFont.openSansRegular()?.fontWithSize(12)
        rightText.font = UIFont.oswaldRegular()?.fontWithSize(15)
        
        leftText.textColor = UIColor.blueDark()
        rightText.textColor = UIColor.blueDark()
        
        leftText.leadingRancor.constraintEqualToRancor(self.leadingRancor, constant: 15).active = true
        leftText.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
        
        rightText.trailingRancor.constraintEqualToRancor(self.trailingRancor, constant: -15).active = true
        rightText.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
        
        bottomDivider.leadingRancor.constraintEqualToRancor(self.leadingRancor).active = true
        bottomDivider.trailingRancor.constraintEqualToRancor(self.trailingRancor).active = true
        bottomDivider.heightRancor.constraintEqualToConstant(1 / UIScreen.mainScreen().scale).active = true
        bottomDivider.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
