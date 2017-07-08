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
        
        var studentParameters = [Constants.Parse.ParameterKeys.limit: "30"]
        studentParameters[Constants.Parse.ParameterKeys.skip] = "60"
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
    
    func getSingleStudentLocation(studentKey: String, _ completionHandlerForSingleLocation: @escaping (_ success: Bool, _ localStudentArray: NSArray?, _ errorString: String?) -> Void) {
        
        let studentParameters = [Constants.Parse.ParameterKeys.at: "{\"\(Constants.Student.uniqueKey)\":\"\(studentKey)\"}"]
        
        let _ = taskForMethod(client: Constants.Parse.Client, parameters: studentParameters as [String : AnyObject]) { (result, error) in
            
            if let error = error {
                print(error)
                completionHandlerForSingleLocation(false, nil, "Could not retrieve single student location")
            } else {
                if let results = result?["results"] as? NSArray {
                    completionHandlerForSingleLocation(true, results, nil)
                    print("Single student location retrieved succesfully")
                } else {
                    completionHandlerForSingleLocation(false, nil, "Could not retrieve single student location")
                    print("Could not retrieve single student location")
                }
            }
        }
    }
    
    func postStudentLocation(_ completionHandlerForPost: @escaping (_ success: Bool, _ updatedData: NSDictionary?, _ errorString: String?) -> Void) {
        
        let _ = taskForMethod(client: Constants.Parse.Client, method: Constants.Methods.Post) { (result, error) in
        
            if let error = error {
                print(error)
                completionHandlerForPost(false, nil, "Unable to post location: \(error)")
            } else {
                if let results = result as? NSDictionary {
                    completionHandlerForPost(true, results, nil)
                } else {
                    completionHandlerForPost(false, nil, "Unable to post location")
                }
            }
        }
        
    }
    
    func putStudentLocation(_ completionHandlerForPut: @escaping (_ success: Bool, _ updatedData: NSDictionary?, _ errorString: String?) -> Void) {
        
        let local = UdacityClient.sharedInstance().localStudent[0]
        
        let _ = taskForMethod(client: Constants.Parse.Client, method: Constants.Methods.Put, pathExtension: local.objectId) { (result, error) in
            
            if let error = error {
                print(error)
                completionHandlerForPut(false, nil, "Unable to put location: \(error)")
            } else {
                if let results = result as? NSDictionary {
                    completionHandlerForPut(true, results, nil)
                } else {
                    completionHandlerForPut(false, nil, "Unable to put location")
                }
            }
        }
        
    }

    func fromDictToStudentObject(studentArray: NSArray) -> [Student] {
        
        var studentsArray = [Student]()
        
        for student in studentArray {
            print(student)
            studentsArray.append(Student(studentDict: student as! [String : AnyObject]))
        }
        
        return studentsArray
    }
}
