//
//  ParseClient.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/30/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func getStudentLocations(_ completionHandlerForLocations: @escaping (_ success: Bool, _ studentArray: NSArray?, _ errorString: String?) -> Void) {
        
        var studentParameters = [Constants.Parse.ParameterKeys.limit: "100"]
        studentParameters[Constants.Parse.ParameterKeys.skip] = "200"
        studentParameters[Constants.Parse.ParameterKeys.order] = "-\(Constants.Student.updatedAt)"
        
        let _ = taskForMethod(client: Constants.Parse.Client, parameters: studentParameters as [String : AnyObject]) { (result, error) in
            
            if let error = error {
                print(error)
                completionHandlerForLocations(false, nil, "Could not retrieve student locations array")
            } else {
                if let studentArray = result?["results"] as? NSArray {
                    completionHandlerForLocations(true, studentArray, nil)
                    print("Student locations retrieved succesfully")
                } else {
                    completionHandlerForLocations(false, nil, "Could not retrieve student locations array")
                    print("Could not retrieve student locations array")
                }
            }
        }
    }
    
    func getSingleStudentLocation(studentKey: String, _ completionHandlerForSingleLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let studentParameters = [Constants.Parse.ParameterKeys.at: "{\"\(Constants.Student.uniqueKey)\":\"\(studentKey)\"}"]
        
        let _ = taskForMethod(client: Constants.Parse.Client, parameters: studentParameters as [String : AnyObject]) { (result, error) in
            
            if let error = error {
                print(error)
                completionHandlerForSingleLocation(false, "Could not retrieve single student location")
            } else {
                if let results = result?["results"] as? NSArray {
                    completionHandlerForSingleLocation(true, nil)
                    print("Single student location retrieved succesfully")
                } else {
                    completionHandlerForSingleLocation(false, "Could not retrieve single student location")
                    print("Could not retrieve single student location")
                }
            }
        }
    }
    
    func fromDictToStudentObject(studentArray: NSArray) -> [Student] {
        
        var studentsArray = [Student]()
        
        for student in studentArray {
            studentsArray.append(Student(studentDict: student as! [String : AnyObject]))
        }
        return studentsArray
    }
}
