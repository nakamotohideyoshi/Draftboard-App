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

class LineupCardView: DraftboardNibView, LineupCardToggleDelegate {
    
    @IBOutlet weak var clipView: UIView!
    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var statContainerView: UIView!
    @IBOutlet weak var actionContainerView: UIView!
    
    @IBOutlet weak var editButton: DraftboardButton!
    @IBOutlet weak var contestsButton: DraftboardArrowButton!
    @IBOutlet weak var dividerHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonDividerHeight: NSLayoutConstraint!
    @IBOutlet weak var horizontalDivider: UIView!
    @IBOutlet weak var horizontalDividerWidth: NSLayoutConstraint!
    
    @IBOutlet var contestWidth: NSLayoutConstraint!
    @IBOutlet var liveContestWidth: NSLayoutConstraint!
    
    @IBOutlet weak var leftStatContainerView: UIView!
    @IBOutlet weak var centerStatContainerView: UIView!
    @IBOutlet weak var rightStatContainerView: UIView!
    
    var toggleView: LineupCardToggle!
    
    var showPlayerDetailAction: ((Player, isLive: Bool, isDraftable: Bool) -> Void)?
    var editAction: (LineupCardView -> Void)?
    var contestsAction: (LineupCardView -> Void)?
    
    var contentHeight: CGFloat!
    var totalHeight: CGFloat!
    
    var pmrStatView: LineupStatPMRView!
    var liveStatView: LineupStatTimeView!
    var feesStatView: LineupStatFeesView!
    var salaryStatView: LineupStatCurrencyView!
    var winningsStatView: LineupStatView!
    
    var cellViews = [LineupCardCellView]()
    let curtain = UIView()
    
    var loaderView: LoaderView!
    var lineup: Lineup?
    
    var liveTimer: NSTimer!
    var live = false
    
    override func setupNib() {
        feesStatView = LineupStatFeesView(style: .Small, titleText: "FEES", valueText: "$10/4")
        liveStatView = LineupStatTimeView(style: .Small, titleText: "TIME", date: nil)
        salaryStatView = LineupStatCurrencyView(style: .Small, titleText: "REM SALARY", currencyValue: nil)
        pmrStatView = LineupStatPMRView(style: .Small, titleText: "PTS", valueText: "0")
        winningsStatView = LineupStatView(style: .Small, titleText: "WINNINGS", valueText: "$5")
        
        super.setupNib()
    }
    
    override func willAwakeFromNib() {
        contentView.indicatorStyle = .White
        contentView.alwaysBounceVertical = true
        
        contentView.alpha = 0
        contentView.hidden = true
        
        statContainerView.alpha = 0
        statContainerView.hidden = true
        
        actionContainerView.alpha = 0
        actionContainerView.hidden = true
        
        // set dividers to real 1px height
        let onePixel = 1 / UIScreen.mainScreen().scale
        dividerHeight.constant = onePixel
        buttonDividerHeight.constant = onePixel
        horizontalDividerWidth.constant = onePixel
        
        addSubview(curtain)
        curtain.backgroundColor = .blueDarker()
        curtain.translatesAutoresizingMaskIntoConstraints = false
        curtain.topRancor.constraintEqualToRancor(self.topRancor).active = true
        curtain.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        curtain.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        curtain.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
        curtain.userInteractionEnabled = false
        curtain.alpha = 0
        
        liveTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        
        editButton.addTarget(self, action: "didTapEdit", forControlEvents: .TouchUpInside)
        contestsButton.addTarget(self, action: "didTapContests", forControlEvents: .TouchUpInside)
        
        toggleView = LineupCardToggle(options: ["POINTS", "AVG FPPG", "SALARY"])
        toggleView.delegate = self
        contentView.addSubview(toggleView)
        
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        toggleView.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        toggleView.leftRancor.constraintEqualToRancor(self.leftRancor, constant: 20.0).active = true
        toggleView.rightRancor.constraintEqualToRancor(self.rightRancor, constant: -20.0).active = true
        toggleView.heightRancor.constraintEqualToConstant(44.0).active = true
        
        toggleView.selectButton(1)
        
        addStats()
        addLoaderView()
        updateContent()
    }
    
