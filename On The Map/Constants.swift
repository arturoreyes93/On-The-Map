//
//  Constants.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/23/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    static let udacity = "udacity"
    static let parse = "parse"
    
    struct Udacity {
        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let APIPath = "/api"
        static let userPathExtension = "/user"
        static let sessionPathExtension = "/session"
        static let userID = ""
        
    }
    
    struct Parse {
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes/StudentLocation"
        static let objectID = ""
        
        struct ParameterKeys {
            static let limit = "limit"
            static let skip = "skip"
            static let order = "order"
            static let at = "where"
        }
    }
    
    struct Student {
        
        var objectID = ""
        var uniqueKey = ""
        var firstName = ""
        var lastName = ""
        var mapString = ""
        var mediaURL = ""
        var latitude = ""
        var longitude = ""
        var createdAt = ""
        var updatedAt = ""
        var ACL = ""
        
    }
    
}

