//
//  Student.swift
//  On The Map
//
//  Created by Arturo Reyes on 7/7/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

struct Student {
    let objectID: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
    
    init(studentDict: [String:AnyObject]) {
        firstName = studentDict[Constants.Student.firstName] as! String
        lastName = studentDict[Constants.Student.lastName] as! String
        objectID = studentDict[Constants.Student.objectID] as! String
        uniqueKey = studentDict[Constants.Student.uniqueKey] as! String
        mapString = studentDict[Constants.Student.mapString] as! String
        mediaURL = studentDict[Constants.Student.mediaURL] as! String
        latitude = studentDict[Constants.Student.latitude] as! Double
        longitude = studentDict[Constants.Student.longitude] as! Double
        createdAt = studentDict[Constants.Student.createdAt] as! String
        updatedAt = studentDict[Constants.Student.updatedAt] as! String
    }
}
