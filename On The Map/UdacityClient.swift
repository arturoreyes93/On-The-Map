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
    
    func logInWithVC(_ userLogin : [String: AnyObject], completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        self.postSessionID(userLogin) { (success, userKey, errorString) in
            if success {
                UdacityClient.sharedInstance().userKey = userKey
                print(self.userKey)
                self.getUserData() { (success, user, errorString) in
                    if success {
                        UdacityClient.sharedInstance().firstName = user?["first_name"] as! String
                        UdacityClient.sharedInstance().lastName = user?["last_name"] as! String
                        print(self.firstName)
                        print("success")
                    }
                    completionHandlerForLogin(success, errorString)
                }
    
            } else {
                completionHandlerForLogin(success, errorString)
            }
        }
    }
    
    
    func postSessionID(_ parameters : [String:AnyObject], completionHandlerForSession: @escaping (_ success: Bool, _ userKey: String?, _ errorString: String?) -> Void) {
        
        let _ = taskForMethod(client: Constants.Udacity.Client, method: Constants.Methods.Post, pathExtension: Constants.Udacity.sessionPathExtension, parameters: parameters) { (result, error) in
            
            if error != nil {
                completionHandlerForSession(false, nil, "Login Failed. Unable to Post Session")
            } else {
                print("no error")
                if let account = result?["account"] as? NSDictionary {
                    print(account)
                    let key = account["key"] as? String
                    completionHandlerForSession(true, key, nil)
                    print(result!)
                } else {
                    print("Could not find account in \(result)")
                    completionHandlerForSession(false, nil, "Login Failed. Unable to Post Session")
                }
            }
        }
    }
 
    
    
    func getUserData(_ completionHandlerUserData: @escaping (_ success: Bool, _ firstName: [String:AnyObject]?, _ errorString: String?) -> Void) {
        
        let _ = taskForMethod(client: Constants.Udacity.Client, pathExtension: Constants.Udacity.userPathExtension + "/\(userKey!)") { (result, error) in
            
            if let error = error {
                print(error)
                completionHandlerUserData(false, nil, "Login Failed. Unable to retrieve User Data")
            } else {
                if let user = result?["user"] as? NSDictionary {
                    completionHandlerUserData(true, user as! [String : AnyObject], nil)

                } else {
                    print("Could not find user in \(result)")
                    completionHandlerUserData(false, nil, "Login Failed. Unable to retrieve User Data")
                }
            }
        }
    }
    
    func taskForMethod(client: String, method: String? = nil, pathExtension: String? = nil, parameters: [String:AnyObject]? = nil, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        let request = NSMutableURLRequest(url: urlFromParameters(client: client, paremeters: parameters, pathExtension: pathExtension))
        print(request)
        
        if (method != nil) {
            request.httpMethod = method!
            print(method!)
        }
        
        if client == Constants.Parse.Client {
            request.addValue(Constants.Parse.AppID, forHTTPHeaderField: Constants.Parse.AppHTTP)
            request.addValue(Constants.Parse.APIKey, forHTTPHeaderField: Constants.Parse.APIHTPP)
        }
        
        if method == Constants.Methods.Post {
            
            request.addValue(Constants.JSON.App, forHTTPHeaderField: Constants.JSON.Content)
            
            if client == Constants.Udacity.Client {
                print(client)
                
                let username = parameters?["username"]! as! String
                let password = parameters?["password"]! as! String
                print(username)
                print(password)
                
                request.addValue(Constants.JSON.App, forHTTPHeaderField: Constants.JSON.Accept)
                request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
                
            } else if client == Constants.Parse.Client {
                request.httpBody = "{\"uniqueKey\": \"\(userKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
            }
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            print("no request error")
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            print("status code ok")
            
            /* GUARD: Was there any data returned? */
            guard data != nil else {
                sendError("No data was returned by the request!")
                return
            }
            
            print("There is data")
        
            print(data)
            var newData = data
            
            if client == Constants.Udacity.Client {
                print("converting to new data")
                if let data = data {
                    let range = Range(5..<data.count)
                    newData = data.subdata(in: range) /* subset response data! */
                    print("finished converting????")
                    print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
                    print("indeed")
                }
            }
            
            print(newData!)
            
            self.convertDataWithCompletionHandler(newData!, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
        
    }
    
    func urlFromParameters(client: String, paremeters: [String:AnyObject]? = nil, pathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        
        if client == "udacity" {
            components.scheme = Constants.Udacity.APIScheme
            components.host = Constants.Udacity.APIHost
            components.path = Constants.Udacity.APIPath + (pathExtension ?? "")
        } else {
            components.scheme = Constants.Parse.APIScheme
            components.host = Constants.Parse.APIHost
            components.path = Constants.Parse.APIPath + (pathExtension ?? "")
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
        
        print("parsing data")
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        print(parsedResult)
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