    func didTapToggleButton(index: Int) {
        // TODO: update data display
    }
    
    func updateContent() {
        if let lineup = lineup {
            if lineup.draftGroup.complete {
                self.layoutCellViews()
                self.updateStats()
                self.showContent()
            }
        }
    }
    
    func addLoaderView() {
        loaderView = LoaderView(frame: CGRectZero)
        loaderView.thickness = 2.0
        self.addSubview(loaderView)
        
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.widthRancor.constraintEqualToConstant(42.0).active = true
        loaderView.heightRancor.constraintEqualToConstant(42.0).active = true
        loaderView.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
        loaderView.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        
        loaderView.spinning = true
    }
    
    func showContent(animated: Bool = true) {
        contentView.hidden = false
        statContainerView.hidden = false
        actionContainerView.hidden = false
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.contentView.alpha = 1.0
            self.statContainerView.alpha = 1.0
            self.actionContainerView.alpha = 1.0
            self.loaderView.alpha = 0.0
        }) { (completed) -> Void in
            self.loaderView.hidden = true
        }
    }
    
    func didTapEdit() {
        editAction?(self)
    }
    
    func didTapContests() {
        contestsAction?(self)
    }
    
    func addStats() {
        addStatToContainerView(feesStatView, containerView: leftStatContainerView)
        addStatToContainerView(liveStatView!, containerView: centerStatContainerView)
        addStatToContainerView(salaryStatView, containerView: rightStatContainerView)
    }
    
    func updateStats() {
        if let l = lineup {
            liveStatView.date = l.draftGroup.start
            salaryStatView.currencyValue = l.sport.salary - l.salary
        }
    }
    
    func makeLive() {
        live = true
        
        liveStatView!.removeFromSuperview()
        liveStatView = nil
        
        salaryStatView.removeFromSuperview()
        salaryStatView = nil
        
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
        for cellView in cellViews {
            cellView.removeFromSuperview()
        }
        
        cellViews = [LineupCardCellView]()

        var previousCell: LineupCardCellView?
        let height = cellHeight()
        
        for (i, player) in lineup!.players.enumerate() {
            let cellView = LineupCardCellView()
            cellView.unitLabel.text = ""
            cellView.player = player
            cellView.positionLabel.text = lineup!.sport.positions[i]
            
            contentView.addSubview(cellView)
            cellViews.append(cellView)
            
            cellView.translatesAutoresizingMaskIntoConstraints = false
            cellView.widthRancor.constraintEqualToRancor(contentView.widthRancor).active = true
            cellView.heightRancor.constraintEqualToConstant(height).active = true
            cellView.centerXRancor.constraintEqualToRancor(contentView.centerXRancor).active = true
            
            if (previousCell == nil) {
                cellView.topRancor.constraintEqualToRancor(toggleView.bottomRancor).active = true
            }
            else {
                cellView.topRancor.constraintEqualToRancor(previousCell!.bottomRancor).active = true
            }
            
            if (i == lineup!.players.count - 1) {
                cellView.bottomRancor.constraintEqualToRancor(contentView!.bottomRancor).active = true
            }
            
            cellView.addTarget(self, action: "didTapPlayerCell:", forControlEvents: .TouchUpInside)
            previousCell = cellView
        }
    }
    
    func didTapPlayerCell(playerCell: LineupCardCellView) {
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
    
    func updateTime() {
        if let lineup = lineup {
            let now = NSDate()
            let liveDate = lineup.draftGroup.start
            if (liveDate.earlierDate(now) == liveDate) {
                liveTimer.invalidate()
                liveTimer = nil
                makeLive()
            }
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