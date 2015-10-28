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
        let pieHeight: CGFloat = 20.0
        let pieYOffset = (bounds.height / 2) - (pieHeight / 2)
        let winningWidth = (width / CGFloat(entries)) * CGFloat(winningEntries)
        let leftMargin = width - winningWidth
        let cornerRadius = height / 2
        
        entryBar.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        entryBar.frame = CGRectMake(0, yOffset, width, height)
        entryBar.layer.cornerRadius = cornerRadius
        entryBar.backgroundColor = barColor
        self.addSubview(entryBar)
        
        // Add winning bar
        moneyBar.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        moneyBar.frame = CGRectMake(leftMargin, yOffset, winningWidth, height)
        moneyBar.backgroundColor = moneyBarColor
        moneyBar.layer.cornerRadius = cornerRadius
        self.addSubview(moneyBar)
        
        
        // Add a pie chart
        pieChartOne.frame = CGRectMake(100, pieYOffset, pieHeight, pieHeight)
        pieChartOne.setColors(pieStatusColor.Yellow, inMoney: true)
        self.addSubview(pieChartOne)
        
        /*
            Needs to iterate over a series of entries and place them correctly
            and set their colors correctly.
        */
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
