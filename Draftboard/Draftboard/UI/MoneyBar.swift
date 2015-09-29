//
//  MoneyBar.swift
//  Draftboard
//
//  Created by Karl Weber on 9/25/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class MoneyBar: UIView {

    var entryBar = UIView()
    var moneyBar = UIView()
    var pieChartOne = PieChart()
    var entries: Int = 10
    var winningEntries: Int = 3

    @IBInspectable var barColor: UIColor = UIColor.moneyDarkBackground() {
        didSet{
            setupView()
        }
    }
    @IBInspectable var moneyBarColor: UIColor = UIColor.moneyGreen() {
        didSet{
            setupView()
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 4.0 {
        didSet{
            setupView()
        }
    }
    
    override func layoutSubviews() {
        setupView()
    }
    
    private func setupView() {
        
        backgroundColor = .clearColor()
        
        // Setup the stuff
        let width = bounds.width
        let height = bounds.height / 5
        let yOffset = (bounds.height / 2) - (height / 2)
        let winningWidth = (width / CGFloat(entries)) * CGFloat(winningEntries)
        let leftMargin = width - winningWidth
        let cornerRadius = height / 2
        
        entryBar.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        entryBar.frame = CGRectMake(0, yOffset, width, height)
        entryBar.layer.cornerRadius = cornerRadius
        entryBar.backgroundColor = barColor
//        entryBar.removeFromSuperview()
        self.addSubview(entryBar)
        
        // Add winning bar
        moneyBar.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        moneyBar.frame = CGRectMake(leftMargin, yOffset, winningWidth, height)
        moneyBar.backgroundColor = moneyBarColor
        moneyBar.layer.cornerRadius = cornerRadius
//        moneyBar.removeFromSuperview()
        self.addSubview(moneyBar)
        
        
        // Add a pie chart
        pieChartOne.backgroundColor = .blueColor()
        pieChartOne.frame = CGRectMake(30, 0, frame.height, frame.height)
//        pieChartOne.removeFromSuperview()
        self.addSubview(pieChartOne)
    }
    
    
    // MARK: Overrides ******************************************
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }

}
