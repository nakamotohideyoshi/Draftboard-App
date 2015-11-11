//
//  LineupStatView.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupStatPMRView: LineupStatView {
    var graphView: CircleProgressView!

    override func setup() {
        super.setup()
    }
    
    override func constrainLabels() {
        super.constrainLabels()
        
        graphView = CircleProgressView(radius: 14.0, thickness: 3.0, colorFg: .PMRColorFG(), colorBg: .PMRColorBG())
        self.addSubview(graphView)
        
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
        graphView.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        graphView.widthRancor.constraintEqualToRancor(self.heightRancor).active = true
        graphView.heightRancor.constraintEqualToRancor(self.heightRancor).active = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        graphView.radius = self.bounds.size.height * 0.75 / 2.0
        graphView.redraw()
    }
}
