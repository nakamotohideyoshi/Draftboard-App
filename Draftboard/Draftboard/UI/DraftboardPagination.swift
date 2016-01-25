//
//  DraftboardPagination.swift
//  Draftboard
//
//  Created by Wes Pearce on 1/22/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardPagination: UIControl {
    
    var pageViews: [UIView] = []
    var pageContainerView: UIView?
    var tapRecognizer = UITapGestureRecognizer()
    
    var pages: Int = 3 {
        didSet {
            createPages()
        }
    }
    
    var page: Int = -1
    
    func selectPage(p: Int) {
        if (pages <= 0) {
            return
        }
        
        var pg = Int(min(pages-1, p))
        pg = max(0, pg)
        
        if page == pg {
            return
        }
        
        let deselectedColor = UIColor(0xFFFFFF, alpha: 0.4)
        
        for (_, pageView) in pageViews.enumerate() {
            pageView.layer.transform = CATransform3DIdentity;
            pageView.backgroundColor = deselectedColor
            pageView.layer.removeAllAnimations()
        }
        
        let selectedPageView = pageViews[pg]
        selectedPageView.backgroundColor = .whiteColor()
        UIView.animateWithDuration(0.25) { () -> Void in
            selectedPageView.layer.transform = CATransform3DMakeScale(1.0, 3.0, 1.0)
        }
        
        page = pg
    }
    
    func createPages() {
        print(pages)
        
        if (pages <= 0) {
            return
        }
        
        // Layout properties
        let pageWidth: CGFloat = 8.0
        let pageMargin: CGFloat = 3.0
        let containerWidth = CGFloat(pages + 1) * (pageWidth + pageMargin) - pageMargin
        
        // Remove old container
        pageContainerView?.removeFromSuperview()
        pageViews = []
        
        // Create new container
        pageContainerView = UIView()
        addSubview(pageContainerView!)
        
        // Position container
        pageContainerView!.translatesAutoresizingMaskIntoConstraints = false
        pageContainerView!.heightRancor.constraintEqualToRancor(self.heightRancor).active = true
        pageContainerView!.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        pageContainerView!.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
        pageContainerView!.widthRancor.constraintEqualToConstant(containerWidth).active = true
        
        // Lopo through pages
        for _ in 1...pages {
            
            // Create page view
            let pageView = UIView()
            pageView.backgroundColor = UIColor(0xFFFFFF, alpha: 0.4)
            pageContainerView!.addSubview(pageView)
            pageView.translatesAutoresizingMaskIntoConstraints = false
            
            // Position page view
            pageView.centerYRancor.constraintEqualToRancor(pageContainerView!.centerYRancor).active = true
            pageView.widthRancor.constraintEqualToConstant(pageWidth).active = true
            pageView.heightRancor.constraintEqualToConstant(1.0).active = true
            
            // Right of last page
            if let lastPageView = pageViews.last {
                pageView.leftRancor.constraintEqualToRancor(lastPageView.rightRancor, constant: pageMargin).active = true
            }
            else { // Left edge of container
                pageView.leftRancor.constraintEqualToRancor(pageContainerView!.leftRancor).active = true
            }
            
            // Keep page view
            pageViews.append(pageView)
        }
    }
}
