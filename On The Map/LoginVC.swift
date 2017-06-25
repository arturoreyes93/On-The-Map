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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Console printing works")
        debugTextLabel.text = ""
    }
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        print("Login Button works")
        userDidTaView(self)
        
        if username.text!.isEmpty || password.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty."
        } else {
            setUIEnabled(false)
            udacity = [username.text!:password.text!]
            getSessionID(username: username.text!, password: password.text!)
            
        }
    }
    
    let logInTextAttributes:[String:Any] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Arial", size: 18)!]
    
    private func getSessionID( username: String, password: String) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        print(request)
        let task = UdacityClient.sharedInstance().session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func displayError(_ error: String, debugLabelText: String? = nil) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.debugTextLabel.text = "Logind Failed (Session ID)."
                }
                
            }
            
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            /* 5. Parse the data */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! NSDictionary as! [String : AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            guard (parsedResult["error"] == nil) else {
                print(parsedResult["error"])
                return
            }
            
            guard let account = parsedResult["account"] as? NSDictionary else {
                print("The account dictionary was not found in the parsed data")
                return
            }
            
            print(parsedResult)
            
            UdacityClient.sharedInstance().userKey = account["key"] as! String
            UdacityClient.sharedInstance().getUserData()
            
        }
        
        task.resume()
        
        
    }
    
    
}

extension LoginVC: UITextFieldDelegate {

    func configure(_ textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = logInTextAttributes
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
    
    
}

