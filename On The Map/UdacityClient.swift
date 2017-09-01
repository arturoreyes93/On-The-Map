//
//  UdacityClient.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/23/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class UdacityClient : NSObject {
    
    var session = URLSession.shared

    var userKey: String?
    
    var accessToken: FBSDKAccessToken?

    
    override init() {
        super.init()
    }
    
    func logInWithVC(_ userLogin : [String: AnyObject], completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        self.postSessionID(userLogin) { (success, userKey, errorString) in
            if success {
                print(userKey)
                UdacityClient.sharedInstance().userKey = userKey
                self.getUserData(userKey!) { (success, user, errorString) in
                    if success {
                        print(user?["first_name"])
                    }
                    completionHandlerForLogin(success, errorString)
                }
            } else {
                completionHandlerForLogin(success, errorString)
            }
            
        completionHandlerForLogin(success, errorString)
            
        }
    }
    
    func logInWithFacebook(_ completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        self.postSessionWithFacebook() { (success, userKey, errorString) in
            if success {
                print(userKey)
                UdacityClient.sharedInstance().userKey = userKey
                self.getUserData(userKey!) { (success, user, errorString) in
                    if success {
                        print(user?["first_name"])
                    }
                    completionHandlerForLogin(success, errorString)
                }
            } else {
                completionHandlerForLogin(success, errorString)
            }
            
            completionHandlerForLogin(success, errorString)
            
        }
    }
    
    func postSessionID(_ parameters : [String:AnyObject], completionHandlerForSession: @escaping (_ success: Bool, _ userKey: String?, _ errorString: String?) -> Void) {
        
        let _ = taskForMethod(client: Constants.Udacity.Client, method: Constants.Methods.Post, pathExtension: Constants.Udacity.sessionPathExtension, parameters: parameters) { (result, error, errorString) in
            
            if error != nil {
                if errorString != nil {
                    completionHandlerForSession(false, nil, errorString)
                } else {
                    completionHandlerForSession(false, nil, "Login Failed. Unable to Post Session.")
                }
                print(error)
            } else {
                if let account = result?["account"] as? NSDictionary {
                    print(account)
                    let key = account["key"] as? String
                    completionHandlerForSession(true, key, nil)
                    print(result!)
                } else {
                    print("Could not find account in retrieved data.")
                    completionHandlerForSession(false, nil, "Login Failed. Unable to Post Session.")
                }
            }
        }
    }
 
    
    
    func getUserData(_ userKey: String, _ completionHandlerUserData: @escaping (_ success: Bool, _ firstName: [String:AnyObject]?, _ errorString: String?) -> Void) {
        
        let _ = taskForMethod(client: Constants.Udacity.Client, pathExtension: Constants.Udacity.userPathExtension + "/\(userKey)") { (result, error, errorString) in
            
            if let error = error {
                print(error)
                completionHandlerUserData(false, nil, "Login Failed. Unable to retrieve User Data.")
            } else {
                if let user = result?["user"] as? NSDictionary {
                    completionHandlerUserData(true, user as! [String : AnyObject], nil)

                } else {
                    print("Could not find user in retrieved data.")
                    completionHandlerUserData(false, nil, "Login Failed. Unable to retrieve User Data.")
                }
            }
        }
    }
    
    func deleteSession(_ completionHandlerForDelete: @escaping (_ success: Bool, _ results: NSDictionary?, _ errorString: String?) -> Void) {
        
        let _ = taskForMethod(client: Constants.Udacity.Client, method:  Constants.Methods.Delete, pathExtension: Constants.Udacity.sessionPathExtension) { (result, error, errorString) in
            
            if let error = error {
                print(error)
                completionHandlerForDelete(false, nil, "Logout Failed. Unable to delete session.")
            } else {
                if let result = result as? NSDictionary {
                    completionHandlerForDelete(true, result, nil)
                    
                } else {
                    print("Could not delete session. No data retrieved.")
                    completionHandlerForDelete(false, nil, "Could not delete session. No data retrieved.")
                }
            }
        }
    }
    
    func postSessionWithFacebook(_ completionHandlerForFacebook: @escaping (_ success: Bool, _ userKey: String?, _ errorString: String?) -> Void) {
        
        let _ = taskForMethod(client: Constants.Udacity.Client, method: Constants.Methods.Post, pathExtension: Constants.Udacity.sessionPathExtension) { (result, error, errorString) in
            
            if error != nil {
                completionHandlerForFacebook(false, nil, "Login Failed. Unable to Post Session with Facebook.")
                print(error)
            } else {
                if let account = result?["account"] as? NSDictionary {
                    print(account)
                    let key = account["key"] as? String
                    completionHandlerForFacebook(true, key, nil)
                    print(result!)
                } else {
                    print("Could not find account in retrieved data.")
                    completionHandlerForFacebook(false, nil, "Login Failed. Unable to Post Session with Facebook.")
                }
            }
        }
        
    }
    
    func taskForMethod(client: String, method: String? = nil, pathExtension: String? = nil, parameters: [String:AnyObject]? = nil, newData: [String:String]? = nil, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?, _ errorString: String?) -> Void) -> URLSessionTask {
        
        let request = NSMutableURLRequest(url: urlFromParameters(client: client, paremeters: parameters, pathExtension: pathExtension))
        print(request)
        
        if (method != nil) {
            request.httpMethod = method!
        }
        
        if client == Constants.Parse.Client {
            request.addValue(Constants.Parse.AppID, forHTTPHeaderField: Constants.Parse.AppHTTP)
            request.addValue(Constants.Parse.APIKey, forHTTPHeaderField: Constants.Parse.APIHTPP)
        }
        
        if method == Constants.Methods.Post {
            
            request.addValue(Constants.JSON.App, forHTTPHeaderField: Constants.JSON.Content)
            
            if client == Constants.Udacity.Client {
                request.addValue(Constants.JSON.App, forHTTPHeaderField: Constants.JSON.Accept)
                
                if let username = parameters?["username"] {
                    if let password = parameters?["password"] {
                       request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
                    }
                }
                
                if let accessToken = UdacityClient.sharedInstance().accessToken {
                    request.httpBody = "{\"facebook_mobile\": {\"access_token\": \"\(accessToken)\"}}".data(using: String.Encoding.utf8)
                }
                
            } else if client == Constants.Parse.Client {
                let local = StudentData.sharedInstance().localStudent[0]
                if let data = newData as [String:String]! {
                    let newMap = data["mapString"]
                    let newURL = data["URL"]
                    let newLat = data["latitude"]
                    let newLong = data["longitude"]
                    request.httpBody = "{\"uniqueKey\": \"\(local.uniqueKey)\", \"firstName\": \"\(local.firstName)\", \"lastName\": \"\(local.lastName)\",\"mapString\": \"\(newMap!)\", \"mediaURL\": \"\(newURL!)\",\"latitude\": \(newLat!), \"longitude\": \(newLong!)}".data(using: String.Encoding.utf8)
                    print("{\"uniqueKey\": \"\(local.uniqueKey)\", \"firstName\": \"\(local.firstName)\", \"lastName\": \"\(local.lastName)\",\"mapString\": \"\(newMap!)\", \"mediaURL\": \"\(newURL!)\",\"latitude\": \(newLat!), \"longitude\": \(newLong!)}")
                } else {
                    print("error unwrapping newData")
                }
            }
        }
        
        if method == Constants.Methods.Put {
            request.addValue(Constants.JSON.App, forHTTPHeaderField: Constants.JSON.Content)
            let local = StudentData.sharedInstance().localStudent[0]
            if let data = newData as [String:String]! {
                let newMap = data["mapString"]
                let newURL = data["URL"]
                let newLat = data["latitude"]
                let newLong = data["longitude"]
                request.httpBody = "{\"uniqueKey\": \"\(local.uniqueKey)\", \"firstName\": \"\(local.firstName)\", \"lastName\": \"\(local.lastName)\",\"mapString\": \"\(newMap!)\", \"mediaURL\": \"\(newURL!)\",\"latitude\": \(newLat!), \"longitude\": \(newLong!)}".data(using: String.Encoding.utf8)
                print("{\"uniqueKey\": \"\(local.uniqueKey)\", \"firstName\": \"\(local.firstName)\", \"lastName\": \"\(local.lastName)\",\"mapString\": \"\(newMap!)\", \"mediaURL\": \"\(newURL!)\",\"latitude\": \(newLat!), \"longitude\": \(newLong!)}")
            } else {
                print("error unwrapping newData")
            }
           
        }
        
        if method == Constants.Methods.Delete {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForMethod", code: 1, userInfo: userInfo), error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request")
                print("There was an error with request: \(error)")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 401 || statusCode == 403 {
                    sendError("Bad credentials. Invalid username or password")
                }
                print("Status code: \(statusCode)")
            }
            
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

            var newData = data
            
            if client == Constants.Udacity.Client {
                if let data = data {
                    let range = Range(5..<data.count)
                    newData = data.subdata(in: range) /* subset response data! */
                    print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
                }
            }

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

    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?, _ errorString: String?) -> Void) {

        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo), "Could not parse the data as JSON")
        }

        completionHandlerForConvertData(parsedResult, nil, nil)
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
