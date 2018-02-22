//
//  Location.swift
//  LUA Application
//
//  Created by Dhen Padilla on 08/02/2018.
//  Copyright © 2018 dhenpadilla. All rights reserved.
//

import Foundation
import MapKit

class Location: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    //let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
}
