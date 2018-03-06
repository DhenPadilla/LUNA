//
//  Event.swift
//  LUA Application
//
//  Created by Dhen Padilla on 07/09/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit

class Event: NSObject {
    
    var eventThumbnailImageURL: String? //May not be needed
    var eventThumbnailImage: UIImage?
    var eventOwnerThumbnailImage: UIImage?
    var eventThumbnailDesc: String?
    var eventTitle: String? //'Name variable'
    var eventDate: Date?
    var eventDescription: String?
    var eventID: String?
    var eventRSVP: String?
    
    // Location variables
    var eventLocationStreet: String?
    var eventLocationCity: String?
    var eventLocationZip: String?
    var eventLatitude: Double?
    var eventLongitude: Double?
    
    //Actual optionals
    var eventOwnerID: String?
    var eventRating: Double?
    var eventPageID: Double?
    var eventOrgID: Double?
    var eventGroupID: Double?
    
    
    //Event owner:
    var organisation: Organisation?
    
    /*init(thumbnail: String, title: String, date: Date, description: String, location: String, id: Int) {
        eventThumbnailImageURL = thumbnail
        eventTitle = title
        eventDate = date
        eventDescription = description
        eventLocation = location
        eventID = id
    }
     */
    
    
}
