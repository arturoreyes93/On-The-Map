//
//  ParseClient.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/30/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func urlFromParameters(client: String, paremeters: [String:AnyObject]? = nil, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        
        if client == "udacity" {
            components.scheme = Constants.Udacity.APIScheme
            components.host = Constants.Udacity.APIHost
            components.path = Constants.Udacity.APIPath + (withPathExtension ?? "")
        } else {
            components.scheme = Constants.Parse.APIScheme
            components.host = Constants.Parse.APIHost
            components.path = Constants.Parse.APIPath + (withPathExtension ?? "")
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
    
    func taskForGetMethod(client: String, method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        let request = NSMutableURLRequest(url: urlFromParameters(client: client, paremeters: parameters, withPathExtension: method))
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
            
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
        
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}
