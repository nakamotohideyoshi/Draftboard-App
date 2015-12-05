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
    
    @IBOutlet weak var clipView: UIView!
    @IBOutlet weak var contentView: UIScrollView!
    
    @IBOutlet weak var editButton: DraftboardButton!
    @IBOutlet weak var dividerHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonDividerHeight: NSLayoutConstraint!
    @IBOutlet weak var horizontalDivider: UIView!
    @IBOutlet weak var horizontalDividerWidth: NSLayoutConstraint!
    
    @IBOutlet var contestWidth: NSLayoutConstraint!
    @IBOutlet var liveContestWidth: NSLayoutConstraint!
    
    @IBOutlet weak var toggleSelectorView: UIView!
    @IBOutlet weak var toggleHeight: NSLayoutConstraint!
//    @IBOutlet weak var pointsBackgroundShape: UIView!
//    @IBOutlet weak var averageBackgroundShape: UIView!
//    @IBOutlet weak var salaryBackgroundShape: UIView!
    
    @IBOutlet weak var leftStatContainerView: UIView!
    @IBOutlet weak var centerStatContainerView: UIView!
    @IBOutlet weak var rightStatContainerView: UIView!
    
    var showPlayerDetailAction: ((Player, isLive: Bool, isDraftable: Bool) -> Void)?
    
    var contentHeight: CGFloat!
    var totalHeight: CGFloat!
    
    var pmrStatView: LineupStatPMRView!
    var liveStatView: LineupStatTimeView!
    var feesStatView: LineupStatFeesView!
    var salaryStatView: LineupStatView!
    var winningsStatView: LineupStatView!
    
    var cellViews = [LineupCellView]()
    let curtain = UIView()
    
    var liveDate: NSDate!
    var liveTimer: NSTimer!
    var live = false
    
    override func willAwakeFromNib() {
        contentView.indicatorStyle = .White
        contentView.alwaysBounceVertical = true
        
        // set dividers to real 1px height
        let onePixel = 1 / UIScreen.mainScreen().scale
        dividerHeight.constant = onePixel
        buttonDividerHeight.constant = onePixel
        horizontalDividerWidth.constant = onePixel
        
        toggleHeight.constant = 0.0
        toggleSelectorView.clipsToBounds = true
        
        addSubview(curtain)
        curtain.backgroundColor = .blueDarker()
        curtain.translatesAutoresizingMaskIntoConstraints = false
        curtain.topRancor.constraintEqualToRancor(self.topRancor).active = true
        curtain.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        curtain.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        curtain.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
        curtain.userInteractionEnabled = false
        curtain.alpha = 0
        
        createStats()
        startTimer()
    }
    
    func startTimer() {
        let now = NSDate()
        let cal = NSCalendar.currentCalendar()
        liveDate = cal.dateByAddingUnit(.Second, value: 15, toDate: now, options: [])
        liveTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime:"), userInfo: nil, repeats: true)
        updateTime(liveTimer)
    }
    
    func createStats() {
        feesStatView = LineupStatFeesView(titleText: "Fees", valueText: "$10/4")
        liveStatView = LineupStatTimeView(titleText: "Time", valueText: "00:00:00")
        salaryStatView = LineupStatView(titleText: "Salary Rem.", valueText: "$10,000")
        pmrStatView = LineupStatPMRView(titleText: "Pts", valueText: "0")
        winningsStatView = LineupStatView(titleText: "Winnings", valueText: "$5.00")
        
        addStatToContainerView(feesStatView, containerView: leftStatContainerView)
        addStatToContainerView(liveStatView, containerView: centerStatContainerView)
        addStatToContainerView(salaryStatView, containerView: rightStatContainerView)
    }
    
    func makeLive() {
        live = true
        
//        feesStatView.removeFromSuperview()
        liveStatView.removeFromSuperview()
        salaryStatView.removeFromSuperview()
        
        addStatToContainerView(pmrStatView, containerView: centerStatContainerView)
        addStatToContainerView(winningsStatView, containerView: rightStatContainerView)
        
        for (i, cellView) in cellViews.enumerate() {
            cellView.avatarView.PMRView.setProgress(1.0, animated: true, delay: Double(i) * 0.1)
            cellView.avatarView.PMRView.hidden = false
            cellView.rightLabel.text = "0"
            cellView.unitLabel.text = "PTS"
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue(),{
                self.pmrStatView.graphView.setProgress(1.0)
            })
        }
        
        contestWidth.active = false
        liveContestWidth.active = true
        
        horizontalDivider.removeFromSuperview()
        editButton.removeFromSuperview()
    }
    
    func addStatToContainerView(statView: LineupStatView, containerView: UIView) {
        containerView.addSubview(statView)
        statView.translatesAutoresizingMaskIntoConstraints = false
        statView.leftRancor.constraintEqualToRancor(containerView.leftRancor).active = true
        statView.rightRancor.constraintEqualToRancor(containerView.rightRancor).active = true
        statView.topRancor.constraintEqualToRancor(containerView.topRancor).active = true
        statView.bottomRancor.constraintEqualToRancor(containerView.bottomRancor).active = true
    }
    
    var lineup: [Player]? {
        didSet {
            self.layoutCellViews()
        }
    }
    
    func cellHeight() -> CGFloat {
        let h = UIScreen.mainScreen().bounds.height
        
        if (h > 568) { // 6, 6S, 6+, 6S+
            return 51.0
        } else if (h > 480.0) { // 5, 5C, 5S
            return 45.0
        } else { // 4, 4S
            return 42.0
        }
    }
    
    func layoutCellViews() {
        guard let theLineup = lineup else {
            return
        }
        
        var previousCell: LineupCellView?
        let height = cellHeight()
        
        for (i, player) in theLineup.enumerate() {
            let cellView = LineupCellView()
            cellView.unitLabel.text = ""
            cellView.player = player
            
            contentView.addSubview(cellView)
            cellViews.append(cellView)
            
            cellView.translatesAutoresizingMaskIntoConstraints = false
            cellView.widthRancor.constraintEqualToRancor(contentView.widthRancor).active = true
            cellView.heightRancor.constraintEqualToConstant(height).active = true
            cellView.centerXRancor.constraintEqualToRancor(contentView.centerXRancor).active = true
            
            if (previousCell == nil) {
                cellView.topRancor.constraintEqualToRancor(toggleSelectorView.bottomRancor).active = true
            }
            else {
                cellView.topRancor.constraintEqualToRancor(previousCell!.bottomRancor).active = true
            }
            
            if (i == theLineup.count - 1) {
                cellView.bottomRancor.constraintEqualToRancor(contentView!.bottomRancor).active = true
            }
            
            cellView.addTarget(self, action: "didTapPlayerCell:", forControlEvents: .TouchUpInside)
            previousCell = cellView
        }
    }
    
    func didTapPlayerCell(playerCell: LineupCellView) {
        if let showPlayerDetail = showPlayerDetailAction {
            if playerCell.player == nil {
                return
            }
            showPlayerDetail(playerCell.player!, isLive: live, isDraftable: false)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (live) {
            contestWidth.active = false
            liveContestWidth.active = true
        }
    }
    
    func updateTime(timer: NSTimer) {
        let now = NSDate()
        if (liveDate.earlierDate(now) == liveDate) {
            liveTimer.invalidate()
            makeLive()
        }
        else {
            let cal = NSCalendar.currentCalendar()
            let components = cal.components(
                [.Hour, .Minute, .Second],
                fromDate: now,
                toDate: liveDate,
                options: []
            )
            
            liveStatView.text = String(format: "%02d:%02d:%02d", components.hour, components.minute, components.second)
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