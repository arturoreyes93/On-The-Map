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
        firstName = studentDict[Constants.Student.firstName] as? String ?? "no info"
        lastName = studentDict[Constants.Student.lastName] as? String ?? "no info"
        objectID = studentDict[Constants.Student.objectID] as? String ?? "no info"
        uniqueKey = studentDict[Constants.Student.uniqueKey] as? String ?? "no info"
        mapString = studentDict[Constants.Student.mapString] as? String ?? "no info"
        mediaURL = studentDict[Constants.Student.mediaURL] as? String ?? "no info"
        latitude = studentDict[Constants.Student.latitude] as? Double ?? 0.0
        longitude = studentDict[Constants.Student.longitude] as? Double ?? 0.0
        createdAt = studentDict[Constants.Student.createdAt] as? String ?? "no info"
        updatedAt = studentDict[Constants.Student.updatedAt] as? String ?? "no info"
    }
}
