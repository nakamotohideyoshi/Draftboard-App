//
//  LineupCard.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

protocol LineupCardViewDelegate {
    func didTap(buttonType: TabBarButtonType)
}

class LineupCardView: DraftboardNibView {
    
    @IBOutlet weak var editButton: DraftboardButton!
    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var contentViewContainer: UIView!
    @IBOutlet weak var dividerHeight: NSLayoutConstraint!
    @IBOutlet weak var containerDividerHeight: NSLayoutConstraint!
    @IBOutlet weak var pmrGraph: UIView!
    
    @IBOutlet weak var toggleSelector: UIView!
    @IBOutlet weak var pointsBackgroundShape: UIView!
    @IBOutlet weak var averageBackgroundShape: UIView!
    @IBOutlet weak var salaryBackgroundShape: UIView!
    
//    let itemCount = Int(arc4random_uniform(12)) + 1
    let itemCount = 12
    var contentHeight: CGFloat!
    var totalHeight: CGFloat!
    
    let curtain = UIView()
    
    override func willAwakeFromNib() {
        contentView.indicatorStyle = .White
        contentView.alwaysBounceVertical = true

        contentViewContainer.clipsToBounds = true
        contentView.clipsToBounds = false
        
        // set dividers to real 1px height
        let onePixel = 1 / UIScreen.mainScreen().scale
        dividerHeight.constant = onePixel
        containerDividerHeight.constant = onePixel
        
        addSubview(curtain)
        curtain.backgroundColor = UIColor.blueDarker()
        curtain.translatesAutoresizingMaskIntoConstraints = false
        curtain.topRancor.constraintEqualToRancor(self.topRancor).active = true
        curtain.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        curtain.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        curtain.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
        curtain.alpha = 0
        curtain.userInteractionEnabled = false
        
//        UIGraphicsBeginImageContextWithOptions(contentView.bounds.size, true, 1)
//        drawViewHierarchyInRect(contentView.bounds, afterScreenUpdates: true)
//        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        blurImageOverlay.image = screenshot
        
//        layoutCellViews()
    }
    
    var lineup: [Player]? {
        didSet {
            layoutCellViews()
        }
    }
    
    func layoutCellViews() {
        var previousCell: LineupCellView?
        
        var divisor: CGFloat = 5.0
        let screenHeight = UIScreen.mainScreen().bounds.height
        if (screenHeight > 568) {
            divisor = 8.0
        }
        else if (screenHeight > 480.0) {
            divisor = 6.0
        }
        
        for (i, player) in (lineup?.enumerate())! {
            let cellView = LineupCellView()
            cellView.player = player
            contentView.addSubview(cellView)
            
            cellView.translatesAutoresizingMaskIntoConstraints = false
            cellView.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
            cellView.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
            cellView.heightRancor.constraintEqualToRancor(contentView.heightRancor, multiplier: 1.0 / divisor).active = true
            cellView.centerXRancor.constraintEqualToRancor(contentView.centerXRancor).active = true
            
            if (previousCell == nil) {
                cellView.topRancor.constraintEqualToRancor(toggleSelector.bottomRancor).active = true
            }
            else {
                cellView.topRancor.constraintEqualToRancor(previousCell!.bottomRancor).active = true
            }

            if (i == (lineup?.count)! - 1) {
                cellView.bottomRancor.constraintEqualToRancor(contentView!.bottomRancor).active = true
            }
            
            previousCell = cellView
        }
    }

}

// TODO: This should really be restricted to LineupCardView, but the
// create lineup CTA currently shares this behavior
extension UIView {
    
    func fade(amount: Double) {
        self.alpha = 1 // dumb, fix later
        if self.isKindOfClass(LineupCardView) {
            let lcv = self as! LineupCardView
            lcv.curtain.alpha = CGFloat(amount * 0.8)
        }
    }
    
    func rotate(amount: Double) {
        let angle = M_PI_4 // 45 deg
        let rotation = angle * amount
        let direction = (amount < 0) ? -1.0 : 1.0
        let translation = Double(self.bounds.size.width) * 0.5 * direction
        var transform = CATransform3DIdentity
        transform.m34 = -1/500
        transform = CATransform3DTranslate(transform, CGFloat(-translation), 0, 0)
        transform = CATransform3DRotate(transform, CGFloat(rotation), 0, 1, 0)
        transform = CATransform3DTranslate(transform, CGFloat(translation), 0, 0)
        self.layer.transform = transform
    }

}