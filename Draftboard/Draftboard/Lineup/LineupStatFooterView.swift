//
//  LineupStatFooterView.swift
//  Draftboard
//
//  Created by Wes Pearce on 12/8/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

protocol StatFooterDataSource {
    func footerStatAvgSalary() -> Double?
    func footerStatRemSalary() -> Double?
    func footerStatLiveInDate() -> NSDate?
}

class LineupStatFooterView: DraftboardFooterView {
    var liveInView: LineupStatTimeView!
    var remSalaryView: LineupStatCurrencyView!
    var avgPlayerView: LineupStatCurrencyView!
    
    var dataSource: StatFooterDataSource?
    var statViews: [LineupStatView]!
    
    let dividerView = UIView()
    
    init(dataSource _dataSource: StatFooterDataSource?) {
        super.init(frame: CGRectZero)
        self.backgroundColor = .footerViewColor()
        dataSource = _dataSource
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        // One pixel divider on top
        addSubview(dividerView)
        dividerView.backgroundColor = .whiteLowestOpacity()
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.topRancor.constraintEqualToRancor(self.topRancor).active = true
        dividerView.leftRancor.constraintEqualToRancor(self.leftRancor, constant: 15.0).active = true
        dividerView.rightRancor.constraintEqualToRancor(self.rightRancor, constant: -15.0).active = true
        dividerView.heightRancor.constraintEqualToConstant(App.screenPixel).active = true
        
        // Stat views
        liveInView = LineupStatTimeView(style: .Large, titleText: "LIVE IN", date: dataSource?.footerStatLiveInDate())
        remSalaryView = LineupStatCurrencyView(style: .Large, titleText: "REM SALARY", currencyValue: dataSource?.footerStatRemSalary())
        avgPlayerView = LineupStatCurrencyView(style: .Large, titleText: "REM PER", currencyValue: dataSource?.footerStatAvgSalary())
        
        // Layout stat views
        statViews = [liveInView, remSalaryView, avgPlayerView]
        layoutStatViews()
    }
    
    func reloadData() {
        if let ds = dataSource {
            liveInView.date = ds.footerStatLiveInDate()
            remSalaryView.currencyValue = ds.footerStatRemSalary()
            avgPlayerView.currencyValue = ds.footerStatAvgSalary()
        }
    }
    
    func layoutStatViews() {
        let widthMultiplier = 1.0 / CGFloat(statViews.count)
        
        var lastStatView: LineupStatView?
        for (_, statView) in statViews.enumerate() {
            self.addSubview(statView)
            
            statView.translatesAutoresizingMaskIntoConstraints = false
            statView.topRancor.constraintEqualToRancor(self.topRancor).active = true
            statView.widthRancor.constraintEqualToRancor(self.widthRancor, multiplier: widthMultiplier).active = true
            statView.heightRancor.constraintEqualToRancor(self.heightRancor).active = true
            
            if (lastStatView == nil) {
                statView.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
            }
            else {
                statView.leftRancor.constraintEqualToRancor(lastStatView?.rightRancor).active = true
            }
            
            lastStatView = statView
        }
    }
}