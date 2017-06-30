//
//  Constants.swift
//  On The Map
//
//  Created by Arturo Reyes on 6/23/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    struct Constants {
        
        struct Udacity {
            static let APIScheme = "https"
            static let APIHost = "www.udacity.com"
            static let UserAPIPath = "/api/users"
            static let SessionAPIPath = "/api/session"
            
            
        }
        
        struct Parse {
            
            static let APIScheme = "https"
            static let APIHost = "parse.udacity.com"
            static let APIPath = "/parse/classes/"
        }
        
    }
    
    struct Methods {
        
        struct Udacity {
            var users = "/users"
            var session = "/session"
            var userID = ""
            var sessionID = ""
            
        }
    }
}

