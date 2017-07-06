//
//  ParseClient.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/30/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func getStudentLocations(_ completionHandlerForLocations: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        var studentParameters = [Constants.Parse.ParameterKeys.limit: "100"]
        studentParameters[Constants.Parse.ParameterKeys.skip] = "200"
        studentParameters[Constants.Parse.ParameterKeys.order] = "-\(Constants.Student.updatedAt)"
        
        let _ = taskForMethod(client: Constants.Parse.Client, parameters: studentParameters as [String : AnyObject]) { (result, error) in
            
            if let error = error {
                print(error)
                completionHandlerForLocations(false, "Could not retrieve student locations dictionary")
            } else {
                if let results = result?["results"] as? NSDictionary {
                    completionHandlerForLocations(true, nil)
                    print("Student locations retrieved succesfully")
                } else {
                    completionHandlerForLocations(false, "Could not retrieve student locations dictionary")
                    print("Could not retrieve student locations dictionary")
                }
            }
        }
    }
    
    func getSingleStudentLocation(_ completionHandlerForSingleLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let studentParameters = [Constants.Parse.ParameterKeys.at: "{\"\(Constants.Student.uniqueKey)\":\"\(userKey)\"}"]
        
        let _ = taskForMethod(client: Constants.Parse.Client, parameters: studentParameters as [String : AnyObject]) { (result, error) in
            
            if let error = error {
                print(error)
                completionHandlerForSingleLocation(false, "Could not retrieve single student locations dictionary")
            } else {
                if let results = result?["results"] as? NSDictionary {
                    completionHandlerForSingleLocation(true, nil)
                    print("Single student locations retrieved succesfully")
                } else {
                    completionHandlerForSingleLocation(false, "Could not retrieve single student locations dictionary")
                    print("Could not retrieve single student locations dictionary")
                }
            }
        }
    }
    
}
