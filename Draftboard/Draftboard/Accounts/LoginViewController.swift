//
//  LoginViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 10/30/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LoginViewController: DraftboardModalViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: DraftboardLoadingButton!
    @IBOutlet var passwordField: LabeledField!
    @IBOutlet var loginField: LabeledField!
    
    var logoPosition: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.delegate = self
        loginField.delegate = self
        
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector:Selector("keyboardWillChange:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        defaultCenter.addObserver(self, selector:Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        defaultCenter.addObserver(self, selector:Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        loginButton.addTarget(self, action: Selector("didTapLogin:"), forControlEvents: .TouchUpInside)
        scrollView.scrollEnabled = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func didTapLogin(loginButton: DraftboardLoadingButton) {
        loginComplete()
    }
    
    func loginComplete() {
        loginButton.loading = true
        self.view.userInteractionEnabled = false
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue(),{
                RootViewController.sharedInstance.authComplete()
            })
        }
    }
    
    func keyboardWillChange(notification: NSNotification) {
        let keyboardRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0)
        scrollView.contentOffset = CGPointMake(0, keyboardRect.size.height)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        animateLogo(1.0)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (logoPosition == nil) {
            logoPosition = logoImageView.layer.position
        }

        animateLogo(0.0, offset: -40.0)
    }
    
    func animateLogo(alpha: CGFloat, offset: CGFloat = 0.0) {
        logoImageView.layer.removeAllAnimations()
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.logoImageView.layer.position = CGPointMake(self.logoPosition!.x, self.logoPosition!.y - offset)
            self.logoImageView.alpha = alpha
        }) { (completed) -> Void in
            // nothing
        }
    }
}