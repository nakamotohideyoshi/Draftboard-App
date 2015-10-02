//
//  PieChartViewController.swift
//  RedMesa
//
//  Created by Karl Weber on 9/25/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class PieChartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pie"
        
        self.view.backgroundColor = UIColor.whiteColor()
        
//        let frame = CGRectMake(50, 50, 100, 100)
        let pie1 = PieChart(frame: CGRectMake(150, 50, 50, 50))
        self.view.addSubview(pie1)

        let pie2 = PieChart(frame: CGRectMake(50, 200, 25, 25))
        self.view.addSubview(pie2)
        
        let pie3 = PieChart(frame: CGRectMake(100, 200, 16, 16))
        self.view.addSubview(pie3)
        
        let pie4 = PieChart(frame: CGRectMake(200, 200, 100, 100))
        self.view.addSubview(pie4)
        
//        let π:CGFloat = CGFloat(M_PI)
//        pie.transform = CGAffineTransformMakeRotation(90 * (2 * π))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
