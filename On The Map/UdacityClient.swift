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
    
    func getUserData() {
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userKey!)")!)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error)
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! NSDictionary as! [String : AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            guard (parsedResult["error"] == nil) else {
                print(parsedResult["error"])
                return
            }
            
            guard let userInfo = parsedResult["user"] as? NSDictionary else {
                return
            }
            
            self.firstName = userInfo["first_name"] as! String
            self.lastName = userInfo["last_name"] as! String
            print(self.firstName!)
            print(self.lastName!)
        }
        
        task.resume()
    }
    
    private func urlFromParameters(_client: String, paremeters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        
        if _client == "udacity" {
            components.scheme = Constants.Udacity.APIScheme
            components.host = Constants.Udacity.APIHost
            components.path = Constants.Udacity.APIPath
        } else {
            components.scheme = Constants.Parse.APIScheme
            components.host = Constants.Parse.APIHost
            components.path = Constants.Parse.APIPath
        }
        
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in paremeters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        
        return components.url!
        
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
