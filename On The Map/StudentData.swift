//
//  StudentData.swift
//  On The Map
//
//  Created by Arturo Reyes on 9/1/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation

class StudentData: NSObject {
    
    var otherStudents: [Student]!
    
    var localStudent: [Student]!
    
    var students : [Student]!
    
    class func sharedInstance() -> StudentData {
        struct Singleton {
            static var sharedInstance = StudentData()
        }
        return Singleton.sharedInstance
    }
    
}
