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
        
        let request = NSMutableURLRequest(url: urlFromParameters(client: Constants.Udacity.Client, method: Constants.Udacity.sessionPathExtension))
        print(request)
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
            
            print(parsedResult)
            UdacityClient.sharedInstance().userKey = account["key"] as? String
            print(self.userKey!)
            
            
            if error != nil {
                completionHandlerForSession(false, "Login Failed. Unable to Post Session")
            } else {
                if (parsedResult) != nil {
                    completionHandlerForSession(true, nil)
                } else {
                    completionHandlerForSession(false, "Login Failed. Unable to Post Session")
                }
            }
        }
        
        task.resume()
        
        
    }
    
    
    func getUserData(_ completionHandlerUserData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let _ = taskForGetMethod(client: Constants.Udacity.Client, method: Constants.Udacity.userPathExtension + "/\(userKey!)") { (result, error) in
            
            if let error = error {
                print(error)
                completionHandlerUserData(false, "Login Failed. Unable to retrieve User Data")
            } else {
                if let user = result?["user"] as? NSDictionary {
                    completionHandlerUserData(true, nil)
                } else {
                    print("Could not find user in \(result)")
                    completionHandlerUserData(false, "Login Failed. Unable to retrieve User Data")
                }
            }
        }
    }
    
    func taskForGetMethod(client: String, method: String? = nil, parameters: [String:AnyObject]? = nil, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        let request = NSMutableURLRequest(url: urlFromParameters(client: client, paremeters: parameters, method: method))
        
        if client == "parse" {
            request.addValue(Constants.Parse.AppID, forHTTPHeaderField: Constants.Parse.AppHTTP)
            request.addValue(Constants.Parse.APIKey, forHTTPHeaderField: Constants.Parse.APIHTPP)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard data != nil else {
                sendError("No data was returned by the request!")
                return
            }
            
            var newData = data
            
            guard (client == "parse") else {
                if let data = data {
                    let range = Range(5..<data.count)
                    newData = data.subdata(in: range) /* subset response data! */
                    print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
                }
                return
            }
            
            self.convertDataWithCompletionHandler(newData!, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
        
    }
    
    func urlFromParameters(client: String, paremeters: [String:AnyObject]? = nil, method: String? = nil) -> URL {
        
        var components = URLComponents()
        
        if client == "udacity" {
            components.scheme = Constants.Udacity.APIScheme
            components.host = Constants.Udacity.APIHost
            components.path = Constants.Udacity.APIPath + (method ?? "")
        } else {
            components.scheme = Constants.Parse.APIScheme
            components.host = Constants.Parse.APIHost
            components.path = Constants.Parse.APIPath + (method ?? "")
        }
        
        components.queryItems = [URLQueryItem]()
        
        if let _ = paremeters {
            for (key, value) in paremeters! {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
            
            return components.url!
        }
        
        return components.url!
    }
    
    
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
