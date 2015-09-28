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

//extension UIColor {
//    
//    class func funkyGreen() -> UIColor {
//        return UIColor(photoshopRed: 0, green: 198, blue: 140, alpha: 255)
//    }
//
////    convenience init(photoshopRed red: Int, green: Int, blue: Int, alpha: Int) {
////        
////        let red   = CGFloat(Float(red)/255)
////        let green = CGFloat(Float(green)/255)
////        let blue  = CGFloat(Float(blue)/255)
////        let alpha = CGFloat(Float(alpha)/255)
////        
////        self.init(red:red, green:green, blue: blue, alpha: alpha)
////    }
//
//}

let π:CGFloat = CGFloat(M_PI)

class PieChart: UIView {
    
    var percentComplete: CGFloat = 0.35
    var borderWidth: CGFloat = 5
    var pieMargin: CGFloat = 5
    
    @IBInspectable var baseColor: UIColor = UIColor.moneyDarkBackground()
    @IBInspectable var borderColor: UIColor = UIColor.moneyGray()
    @IBInspectable var pieColor: UIColor = UIColor.moneyBlue()
    @IBInspectable var pieBaseColor: UIColor = UIColor.moneyDarkBlue()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
    }
    
    convenience init(frame: CGRect, border: CGFloat, margin: CGFloat) {
        self.init(frame: frame)
        
        self.borderWidth = border
        self.pieMargin = margin
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
    
    override func drawRect(rect: CGRect) {
        
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
        
        // all circles
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        // BackgroundCircle
        let backgroundCirclePath = UIBezierPath(arcCenter: center,
            radius: radius/2 - borderWidth/2,
            startAngle:floatToRadians(0),
            endAngle: floatToRadians(1),
            clockwise: true)
        backgroundCirclePath.lineWidth = borderWidth
        baseColor.setFill()
        backgroundCirclePath.fill()

        // BorderCircle
        let BorderCirclePath = UIBezierPath(arcCenter: center,
            radius: radius/2 - borderWidth/2,
            startAngle:floatToRadians(0),
            endAngle: floatToRadians(1),
            clockwise: true)
        BorderCirclePath.lineWidth = borderWidth
        borderColor.setStroke()
        BorderCirclePath.stroke()

        // inner circle stuff
        let pieRadius: CGFloat = max(bounds.width-(2*(borderWidth+pieMargin)), bounds.height-(2*(borderWidth+pieMargin)))
        let arcWidth: CGFloat = pieRadius / 2
        
        // BackgroundCircle
        let innerBackgroundCirclePath = UIBezierPath(arcCenter: center,
            radius: arcWidth,
            startAngle:floatToRadians(0),
            endAngle: floatToRadians(1),
            clockwise: true)
        
        innerBackgroundCirclePath.lineWidth = arcWidth
        pieBaseColor.setFill()
        innerBackgroundCirclePath.fill()
        
        // add the pie chart thing
        let startAngle: CGFloat = floatToRadians(0.75)
        let endAngle: CGFloat = percentToEndAngle(startAngle, percent: percentComplete)
        
        let path = UIBezierPath(arcCenter: center,
            radius: pieRadius/2 - arcWidth/2,
            startAngle:startAngle,
            endAngle: endAngle,
            clockwise: false)
        
        path.lineWidth = arcWidth
        pieColor.setStroke()
        path.stroke()
        
    }
    
    // MARK: Overrides ******************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        setupView()
    }
    
}
