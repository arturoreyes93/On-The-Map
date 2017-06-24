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
    
    var appDelegate: AppDelegate!
    var udacity : [String:String]?

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var signUpButton: SignUpButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        configure(username)
        configure(password)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        if username.text!.isEmpty || password.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty."
        } else {
            udacity = [username.text!:password.text!]
            
        }
    }
    
    let logInTextAttributes:[String:Any] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Arial", size: 18)!]
    
    private func getSessionID( username: String, password: String) {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)

        
        
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

