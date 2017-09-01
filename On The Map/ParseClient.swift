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
        studentParameters[Constants.Parse.ParameterKeys.skip] = "100"
        studentParameters[Constants.Parse.ParameterKeys.order] = "-\(Constants.Student.updatedAt)"
        
        let _ = taskForMethod(client: Constants.Parse.Client, parameters: studentParameters as [String : AnyObject]) { (result, error, errorString) in
            
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
        
        let _ = taskForMethod(client: Constants.Parse.Client, parameters: studentParameters as [String : AnyObject]) { (result, error, errorString) in
            
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
    
    func postStudentLocation(_ newData: [String:String]?, _ completionHandlerForPost: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let _ = taskForMethod(client: Constants.Parse.Client, method: Constants.Methods.Post, newData: newData) { (result, error, errorString) in
        
            if let error = error {
                print(error)
                completionHandlerForPost(false, "Unable to post location")
            } else {
                if result != nil {
                    completionHandlerForPost(true, nil)
                } else {
                    completionHandlerForPost(false, "Unable to post location")
                }
            }
        }
        
    }
    
    func putStudentLocation(_ newData: [String:String]?, _ completionHandlerForPut: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let local = StudentData.sharedInstance().localStudent[0]
        print("objetdID: \(local.objectId)")
        
        let _ = taskForMethod(client: Constants.Parse.Client, method: Constants.Methods.Put, pathExtension: local.objectId, newData: newData) { (result, error, errorString) in
            
            if let error = error {
                print(error)
                completionHandlerForPut(false, "Unable to overwrite location:")
            } else {
                if result != nil {
                    completionHandlerForPut(true, nil)
                } else {
                    completionHandlerForPut(false, "Unable to overwrite location")
                }
            }
        }
        
    }
    
    func downloadData(_ completionHandlerForDownload: @escaping (_ results: [Student]?, _ errorString: String?) -> Void) {
        let userKey = UdacityClient.sharedInstance().userKey!
        UdacityClient.sharedInstance().getSingleStudentLocation(studentKey: userKey) { (success, localStudentArray, errorString) in
            if success {
                StudentData.sharedInstance().localStudent = UdacityClient.sharedInstance().fromDictToStudentObject(studentArray: localStudentArray!)
                UdacityClient.sharedInstance().getStudentLocations() { (success, studentArray, errorString) in
                    if success {
                        StudentData.sharedInstance().otherStudents = UdacityClient.sharedInstance().fromDictToStudentObject(studentArray: studentArray!)
                        let studentData = (StudentData.sharedInstance().otherStudents + StudentData.sharedInstance().localStudent)
                        StudentData.sharedInstance().students = studentData
                        completionHandlerForDownload(studentData, nil)
                    } else {
                        completionHandlerForDownload(nil, errorString)
                    }
                }
            } else {
                completionHandlerForDownload(nil, errorString)
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
