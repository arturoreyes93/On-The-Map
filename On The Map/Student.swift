///Users/arturoreyes/Documents/Udacity/iOS/Onthemap/On The Map/On The Map/Constants.swift
//  Student.swift
//  On The Map
//
//  Created by Arturo Reyes on 7/7/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

struct Student {
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    var createdAt: String
    var updatedAt: String
    
    init(studentDict: [String:AnyObject]) {
        firstName = studentDict[Constants.Student.firstName] as? String ?? "no info"
        lastName = studentDict[Constants.Student.lastName] as? String ?? "no info"
        objectId = studentDict[Constants.Student.objectID] as? String ?? "no info"
        uniqueKey = studentDict[Constants.Student.uniqueKey] as? String ?? "no info"
        mapString = studentDict[Constants.Student.mapString] as? String ?? "no info"
        mediaURL = studentDict[Constants.Student.mediaURL] as? String ?? "no info"
        latitude = studentDict[Constants.Student.latitude] as? Double ?? 0.0
        longitude = studentDict[Constants.Student.longitude] as? Double ?? 0.0
        createdAt = studentDict[Constants.Student.createdAt] as? String ?? "no info"
        updatedAt = studentDict[Constants.Student.updatedAt] as? String ?? "no info"
    }
}

