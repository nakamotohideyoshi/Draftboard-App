//
//  PieChart.swift
//  RedMesa
//
//  Created by Karl Weber on 9/25/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import CoreGraphics

enum pieStatusColor: String {
    
    case Red = "Red"
    case Yellow = "Yellow"
    case Blue = "Blue"

}

let π:CGFloat = CGFloat(M_PI)

@IBDesignable
class PieChart: UIView {
    
    var percentComplete: CGFloat = 0.4
    var borderWidth: CGFloat = 1
    var pieMargin: CGFloat = 2
    
    var contentView: UIView = UIView()
    var pieLayer1: CAShapeLayer = CAShapeLayer()
    var pieLayer2: CAShapeLayer = CAShapeLayer()
    var pieLayer3: CAShapeLayer = CAShapeLayer()
    var pieLayer4: CAShapeLayer = CAShapeLayer()
    
    @IBInspectable var baseColor: UIColor = UIColor.moneyDarkBackground()
    @IBInspectable var borderColor: UIColor = UIColor.moneyGray()
    @IBInspectable var pieBaseColor: UIColor = UIColor.moneyDarkBlue()
    @IBInspectable var pieColor: UIColor = UIColor.moneyBlue()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
//        print("init(frame:) called")
//        print(frame)
        setupViews()
    }
    
    convenience init(frame: CGRect, border: CGFloat, margin: CGFloat) {
        self.init(frame: frame)
        
        self.borderWidth = border
        self.pieMargin = margin
        setupViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupViews()
    }
    
    override func layoutSubviews() {
        setupViews()
    }
    
    func setColors(colors: pieStatusColor, inMoney: Bool) {
    
        switch colors {
        case .Red:
            pieColor = UIColor.moneyRed()
            pieBaseColor = UIColor.moneyDarkRed()
        case .Yellow:
            pieColor = UIColor.moneyYellow()
            pieBaseColor = UIColor.moneyDarkYellow()
        case .Blue:
            pieColor = UIColor.moneyBlue()
            pieColor = UIColor.moneyDarkBlue()
        }
        
        if inMoney == true {
            baseColor = UIColor.moneyBrightBackground()
            borderColor = UIColor.moneyGreen()
        } else {
            baseColor = UIColor.moneyDarkBackground()
            borderColor = UIColor.moneyGray()
        }
    
    }

//    override func drawRect(rect: CGRect) {
//        print("drawRect called")
//        setupViews()   
//    }
    
    override func prepareForInterfaceBuilder() {
//        print("prepareForInterfaceBuilder called")
        setupViews()
    }
    
    func setupViews() {
    
//        print("setupViews called")
//        print("bounds: \(bounds.width) \(bounds.height)")
//        print("frame: \(frame.origin.x), \(frame.origin.y), \(frame.width), \(frame.height)")
        
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
            return result
        }

        layer.masksToBounds = true
        
        // setup a contentView first
        contentView.removeFromSuperview()
        contentView = UIView(frame: self.bounds)
        self.addSubview(contentView)
        pieLayer1 = CAShapeLayer(layer: layer)
        pieLayer2 = CAShapeLayer(layer: layer)
        pieLayer3 = CAShapeLayer(layer: layer)
        
        // all circles
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        // BackgroundCircle
        let backgroundCirclePath = UIBezierPath(arcCenter: center,
            radius: radius/2 - borderWidth/2,
            startAngle:floatToRadians(0),
            endAngle: floatToRadians(1),
            clockwise: true)
        pieLayer1.path = backgroundCirclePath.CGPath
        pieLayer1.fillColor = baseColor.CGColor

        // borderCircle
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
            radius: arcWidth/2 + (arcWidth / 4),
            startAngle:floatToRadians(0),
            endAngle: floatToRadians(1),
            clockwise: true)
//        pieLayer3.fillColor = pieBaseColor.CGColor
        pieLayer3.fillColor = UIColor.clearColor().CGColor
        pieLayer3.strokeColor = pieBaseColor.CGColor
        pieLayer3.lineWidth = arcWidth / 2
        pieLayer3.path = innerBackgroundCirclePath.CGPath

        
        // add the pie chart thing
        pieLayer4 = CAShapeLayer(layer: layer)
        let startAngle: CGFloat = floatToRadians(0.75)
        let endAngle: CGFloat = percentToEndAngle(startAngle, percent: percentComplete)
        
        let path = UIBezierPath(arcCenter: center,
            radius: arcWidth/2 + (arcWidth / 4),
            startAngle:startAngle,
            endAngle: endAngle,
            clockwise: false)
        pieLayer4.fillColor = UIColor.clearColor().CGColor
        pieLayer4.strokeColor = pieColor.CGColor
        pieLayer4.lineWidth = arcWidth / 2
        pieLayer4.path = path.CGPath

        contentView.layer.addSublayer(pieLayer1)
        contentView.layer.addSublayer(pieLayer2)
        contentView.layer.addSublayer(pieLayer3)
        contentView.layer.addSublayer(pieLayer4)
    }
    
}
