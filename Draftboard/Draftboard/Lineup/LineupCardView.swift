//
//  LineupCard.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

protocol LineupCardViewDelegate {
    func didSelectToggleOption(option: LineupCardToggleOption)
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
    
    // Delegate
    var delegate: LineupCardViewDelegate?
    
    // Position in scroll view
    var left: NSLayoutConstraint?
    
    // Views
    var curtainView: UIView!
    var loaderView: LoaderView!
    var toggleView: LineupCardToggle!
    
    // Stats
    var pmrStatView: LineupStatPMRView!
    var liveStatView: LineupStatTimeView!
    var feesStatView: LineupStatFeesView!
    var salaryStatView: LineupStatCurrencyView!
    var winningsStatView: LineupStatView!
    var cellViews = [LineupCardCellView]()
    
    // Actions
    var showPlayerDetailAction: ((Player, isLive: Bool, isDraftable: Bool) -> Void)?
    var editAction: (LineupCardView -> Void)?
    var contestsAction: (LineupCardView -> Void)?
    
    // Live timer
    var liveTimer: NSTimer?
    var live = false
    
    // Data
    var lineup: Lineup?
    let cellCount: Int
    
    init(frame: CGRect, cellCount _cellCount: Int) {
        cellCount = _cellCount
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willAwakeFromNib() {
        
        // Configure content scroll view
        contentView.indicatorStyle = .White
        contentView.alwaysBounceVertical = true
        contentView.delegate = self
        
        // Set divider heights
        let onePixel = 1 / UIScreen.mainScreen().scale
        dividerHeight.constant = onePixel
        buttonDividerHeight.constant = onePixel
        horizontalDividerWidth.constant = onePixel
        
        // Set button actions
        editButton.addTarget(self, action: .didTapEdit, forControlEvents: .TouchUpInside)
        contestsButton.addTarget(self, action: .didTapContests, forControlEvents: .TouchUpInside)
        
        // Create stat views
        feesStatView = LineupStatFeesView(style: .Small, titleText: "FEES", valueText: "$10/4")
        liveStatView = LineupStatTimeView(style: .Small, titleText: "LIVE IN", date: nil)
        salaryStatView = LineupStatCurrencyView(style: .Small, titleText: "REM SALARY", currencyValue: nil)
        pmrStatView = LineupStatPMRView(style: .Small, titleText: "PTS", valueText: "0")
        winningsStatView = LineupStatView(style: .Small, titleText: "WINNINGS", valueText: "$5")
        
        // Create cell toggle
        toggleView = LineupCardToggle(selectedOption: .Salary)
        toggleView.delegate = self
        
        // Create curtain view
        curtainView = UIView()
        curtainView.alpha = 0
        curtainView.userInteractionEnabled = false
        curtainView.backgroundColor = .blueDarker()
        
        // Create loader view
        loaderView = LoaderView(frame: CGRectZero)
        loaderView.thickness = 2.0
        loaderView.spinning = true
        
        // Add subviews
        addSubview(curtainView)
        addSubview(loaderView)
        contentView.addSubview(toggleView)
        leftStatContainerView.addSubview(feesStatView)
        centerStatContainerView.addSubview(liveStatView)
        centerStatContainerView.addSubview(pmrStatView)
        rightStatContainerView.addSubview(salaryStatView)
        rightStatContainerView.addSubview(winningsStatView)
        
        // Constrain subviews
        constrainCurtainView()
        constrainLoaderView()
        constrainToggleView()
        
        constrainStatView(feesStatView)
        constrainStatView(liveStatView)
        constrainStatView(pmrStatView)
        constrainStatView(salaryStatView)
        constrainStatView(winningsStatView)
        
        // Create cell views
        createCellViews()
        showLoader()
    }
    
    func constrainToggleView() {
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        toggleView.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        toggleView.leftRancor.constraintEqualToRancor(self.leftRancor, constant: 20.0).active = true
        toggleView.rightRancor.constraintEqualToRancor(self.rightRancor, constant: -20.0).active = true
        toggleView.heightRancor.constraintEqualToConstant(44.0).active = true
    }
    
    func constrainCurtainView() {
        curtainView.translatesAutoresizingMaskIntoConstraints = false
        curtainView.topRancor.constraintEqualToRancor(self.topRancor).active = true
        curtainView.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        curtainView.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        curtainView.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
    }
    
    func constrainLoaderView() {
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.widthRancor.constraintEqualToConstant(42.0).active = true
        loaderView.heightRancor.constraintEqualToConstant(42.0).active = true
        loaderView.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
        loaderView.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
    }
    
    func constrainStatView(statView: LineupStatView) {
        let sv = statView.superview!
        statView.translatesAutoresizingMaskIntoConstraints = false
        statView.leftRancor.constraintEqualToRancor(sv.leftRancor).active = true
        statView.rightRancor.constraintEqualToRancor(sv.rightRancor).active = true
        statView.topRancor.constraintEqualToRancor(sv.topRancor).active = true
        statView.bottomRancor.constraintEqualToRancor(sv.bottomRancor).active = true
    }
    
    func didSelectToggleOption(option: LineupCardToggleOption) {
        switch option {
            case .Points:
                for (_, cellView) in cellViews.enumerate() {
                    cellView.showPoints()
                }
            
            case .FantasyPoints:
                for (_, cellView) in cellViews.enumerate() {
                    cellView.showFantasyPoints()
                }
            
            case .Salary:
                for (_, cellView) in cellViews.enumerate() {
                    cellView.showSalary()
                }
        }
        
        delegate?.didSelectToggleOption(option)
    }
    
    func showLoader(animated: Bool = true) {
        contentView.hidden = true
        statContainerView.hidden = true
        actionContainerView.hidden = true
        loaderView.hidden = false
    }
    
    func hideLoader(animated: Bool = true) {
        contentView.hidden = false
        statContainerView.hidden = false
        actionContainerView.hidden = false
        loaderView.hidden = true
    }
    
    func showNormalContent() {
        
        // Show date, salary
        liveStatView.hidden = false
        salaryStatView.hidden = false
        
        // Hide PMR, winnings
        pmrStatView.hidden = true
        winningsStatView.hidden = true
        
        // Update constraints
        contestWidth.active = true
        liveContestWidth.active = false
        
        // Hide views
        horizontalDivider.hidden = false
        editButton.hidden = false
        
        // Animate cells
        for (_, cellView) in cellViews.enumerate() {
            cellView.avatarView.PMRView.hidden = true
        }
    }
    
    func showLiveContent(animated: Bool) {
        
        // Hide date, salary
        liveStatView.hidden = true
        salaryStatView.hidden = true
        
        // Show PMR, winnings
        pmrStatView.hidden = false
        winningsStatView.hidden = false
        
        // Update constraints
        contestWidth.active = false
        liveContestWidth.active = true
        
        // Hide views
        horizontalDivider.hidden = true
        editButton.hidden = true
        
        // Animate cells
        for (i, cellView) in cellViews.enumerate() {
            cellView.avatarView.PMRView.setProgress(1.0, animated: animated, delay: Double(i) * 0.1)
            cellView.avatarView.PMRView.hidden = false
        }
        
        // Animate PMR graph
        pmrStatView.graphView.setProgress(1.0)
    }
    
    func createCellViews() {
        let h = UIScreen.mainScreen().bounds.height
        
        for _ in 1...cellCount {
            let cellView = LineupCardCellView()
            cellView.addTarget(self, action: .didTapPlayerCell, forControlEvents: .TouchUpInside)
            contentView.addSubview(cellView)
            
            cellView.translatesAutoresizingMaskIntoConstraints = false
            cellView.widthRancor.constraintEqualToRancor(contentView.widthRancor).active = true
            
            if h > 568 {
                cellView.heightRancor.constraintEqualToRancor(contentView.heightRancor, multiplier: 1.0 / 8.0).active = true
            }
            else if h > 480 {
                cellView.heightRancor.constraintEqualToConstant(45.0).active = true
            }
            else {
                cellView.heightRancor.constraintEqualToConstant(42.0).active = true
            }
            
            cellView.centerXRancor.constraintEqualToRancor(contentView.centerXRancor).active = true
            
            if let lastCellView = cellViews.last {
                cellView.topRancor.constraintEqualToRancor(lastCellView.bottomRancor).active = true
            }
            else {
                cellView.topRancor.constraintEqualToRancor(toggleView.bottomRancor).active = true
            }
            
            cellViews.append(cellView)
        }
        
        // Needed for scroll view content size
        cellViews.last?.bottomRancor.constraintEqualToRancor(contentView!.bottomRancor).active = true
    }
    
    func selectToggleOption(option: LineupCardToggleOption) {
        if toggleView.selectedOption == option {
            return
        }
        
        toggleView.selectOption(option)
        
        if let lineup = lineup {
            for (index, _) in lineup.players.enumerate() {
                let cellView = cellViews[index]
                
                switch option {
                    case .Points:
                        cellView.showPoints()
                    case .FantasyPoints:
                        cellView.showFantasyPoints()
                    case .Salary:
                        cellView.showSalary()
                }
            }
        }
        
        delegate?.didSelectToggleOption(option)
    }
    
    func reloadContent(option: LineupCardToggleOption, updateScrollPos: Bool = true) {
        if let lineup = lineup {
            
            if lineup.draftGroup.start == NSDate.distantPast() {
                showLoader()
                return
            }
            
            for (index, position) in lineup.sport.positions.enumerate() {
                let cellView = cellViews[index]
                cellView.positionLabel.text = position
                cellView.player = lineup.players[index]
                
                switch option {
                    case .Points:
                        cellView.showPoints()
                    case .FantasyPoints:
                        cellView.showFantasyPoints()
                    case .Salary:
                        cellView.showSalary()
                }
            }
            
            //liveTimer?.invalidate()
            //liveTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
            
            liveStatView.date = lineup.draftGroup.start
            salaryStatView.currencyValue = lineup.sport.salary - lineup.salary
            
            if updateScrollPos {
                contentView.contentOffset = lineup.cardScrollPos
            }
            
            toggleView.live = false
            showNormalContent()
            hideLoader()
            
            return
        }
        
        showLoader()
    }
    
    func didTapEdit() {
        editAction?(self)
    }
    
    func didTapContests() {
        contestsAction?(self)
    }
    
    func didTapPlayerCell(playerCell: LineupCardCellView) {
        if let showPlayerDetail = showPlayerDetailAction {
            if playerCell.player == nil {
                return
            }
            
            showPlayerDetail(playerCell.player!, isLive: live, isDraftable: false)
        }
    }
    
    func updateTime() {
        if let lineup = lineup {
            let now = NSDate()
            let liveDate = lineup.draftGroup.start
            if (liveDate.earlierDate(now) == liveDate) {
                liveTimer?.invalidate()
                liveTimer = nil
                
                showLiveContent(true)
                live = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (live) {
            contestWidth.active = false
            liveContestWidth.active = true
        }
    }
}

extension LineupCardView: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if contentView.contentOffset.y > 44.0 {
            lineup?.cardScrollPos = contentView.contentOffset
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
            lcv.curtainView.alpha = CGFloat(amount * 0.8)
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

private extension Selector {
    static let didTapEdit = #selector(LineupCardView.didTapEdit)
    static let didTapContests = #selector(LineupCardView.didTapContests)
    static let didTapPlayerCell = #selector(LineupCardView.didTapPlayerCell(_:))
}