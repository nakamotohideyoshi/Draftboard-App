//
//  LineupMoneyPoint.swift
//  Draftboard
//
//  Created by Karl Weber on 9/25/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

//enum pieStatusColor: String {
//    
//    case Red = "Red"
//    case Yellow = "Yellow"
//    case Blue = "Blue"
//
//}

class LineupMoneyPoint: UIView {

    // self.view = outerCircleView
    let circleView = UIView()
    let circleBackground = UIView()
    let pieBackground = UIView()
    let pieView = UIView()
    var pieColor: pieStatusColor = pieStatusColor.Blue
    var pieCompletion: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        let width  = frame.width
        let height = frame.height
        
        circleView.frame = CGRectMake(0,0, width, height)
        circleView.backgroundColor = UIColor.greenColor()
        self.addSubview(circleView)
        circleBackground.frame = CGRectMake(1,1, CGFloat(width - 2), CGFloat(height - 2))
        circleBackground.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(circleBackground)
        pieBackground.frame = CGRectMake(2,2, CGFloat(width - 4), CGFloat(height - 4))
        self.addSubview(pieBackground)
        pieView.frame = CGRectMake(2,2, CGFloat(width - 4), CGFloat(height - 4))
        self.addSubview(pieView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // also init stuff
        
    }
    

}
