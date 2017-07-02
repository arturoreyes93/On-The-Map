//
//  UdacityClient.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/23/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    var session = URLSession.shared
    
    var userKey: String?
    var firstName: String?
    var lastName: String?
    
    override init() {
        super.init()
    }
    
    func logInWithVC(_ userLogin : [String: String], completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        self.postSessionID(userLogin) { (success, errorString) in
            if success {
                self.getUserData() { (success, errorString) in
                    if success {
                        print("success")
                    }
                    completionHandlerForLogin(success, errorString)
                }
    
            } else {
                completionHandlerForLogin(success, errorString)
            }
        }
    }
    
    
    func postSessionID(_ userLogin : [String:String], completionHandlerForSession: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let username = userLogin["username"]!
        let password = userLogin["password"]!
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        print(request)
        let task = UdacityClient.sharedInstance().session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func displayError(_ error: String, debugLabelText: String? = nil) {
                print(error)

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
                print(parsedResult["error"]!)
                return
            }
            
            guard let account = parsedResult["account"] as? NSDictionary else {
                print("The account dictionary was not found in the parsed data")
                return
            }
            
            if error != nil {
                completionHandlerForSession(false, "Login Failed. Unable to Post Session")
            } else {
                if let sessionID = parsedResult {
                    completionHandlerForSession(true, nil)
                } else {
                    completionHandlerForSession(false, "Login Failed. Unable to Post Session")
                }
            }
            
            
            print(parsedResult)
            
            UdacityClient.sharedInstance().userKey = account["key"] as? String
            print(self.userKey!)
            
        }
        
        task.resume()
        
        
    }
    
    
    func getUserData(_ completionHandlerUserData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userKey!)")!)
        let task = session.dataTask(with: request) { (data, response, error) in
        
            func displayError(_ error: String) {
                print(error)
                
                
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
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! NSDictionary as! [String : AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            guard (parsedResult["error"] == nil) else {
                print(parsedResult["error"]!)
                return
            }
            
            guard let user = parsedResult["user"] as? NSDictionary else {
                print("User info not found in User Data")
                return
            }
            
            if error != nil {
                completionHandlerUserData(false, "Login Failed. Unable to retrieve User Data")
            } else {
                if let userData = parsedResult {
                    completionHandlerUserData(true, nil)
                } else {
                    completionHandlerUserData(false, "Login Failed. Unable to retrieve User Data")
                }
            }
            
            self.firstName = user["first_name"] as? String
            self.lastName = user["last_name"] as? String
            print(self.firstName!)
            print(self.lastName!)

            
        }
        
        task.resume()
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
