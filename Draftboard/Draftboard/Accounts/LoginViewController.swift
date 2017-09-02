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
    
    @IBOutlet weak var loginContainer: UIView!
    @IBOutlet weak var loginButton: DraftboardLoadingButton!
    @IBOutlet var passwordField: LabeledField!
    @IBOutlet var loginField: LabeledField!
    @IBOutlet weak var rememberSwitch: UISwitch!
    
    @IBOutlet weak var signupContainer: UIView!
    @IBOutlet weak var fullNameField: LabeledField!
    @IBOutlet weak var usernameField: LabeledField!
    @IBOutlet weak var emailField: LabeledField!
    @IBOutlet weak var signupPasswordField: LabeledField!
    @IBOutlet weak var birthField: LabeledField!
    @IBOutlet weak var zipcodeField: LabeledField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var signupButton: DraftboardLoadingButton!
    let segmentedControl = DraftboardSegmentedControl(choices: [], textColor: .greyCool(), textSelectedColor: .greenDraftboard())
    
    var logoPosition: CGPoint?
    var tapGestureRecognizer: UITapGestureRecognizer!
    let (promise, fulfill, reject) = Promise<Void>.pendingPromise()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clearColor()
        
        loginField.delegate = self
        passwordField.delegate = self
        fullNameField.delegate = self
        usernameField.delegate = self
        emailField.delegate = self
        signupPasswordField.delegate = self
        birthField.delegate = self
        zipcodeField.delegate = self
        
        tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: .didTap)
        tapGestureRecognizer.delegate = self
        
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: .keyboardWillChange, name: UIKeyboardWillChangeFrameNotification, object: nil)
        defaultCenter.addObserver(self, selector: .keyboardWillHide, name: UIKeyboardWillHideNotification, object: nil)
        defaultCenter.addObserver(self, selector: .keyboardWillShow, name: UIKeyboardWillShowNotification, object: nil)
        
        loginButton.addTarget(self, action: .didTapLogin, forControlEvents: .TouchUpInside)
        loginButton.userInteractionEnabled = false
        loginButton.iconImageView.hidden = true
        loginButton.disabled = true
        
        passwordField.textField.addTarget(self, action: .passwordChanged, forControlEvents: .EditingChanged)
        passwordField.textField.tag = 12
        loginField.textField.addTarget(self, action: .loginChanged, forControlEvents: .EditingChanged)
        loginField.textField.tag = 11
        
        signupButton.addTarget(self, action: .didTapSignup, forControlEvents: .TouchUpInside)
        signupButton.userInteractionEnabled = false
        signupButton.iconImageView.hidden = true
        signupButton.disabled = true
        
        fullNameField.textField.addTarget(self, action: .fullnameChanged, forControlEvents: .EditingChanged)
        fullNameField.textField.tag = 1
        usernameField.textField.addTarget(self, action: .usernameChanged, forControlEvents: .EditingChanged)
        usernameField.textField.tag = 2
        emailField.textField.addTarget(self, action: .emailChanged, forControlEvents: .EditingChanged)
        emailField.textField.tag = 3
        emailField.textField.keyboardType = .EmailAddress
        signupPasswordField.textField.addTarget(self, action: .signupPasswordChanged, forControlEvents: .EditingChanged)
        signupPasswordField.textField.tag = 4
        birthField.textField.addTarget(self, action: .birthChanged, forControlEvents: .EditingChanged)
        birthField.textField.tag = 5
        birthField.textField.keyboardType = .NumberPad
        birthField.labelType = .Birthday
        zipcodeField.textField.addTarget(self, action: .zipcodeChanged, forControlEvents: .EditingChanged)
        zipcodeField.textField.tag = 6
        zipcodeField.textField.keyboardType = .NumberPad
        zipcodeField.labelType = .Zipcode
        
        signupContainer.hidden = true
        
        logoPosition = logoImageView.layer.position
        
        segmentedControl.choices = ["LOG IN", "SIGN UP"]
        segmentedControl.indexChangedHandler = { [weak self] (_: Int) in self?.changeView() }
        scrollView.addSubview(segmentedControl)
        
        descriptionTextView.dataDetectorTypes = .Link
        descriptionTextView.editable = false
        descriptionTextView.backgroundColor = .clearColor()
        let text = "Clicking \"Create Account\" confirms you’re 18 (19 in NE or Canada, 21 in MA) and agree to our Terms of Service and Privacy Policy."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        let attributes = [
            NSFontAttributeName: UIFont.openSans(size: 10),
            NSForegroundColorAttributeName: UIColor.whiteLowOpacity(),
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        attributedText.addAttributes([NSLinkAttributeName: "https://www.draftboard.com/terms-of-service/"], range: NSMakeRange(93, 16))
        attributedText.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue], range: NSMakeRange(93, 16))
        attributedText.addAttributes([NSLinkAttributeName: "https://www.draftboard.com/privacy-policy/"], range: NSMakeRange(114, 14))
        attributedText.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue], range: NSMakeRange(114, 14))
        descriptionTextView.attributedText = attributedText
        descriptionTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.greenDraftboard()]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let boundsSize = self.view.bounds.size
        let boundsW = boundsSize.width

        let segmentedControlW = boundsW - 80
        let segmentedControlH = CGFloat(50)
        let segmentedControlX = fitToPixel(boundsW / 2 - segmentedControlW / 2)
        let segmentedControlY = (logoPosition?.y)! + logoImageView.bounds.height + 8
        segmentedControl.frame = CGRectMake(segmentedControlX, segmentedControlY, segmentedControlW, segmentedControlH)
    }
    
    func changeView() {
        if (segmentedControl.currentIndex == 0) {
            scrollView.setContentOffset(CGPoint(x:0, y:-scrollView.contentInset.top), animated: true)
            loginContainer.hidden = false
            signupContainer.hidden = true
        } else {
            loginContainer.hidden = true
            signupContainer.hidden = false
        }
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
    
    func fullnameChanged(textField: UITextField) {
        updateSignupButtonStatus()
    }
    
    func usernameChanged(textField: UITextField) {
        updateSignupButtonStatus()
    }
    
    func emailChanged(textField: UITextField) {
        updateSignupButtonStatus()
    }
    
    func signupPasswordChanged(textField: UITextField) {
        updateSignupButtonStatus()
    }
    
    func birthChanged(textField: UITextField) {
        updateSignupButtonStatus()
    }
    
    func zipcodeChanged(textField: UITextField) {
        updateSignupButtonStatus()
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
    
    func updateSignupButtonStatus() {
        let validFullname = fullnameValid(fullNameField.textField.text)
        let validUsername = signupUsernameValid(usernameField.textField.text)
        let validEmail = emailValid(emailField.textField.text)
        let validPassword = signupPasswordValid(signupPasswordField.textField.text)
        let validBirth = birthValid(birthField.textField.text)
        let validZipcode = zipcodeValid(zipcodeField.textField.text)
        
        if validFullname && validUsername && validEmail && validPassword && validBirth && validZipcode {
            if signupButton.disabled {
                signupButton.userInteractionEnabled = true
                signupButton.iconImageView.hidden = false
                signupButton.disabled = false
            }
        }
        else if !signupButton.disabled {
            signupButton.userInteractionEnabled = false
            signupButton.iconImageView.hidden = true
            signupButton.disabled = true
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
    
    func fullnameValid(fullname: String?) -> Bool {
        if fullname == nil {
            return false
        }
        
        let trimmedString = fullname!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        if trimmedString.characters.count > 0 {
            let fullNameArr: [String] = trimmedString.componentsSeparatedByString(" ")
            if fullNameArr.count != 2 {
                return false
            } else {
                return true
            }
        }
        
        return false
    }

    func signupUsernameValid(username: String?) -> Bool {
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
    
    func emailValid(email: String?) -> Bool {
        if email == nil {
            return false
        }
        
        let trimmedString = email!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        if trimmedString.characters.count > 0 {
            return true
        }
        
        return false
    }

    func signupPasswordValid(password: String?) -> Bool {
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
    
    func birthValid(birth: String?) -> Bool {
        if birth == nil {
            return false
        }
        
        let trimmedString = birth!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        if trimmedString.characters.count > 0 {
            let birthdayArr: [String] = trimmedString.componentsSeparatedByString("/")
            if birthdayArr.count != 3 {
                return false
            } else {
                if birthdayArr[0].characters.count == 2 && birthdayArr[1].characters.count == 2 && birthdayArr[2].characters.count == 4 {
                    return true
                } else {
                    return false
                }
            }
        }
        
        return false
    }
    
    func zipcodeValid(zipcode: String?) -> Bool {
        if zipcode == nil {
            return false
        }
        
        let trimmedString = zipcode!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        if trimmedString.characters.count > 0 {
            return true
        }
        
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (segmentedControl.currentIndex == 0) {
            login()
            self.loginButton.loading = true
            self.loginButton.userInteractionEnabled = false
        }
//        } else {
//            signup()
//            self.signupButton.loading = true
//            self.signupButton.userInteractionEnabled = false
//        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func didTapLogin(loginButton: DraftboardLoadingButton) {
        login()
        self.loginButton.loading = true
        self.loginButton.userInteractionEnabled = false
        self.view.endEditing(true)
    }
    
    func didTapSignup(signupButton: DraftboardLoadingButton) {
        signup()
        self.signupButton.loading = true
        self.signupButton.userInteractionEnabled = false
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
        if segmentedControl.currentIndex == 1 {
            var emptyField: UITextField!
            for index in 1...6 {
                let inputField = signupContainer.viewWithTag(index) as! UITextField!
                if inputField.text == "" {
                    emptyField = inputField
                    break
                }
            }
            if emptyField != nil {
                scrollView.setContentOffset(CGPoint(x:0, y:-scrollView.contentInset.top), animated: true)
            } else {
                scrollView.setContentOffset(CGPoint(x:0, y:scrollView.contentSize.height - scrollView.bounds.size.height), animated: true)
            }
        } else {
            scrollView.setContentOffset(CGPoint(x:0, y:-scrollView.contentInset.top), animated: true)
        }
        scrollView.scrollEnabled = true
        animateLogo(1.0)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        scrollView.scrollEnabled = false
        animateLogo(0.0, offset: -40.0)
    }
    
    func animateLogo(alpha: CGFloat, offset: CGFloat = 0.0) {
        logoImageView.layer.removeAllAnimations()
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.logoImageView.layer.position = CGPointMake(self.logoPosition!.x, self.logoPosition!.y - offset)
            self.logoImageView.alpha = alpha
            self.segmentedControl.alpha = alpha
        }) { (completed) -> Void in
            // nothing
        }
    }
    
    func login() {
        let username = loginField.textField.text ?? ""
        let password = passwordField.textField.text ?? ""
        
        API.auth(username: username, password: password, remember: rememberSwitch.on).then { () -> Void in
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
                
                if index == 0 { // Reset password
                    let rvc = ErrorViewController(nibName: "ErrorViewController", bundle: nil)
                    let resetActions = ["Okay"]
                    
                    // TODO: make reset API call
                    
                    rvc.actions = resetActions
                    rvc.promise.then { index -> Void in
                        RootViewController.sharedInstance.popAlertViewController()
                    }
                    
                    RootViewController.sharedInstance.pushAlertViewController(rvc)
                    rvc.titleLabel.text = "RESET PASSWORD"
                    rvc.errorLabel.text = "Check your email for more info on resetting your password."
                }
                else { // Try again
                    RootViewController.sharedInstance.popAlertViewController()
                }
            }
            
            self.loginButton.userInteractionEnabled = true
            self.loginButton.loading = false
            
            RootViewController.sharedInstance.pushAlertViewController(vc)
            vc.errorLabel.text = finalErrorText
        }
    }
    
    func signup() {
        let fullname = fullNameField.textField.text ?? ""
        let fullnameArr = fullname.componentsSeparatedByString(" ")
        let firstname = fullnameArr[0]
        let lastname = fullnameArr[1]
        let username = usernameField.textField.text ?? ""
        let email = emailField.textField.text ?? ""
        let password = signupPasswordField.textField.text ?? ""
        let birthday = birthField.textField.text ?? ""
        let birthdayArr = birthday.componentsSeparatedByString("/")
        let birthYear = birthdayArr[2]
        let birthMonth = birthdayArr[0]
        let birthDay = birthdayArr[1]
        let zipcode = zipcodeField.textField.text ?? ""
        
        API.signup(firstname: firstname, lastname: lastname, username: username, email: email, password: password, birthYear: birthYear, birthMonth: birthMonth, birthDay: birthDay, zipcode: zipcode).then { () -> Void in
            
            let vc = ErrorViewController(nibName: "ErrorViewController", bundle: nil)
            let actions = ["Log In"]
            
            vc.actions = actions
            vc.promise.then { index -> Void in
                // Log In
                RootViewController.sharedInstance.popAlertViewController()
                self.segmentedControl.updateSelectionLine(0, animated: true)
                self.scrollView.setContentOffset(CGPoint(x:0, y:-self.scrollView.contentInset.top), animated: true)
                self.loginContainer.hidden = false
                self.signupContainer.hidden = true
            }
            
            RootViewController.sharedInstance.pushAlertViewController(vc)
            vc.titleLabel.text = "Sign Up"
            vc.errorLabel.text = "Account Created"
        
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
            let actions = ["Try Again"]
            
            vc.actions = actions
            vc.promise.then { index -> Void in
                
                // Try again
                RootViewController.sharedInstance.popAlertViewController()
            }
            
            self.signupButton.userInteractionEnabled = true
            self.signupButton.loading = false
            
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

private extension Selector {
    static let didTap = #selector(LoginViewController.didTap(_:))
    static let keyboardWillChange = #selector(LoginViewController.keyboardWillChange(_:))
    static let keyboardWillHide = #selector(LoginViewController.keyboardWillHide(_:))
    static let keyboardWillShow = #selector(LoginViewController.keyboardWillShow(_:))
    static let didTapLogin = #selector(LoginViewController.didTapLogin(_:))
    static let didTapSignup = #selector(LoginViewController.didTapSignup(_:))
    static let passwordChanged = #selector(LoginViewController.passwordChanged(_:))
    static let loginChanged = #selector(LoginViewController.loginChanged(_:))
    static let fullnameChanged = #selector(LoginViewController.fullnameChanged(_:))
    static let usernameChanged = #selector(LoginViewController.usernameChanged(_:))
    static let emailChanged = #selector(LoginViewController.emailChanged(_:))
    static let signupPasswordChanged = #selector(LoginViewController.signupPasswordChanged(_:))
    static let birthChanged = #selector(LoginViewController.birthChanged(_:))
    static let zipcodeChanged = #selector(LoginViewController.zipcodeChanged(_:))
}
