//
//  StudentData.swift
//  On The Map
//
//  Created by Arturo Reyes on 9/1/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation

class StudentData {
    
    // stores students downloaded from getStudentLocations
    var otherStudents: [Student]!
    
    // stores the single student using the app
    var localStudent: [Student]!
    
    // adds both local and other students to be used in the map and table views
    var students : [Student]!
    
    class func sharedInstance() -> StudentData {
        struct Singleton {
            static var sharedInstance = StudentData()
        }
        return Singleton.sharedInstance
    }
}
