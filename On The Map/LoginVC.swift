//
//  ViewController.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/21/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import UIKit
import Foundation
import FBSDKLoginKit

class LoginVC: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configure(username)
        configure(password)
        
        let facebookLogin = FBSDKLoginButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        username.text = ""
        password.text = ""
        setUIEnabled(true)
        
        if let accessToken = FBSDKAccessToken.current() {
            // User is logged in, use 'accessToken' here.
            self.setUIEnabled(false)
            UdacityClient.sharedInstance().accessToken = accessToken
            UdacityClient.sharedInstance().logInWithFacebook() { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        self.postSimpleAlert(errorString!)
                        self.setUIEnabled(true)
                    }
                }
            }
        } else {
            print("no access token retrieved")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let app = UIApplication.shared
        let toOpen = "https://www.udacity.com/account/auth#!/signup"
        if app.canOpenURL(URL(string: toOpen)!) {
            app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
        } else {
            self.postSimpleAlert("Sign up website currently unavailable. Please try again later")
        }
    }
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        userDidTaView(self)
        
        if username.text!.isEmpty || password.text!.isEmpty {
            self.postSimpleAlert("Username or Password Empty.")
        } else {
            setUIEnabled(false)
            let studentLogin = ["username" : username.text!, "password" : password.text!]
            UdacityClient.sharedInstance().logInWithVC(studentLogin as [String : AnyObject]) { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                        print("success at loging in")
                    } else {
                        self.postSimpleAlert(errorString!)
                        self.setUIEnabled(true)
                    }
                }
            }
        }
    }
    
    @IBAction func facebookLoginPressed(_ sender: Any) {
        
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapNavigatorController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
}

extension LoginVC: UITextFieldDelegate {

    func configure(_ textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Arial", size: 18)!]
        textField.textAlignment = NSTextAlignment.left
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTaView(_ sender: AnyObject) {
        resignIfFirstResponder(username)
        resignIfFirstResponder(password)
    }


}

private extension LoginVC {
    
    func setUIEnabled(_ enabled: Bool) {
        username.isEnabled = enabled
        password.isEnabled = enabled
        loginButton.isEnabled = enabled

        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func postSimpleAlert(_ title: String) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
