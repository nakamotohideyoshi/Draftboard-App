//
//  PieChart.swift
//  RedMesa
//
//  Created by Karl Weber on 9/25/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

enum pieStatusColor: String {
    
    case Red = "Red"
    case Yellow = "Yellow"
    case Blue = "Blue"
    
}

let π:CGFloat = CGFloat(M_PI)

class PieChart: UIView {

    var percentComplete: CGFloat = 0.35
    var borderWidth: CGFloat = 5
    var pieMargin: CGFloat = 5
    
    var contentView: UIView = UIView()
    var pieLayer1: CAShapeLayer = CAShapeLayer()
    var pieLayer2: CAShapeLayer = CAShapeLayer()
    var pieLayer3: CAShapeLayer = CAShapeLayer()
    var pieLayer4: CAShapeLayer = CAShapeLayer()

    
    @IBInspectable var baseColor: UIColor = UIColor.lightGrayColor()
    @IBInspectable var borderColor: UIColor = UIColor.greenColor()
    @IBInspectable var pieColor: UIColor = UIColor.blueColor()
    @IBInspectable var pieBaseColor: UIColor = UIColor.yellowColor()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        drawPie()
    }
    
    convenience init(frame: CGRect, border: CGFloat, margin: CGFloat) {
        self.init(frame: frame)
        
        self.borderWidth = border
        self.pieMargin = margin
        drawPie()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawPie()
    }
    
    func drawPie() {
        
        func degreesToRadians(degrees: CGFloat) -> CGFloat {
            // 1 = π/180
            let converted_degrees = degrees * CGFloat(π/180)
            print("converted_degrees: \(degrees) -> \(converted_degrees)")
            return converted_degrees
        }
        
        // 0 to 1
        func floatToRadians(floatNumber: CGFloat) -> CGFloat {
            var result = CGFloat(floatNumber * (2 * π))
            if result > (2*π) {
               result = result - (2*π)
            }
            return result
        }

        func percentToEndAngle(start: CGFloat, percent: CGFloat) -> CGFloat {
            var result = floatToRadians(percent)
            result = start - result
            print("percentToEndAngle: \(result)")
            return result
        }
        
        
        // setup a contentView first
        contentView.removeFromSuperview()
        contentView = UIView(frame: self.bounds)
        self.addSubview(contentView)
        pieLayer1 = CAShapeLayer(layer: layer)
        pieLayer2 = CAShapeLayer(layer: layer)
        pieLayer3 = CAShapeLayer(layer: layer)
        pieLayer4 = CAShapeLayer(layer: layer)
        
        // all circles
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        // BackgroundCircle
        let backgroundCirclePath = UIBezierPath(arcCenter: center,
            radius: radius/2 - borderWidth/2,
            startAngle:floatToRadians(0),
            endAngle: floatToRadians(1),
            clockwise: true)
//        backgroundCirclePath.lineWidth = borderWidth
        pieLayer1.path = backgroundCirclePath.CGPath
        pieLayer1.fillColor = baseColor.CGColor
        
        // BorderCircle
        let borderCirclePath = UIBezierPath(arcCenter: center,
            radius: radius/2 - borderWidth/2,
            startAngle:floatToRadians(0),
            endAngle: floatToRadians(1),
            clockwise: true)
        pieLayer2.path = borderCirclePath.CGPath
        pieLayer2.lineWidth = borderWidth
        pieLayer2.strokeColor = borderColor.CGColor
        
        // inner circle stuff
        let pieRadius: CGFloat = max(bounds.width-(2*(borderWidth+pieMargin)), bounds.height-(2*(borderWidth+pieMargin)))
        let arcWidth: CGFloat = pieRadius / 2
        
        // BackgroundCircle
        let innerBackgroundCirclePath = UIBezierPath(arcCenter: center,
            radius: arcWidth,
            startAngle:floatToRadians(0),
            endAngle: floatToRadians(1),
            clockwise: true)
        pieLayer3.path = innerBackgroundCirclePath.CGPath
        pieLayer3.lineWidth = arcWidth
        pieLayer3.fillColor = pieBaseColor.CGColor
        
        // add the pie chart thing
        let startAngle: CGFloat = floatToRadians(0.75)
        let endAngle: CGFloat = percentToEndAngle(startAngle, percent: percentComplete)
        
        let path = UIBezierPath(arcCenter: center,
            radius: pieRadius/2 - arcWidth/2,
            startAngle:startAngle,
            endAngle: endAngle,
            clockwise: false)
        pieLayer4.path = path.CGPath
        pieLayer4.lineWidth = arcWidth
        pieLayer4.strokeColor = pieColor.CGColor
        

        contentView.layer.addSublayer(pieLayer1)
        contentView.layer.addSublayer(pieLayer2)
        contentView.layer.addSublayer(pieLayer3)
        contentView.layer.addSublayer(pieLayer4)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // also init stuff
    }

}
