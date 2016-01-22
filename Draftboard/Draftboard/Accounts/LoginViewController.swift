//
//  LoginViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 10/30/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class LoginViewController: DraftboardModalViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: DraftboardLoadingButton!
    @IBOutlet var passwordField: LabeledField!
    @IBOutlet var loginField: LabeledField!
    
    var logoPosition: CGPoint?
    var tapGestureRecognizer: UITapGestureRecognizer!
    let (promise, fulfill, reject) = Promise<Void>.pendingPromise()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clearColor()
        
        passwordField.delegate = self
        loginField.delegate = self
        
        tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: Selector("didTap:"))
        tapGestureRecognizer.delegate = self
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector:Selector("keyboardWillChange:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        defaultCenter.addObserver(self, selector:Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        defaultCenter.addObserver(self, selector:Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        loginButton.addTarget(self, action: Selector("didTapLogin:"), forControlEvents: .TouchUpInside)
        loginButton.userInteractionEnabled = false
        loginButton.iconImageView.hidden = true
        loginButton.disabled = true
        
        passwordField.textField.addTarget(self, action: Selector("passwordChanged:"), forControlEvents: .EditingChanged)
        loginField.textField.addTarget(self, action: Selector("loginChanged:"), forControlEvents: .EditingChanged)
        
        scrollView.scrollEnabled = false
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }
        
        return true
    }
    
    func didTap(gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func passwordChanged(textField: UITextField) {
        updateButtonStatus()
    }
    
    func loginChanged(textField: UITextField) {
        updateButtonStatus()
    }
    
    func updateButtonStatus() {
        let validPassword = passwordValid(passwordField.textField.text)
        let validUsername = usernameValid(loginField.textField.text)
        
        if validPassword && validUsername {
            if loginButton.disabled {
                loginButton.userInteractionEnabled = true
                loginButton.iconImageView.hidden = false
                loginButton.disabled = false
            }
        }
        else if !loginButton.disabled {
            loginButton.userInteractionEnabled = false
            loginButton.iconImageView.hidden = true
            loginButton.disabled = true
        }
    }
    
    func passwordValid(password: String?) -> Bool {
        if password == nil {
            return false
        }
        
        let trimmedString = password!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        if trimmedString.characters.count > 0 {
            return true
        }
        
        return false
    }
    
    func usernameValid(username: String?) -> Bool {
        if username == nil {
            return false
        }
        
        let trimmedString = username!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        if trimmedString.characters.count > 0 {
            return true
        }
        
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        login()
        self.loginButton.loading = true
        self.loginButton.userInteractionEnabled = false
        textField.resignFirstResponder()
        return true
    }
    
    func didTapLogin(loginButton: DraftboardLoadingButton) {
        login()
        self.loginButton.loading = true
        self.loginButton.userInteractionEnabled = false
        self.view.endEditing(true)
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
    
    func login() {
        let username = loginField.textField.text ?? ""
        let password = passwordField.textField.text ?? ""
        API.auth(username: username, password: password).then { () -> Void in
            self.fulfill()
            self.leave()
        }.error { error in
            var finalErrorText = "LoginViewController"
            
            if case let URLError.BadResponse(_, data, _) = error,
                let d = data,
                json = try? NSJSONSerialization.JSONObjectWithData(d, options: []) as? NSDictionary,
                errorArray = json?["non_field_errors"] as? [String],
                errorText = errorArray.first
            {
                finalErrorText = errorText
            }
            
            let vc = ErrorViewController(nibName: "ErrorViewController", bundle: nil)
            let actions = ["Reset Password", "Try Again"]

            vc.actions = actions
            vc.promise.then { index -> Void in
                RootViewController.sharedInstance.popAlertViewController()
            }
            
            self.loginButton.userInteractionEnabled = true
            self.loginButton.loading = false

            RootViewController.sharedInstance.pushAlertViewController(vc)
            vc.errorLabel.text = finalErrorText
        }
    }
    
    func cancel() {
        self.reject(APIError.Whatever)
        self.leave()
    }
    
    func leave() {
        RootViewController.sharedInstance.popModalViewController(true)
    }
    
}