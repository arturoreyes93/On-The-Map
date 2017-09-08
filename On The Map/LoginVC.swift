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
import FBSDKCoreKit

class LoginVC: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configure(username)
        configure(password)
        
        fbLoginButton.delegate = self

        self.activityIndicator.hidesWhenStopped = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        username.text = ""
        password.text = ""
        setUIEnabled(true)
        
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
            performUIUpdatesOnMain {
                self.activityIndicator.startAnimating()
            }
            let studentLogin = ["username" : username.text!, "password" : password.text!]
            UdacityClient.sharedInstance().logInWithVC(studentLogin as [String : AnyObject]) { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                        self.activityIndicator.stopAnimating()
                        print("success at loging in")
                    } else {
                        self.activityIndicator.stopAnimating()
                        self.postSimpleAlert(errorString!)
                        self.setUIEnabled(true)
                    }
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Facebook Login request returned error: \(error!)")
            self.postSimpleAlert("Facebook Login request returned error")
        } else {
            print("Login with Facebook successul")
            if result.grantedPermissions != nil {
                if result.grantedPermissions.contains("email") {
                    print("getting user data")
                    self.getFBUserData()
                }
            }
        }
        
    }
    
    func getFBUserData() {
        
        if let accessToken = FBSDKAccessToken.current().tokenString {
            print("access token: \(accessToken)")
            // User is logged in, use 'accessToken' here.
            self.setUIEnabled(false)
            performUIUpdatesOnMain {
                self.activityIndicator.startAnimating()
            }
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name"]).start { (connection, result, error) in
                if error != nil {
                    print(error!)
                    self.postSimpleAlert("Failed to start graph request")
                } else {
                    print(result!)
                    UdacityClient.sharedInstance().accessToken = accessToken
                    UdacityClient.sharedInstance().logInWithFacebook() { (success, errorString) in
                        performUIUpdatesOnMain {
                            if success {
                                self.completeLogin()
                                self.activityIndicator.stopAnimating()
                            } else {
                                self.activityIndicator.stopAnimating()
                                self.postSimpleAlert(errorString!)
                                self.setUIEnabled(true)
                            }
                        }
                    }
                }
                
            }
            
        } else {
            self.postSimpleAlert("No access token retrieved from Facebook API")
        }
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
        signUpButton.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
}
