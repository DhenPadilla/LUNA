//
//  ApiService.swift
//  LUA Application
//
//  Creates the instance for the RESTApi online. 
//  Parses the JSON data into an event class -> eventCell
//
//  Created by Dhen Padilla on 14/09/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedApiInstance = ApiService()
    
    var events: [Event] = {
        return []
    }()
    
    
}
