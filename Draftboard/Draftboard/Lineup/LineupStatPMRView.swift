//
//  LineupStatView.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupStatPMRView: LineupStatView {
    
    var graphView: CircleProgressView

    override init(style _style: LineupStatStyle, titleText _titleText: String?, valueText _valueText: String?) {
        graphView = CircleProgressView(radius: 14.0, thickness: 3.0, colorFg: .PMRColorFG(), colorBg: .PMRColorBG())
        super.init(style: _style, titleText: _titleText, valueText: _valueText)

        // Constrain graph
        self.addSubview(graphView)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
        graphView.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        graphView.widthRancor.constraintEqualToRancor(self.heightRancor).active = true
        graphView.heightRancor.constraintEqualToRancor(self.heightRancor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        graphView.radius = self.bounds.size.height * 0.75 / 2.0
        graphView.redraw()
    }
}
