//
//  ViewController.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/21/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import UIKit
import Foundation

class LoginVC: UIViewController {

    var udacity : [String:String]?

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: SignUpButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configure(username)
        configure(password)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Console printing works")
        username.text = ""
        password.text = ""
        debugTextLabel.text = ""
        setUIEnabled(true)
    }
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        print("Login Button works")
        userDidTaView(self)
        
        if username.text!.isEmpty || password.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty."
        } else {
            setUIEnabled(false)
            let studentLogin = ["username" : username.text!, "password" : password.text!]
            UdacityClient.sharedInstance().logInWithVC(studentLogin as [String : AnyObject]) { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                        print("success at loging in")
                    } else {
                        self.displayError(errorString)
                    }
                }
            }
        }
    }
    
    
    private func completeLogin() {
        debugTextLabel.text = ""
        print("moving to navigation controller now")
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
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }

    
    
}
