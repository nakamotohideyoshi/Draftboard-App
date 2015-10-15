//
//  LineupsListController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/8/15.
//  Copyright (c) 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupsListController: DraftboardViewController, UIActionSheetDelegate {
    
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var createViewButton: DraftboardRoundButton!
    @IBOutlet weak var createImageView: UIImageView!
    @IBOutlet weak var createIconImageView: UIImageView!
    
    var lineupCardViews : [LineupCardView] = []
    var lastConstraint : NSLayoutConstraint?
    var newLineupVc: LineupNewViewController?
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clearColor()
        
        // Create view tap
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapCreateView:")
        self.createView.addGestureRecognizer(tapRecognizer)
        
        // Scroll view
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftRancor.constraintEqualToRancor(view.leftRancor, constant: 20).active = true
        scrollView.rightRancor.constraintEqualToRancor(view.rightRancor, constant: -20).active = true
        scrollView.bottomRancor.constraintEqualToRancor(view.bottomRancor, constant: -20).active = true
        scrollView.topRancor.constraintEqualToRancor(view.topRancor, constant: 20).active = true
        scrollView.clipsToBounds = false
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsHorizontalScrollIndicator = false
        
        // Create goes on top
        view.bringSubviewToFront(self.createView)
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {

        // Test pop
        createView.pop_removeAllAnimations()
        
        /*
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerCornerRadius)
        anim.toValue = 50
        anim.velocity = 500
        anim.springSpeed = 0.5
        anim.springBounciness = 20
        createView.layer.pop_addAnimation(anim, forKey: "test")
        */
        
        if (buttonType == .Plus) {
            createNewLineup()
        }
    }
    
    func didTapCreateView(gestureRecognizer: UITapGestureRecognizer) {
        createNewLineup()
    }
    
    func createNewLineup() {
        let nvc = LineupNewViewController(nibName: "LineupNewViewController", bundle: nil)
        nvc.listViewController = self
        newLineupVc = nvc
        
        navController?.pushViewController(nvc)
    }
    
    func didSaveLineup() {
        self.createView.hidden = true
        addLineup()
    }
    
    func addLineup() {
        let cardView = LineupCardView()
        scrollView.addSubview(cardView)
        
        // Set card dimensions
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.widthRancor.constraintEqualToRancor(scrollView.widthRancor).active = true
        cardView.heightRancor.constraintEqualToRancor(scrollView.heightRancor).active = true
        cardView.topRancor.constraintEqualToRancor(scrollView.topRancor).active = true
        
        // Position card horizontally
        if let lastCardView = lineupCardViews.last {
            cardView.leftRancor.constraintEqualToRancor(lastCardView.rightRancor).active = true
        } else {
            cardView.leftRancor.constraintEqualToRancor(scrollView.leftRancor).active = true
        }
        
        // Attach to right edge / end of scrollView
        lastConstraint?.active = false
        lastConstraint = cardView.rightRancor.constraintEqualToRancor(scrollView.rightRancor)
        lastConstraint?.active = true
        
        // Store card
        self.lineupCardViews.append(cardView)
        
        // Scroll to card
        view.layoutIfNeeded()
        scrollView.setContentOffset(cardView.frame.origin, animated: false)
    }
    
    override func titlebarTitle() -> String {
        return "Lineups".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Menu
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType {
        return .Plus
    }
}

extension LineupsListController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = Double(scrollView.contentOffset.x / scrollView.frame.size.width)
        let pageIndex = Int(floor(page))
        let pageFraction = page - floor(page)
        
        for (i, card) in lineupCardViews.enumerate() {
            
            var alpha: CGFloat = 0.25
            var transform: CATransform3D = CATransform3DIdentity
            
            // Alpha
            if i == pageIndex {
                alpha = CGFloat(1.0 - (pageFraction * 0.75))
            } else if i == pageIndex + 1 {
                alpha = CGFloat(0.25 + (pageFraction * 0.75))
            }
            
            // Transform
            transform.m34 = -1/500
            let direction = (i <= pageIndex) ? -1.0 : 1.0
            var rotation = CGFloat(M_PI_4 * 0.5 * direction)
            let translation = card.bounds.size.width / 2 * CGFloat(direction)
            if i == pageIndex {
                rotation *= CGFloat(pageFraction)
            } else if i == pageIndex + 1 {
                rotation *= CGFloat(1 - pageFraction)
            }
            transform = CATransform3DTranslate(transform, -translation, 0, 0)
            transform = CATransform3DRotate(transform, rotation, 0, 1, 0)
            transform = CATransform3DTranslate(transform, translation, 0, 0)
            
            card.alpha = alpha
            card.layer.transform = transform
        }
    }
}
