//
//  Constants.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/23/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Udacity {
        static let Client = "udacity"
        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let APIPath = "/api"
        static let userPathExtension = "/users"
        static let sessionPathExtension = "/session"
        
    }
    
    struct Parse {
        static let Client = "parse"
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppHTTP = "X-Parse-Application-Id"
        static let APIHTPP = "X-Parse-REST-API-Key"
        
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes/StudentLocation/"
        
        struct ParameterKeys {
            static let limit = "limit"
            static let skip = "skip"
            static let order = "order"
            static let at = "where"
        }
    }
    
    struct Student {
        static let objectID = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
    }
    
    struct Methods {
        static let Get = "GET"
        static let Post = "POST"
        static let Put = "PUT"
        static let Delete = "DELETE"
    }
    
    struct JSON {
        static let App = "application/json"
        static let Accept = "Accept"
        static let Content = "Content-Type"
    }
    
}

