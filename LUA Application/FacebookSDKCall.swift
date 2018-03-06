//  FacebookSDKCall.swift
//  LUA Application
//
//  Created by Dhen Padilla on 12/10/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.


import UIKit
import FBSDKCoreKit

class FacebookSDKCall: NSObject {
    
    static let sharedApiInstance = FacebookSDKCall()
    
    var event: Event?
    
    let accessToken = FBSDKAccessToken.current()
    
    func getUserInfo() -> String {
        var currentId = ""
        
        if accessToken != nil {
            _ = FBSDKGraphRequest(graphPath: "/me", parameters: ["Fields": "id"]).start(completionHandler: { (connection, result, error) in
                if error != nil {
                    print("Failed to start graph request to userID in FacebookSDKCall class")
                    return
                }
                
                else {
                    print(String(describing: connection))
                    // Transform to dictionary first
                    if let result = result as? [String: Any] {
                        guard let uid = result["id"] as? String else {
                            return
                        }
                         currentId = uid
                    }
                }
            })
        }
        return currentId
    }
    
    func getUserProfilePicture() -> UIImage {
        var profilePic: UIImage = UIImage()
        if accessToken != nil {
            _ = FBSDKGraphRequest(graphPath: "/me/", parameters: ["Fields" : "picture.type(large)"]).start(completionHandler: { (connection, result, error) in
                if error != nil {
                    print("Failed to start graph request to userID in FacebookSDKCall class")
                    return
                }
                
                else {
                    print(String(describing: connection))
                    // Get Dictionary
                    if let result = result as? [String: Any], let data = result["data"] as? [String: Any] {
                        if let url = data["url"] {
                            if let eventPictureURL = URL(string: String(describing: url)) {
                                URLSession.shared.dataTask(with: eventPictureURL, completionHandler: { (data, response, error) in
                                    if error != nil {
                                        print(String(describing: error))
                                        return
                                    }
                                    
                                    profilePic = UIImage(data: data!)!
                                }).resume()
                            }
                        }
                    }
                }
            })
        }
        return profilePic
    }
    
    func getUserEvents() {
        if accessToken != nil {
            let eventGraphRequest = FBSDKGraphRequest(graphPath: "/me/events", parameters: ["Fields" : "events"])
                
            eventGraphRequest?.start(completionHandler: { (connection, result, error) in
                if error != nil {
                    print("Failed to grab events")
                    print(String(describing: error))
                    return
                }
                
                else {
                    print(String(describing: connection))
                    if let events = result as? [String: Any] , let data = events["data"] as? [[String : Any]] {
                        //Automatically parse the result from rawResponse into an Event object
                        for i in 1...10 { // Change this to increase everytime you scroll more
                            let event = Event()
                            
                            let resultEvent = data[i]
                            
                            //Parse Event ID
                            if let eventId = resultEvent["id"] as? String {
                                event.eventID = eventId
                                
                                
                                // GET EVENT ICON IMAGE
                                let eventIconPhotoGraphRequest = FBSDKGraphRequest(graphPath: "/" + eventId + "?fields=cover.type(large)", parameters: nil)
                                eventIconPhotoGraphRequest?.start(completionHandler: { (connection, result, error) in
                                    if error != nil {
                                        print("Failed to grab picture")
                                        print(error as Any)
                                        return
                                    }
                                            
                                    else { // May have to migrate this to the eventViewController (CACHE)
                                        if let res = result as? [String: Any], let picture = res["cover"] as? [String : Any] {
                                            if let url = picture["source"] {
                                                if let eventPictureURL = URL(string: String(describing: url)) {
                                                    URLSession.shared.dataTask(with: eventPictureURL, completionHandler: { (data, response, error) in
                                                        if error != nil {
                                                            print(String(describing: error))
                                                            return
                                                        }
                                                        
                                                        let eventImage = UIImage(data: data!)
                                                        event.eventThumbnailImage = eventImage
                                                    }).resume()
                                                }
                                            }
                                        }
                                    }
                                })
                                
                                
                                //Event Society Photo
                                let eventSocPhotoGraphRequest = FBSDKGraphRequest(graphPath: "/" + eventId + "?fields=owner", parameters: nil)
                                eventSocPhotoGraphRequest?.start(completionHandler: { (_, result, error) in
                                    if error != nil {
                                        print(String(describing: error))
                                        return
                                    }
                                    
                                    else {
                                        if let res = result as? [String: Any], let soc = res["owner"] as? [String : Any], let socId = soc["id"] as? String {
                                            
                                            FBSDKGraphRequest(graphPath: "/" + socId + "?fields=picture.type(large)", parameters: nil).start(completionHandler: { (connection, result, error) in
                                                if error != nil {
                                                    print("Failed to grab picture")
                                                    print(error as Any)
                                                    return
                                                }
                                                    
                                                else {
                                                    if let res = result as? [String: Any], let picture = res["picture"] as? [String : [String : Any]], let data = picture["data"] as? [String : Any] {
                                                        if let url = data["url"] {
                                                            event.eventThumbnailImageURL = String(describing: url)
                                                            /* if let eventOwnerPictureURL = URL(string: String(describing: url)) {
                                                                URLSession.shared.dataTask(with: eventOwnerPictureURL, completionHandler: { (data, response, error) in
                                                                    if error != nil {
                                                                        print(String(describing: error))
                                                                        return
                                                                    }
                                                                    
                                                                    let eventImage = UIImage(data: data!)
                                                                    event.eventOwnerThumbnailImage = eventImage
                                                                }).resume()
                                                            }*/
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                    }
                                })
                            }
                            
                            //Parse Event Title
                            if let eventTitle = resultEvent["name"] as? String {
                                event.eventTitle = eventTitle
                            }
                            
                            //Parse Event Description
                            if let eventDesc = resultEvent["description"] as? String {
                                event.eventDescription = eventDesc
                            }
                            
                            //Parse Event Thumbnail Description - Substringed For Thumbnail Purposes
                            if let eventThumbDesc = resultEvent["description"] as? String {
                                let thumbnailDesc = eventThumbDesc.prefix(80) + "..."
                                event.eventThumbnailDesc = String(thumbnailDesc)
                            }
                            
                            //Parse Event Date
                            if let eventDate = resultEvent["start_time"] as? String {
                                let formatter = ISO8601DateFormatter()
                                event.eventDate = formatter.date(from: eventDate)
                            }
                            
                            //Parse Event RSVP
                            if let eventRSVP = resultEvent["rsvp_status"] as? String {
                                event.eventRSVP = eventRSVP
                            }
                            
                            //Parse Event Location
                            if let eventLocationAbstract = resultEvent["place"] as? [String : Any] {
                                //Event Organiser (Soc / Company) is defined here
                                if let eventOrganiser = eventLocationAbstract["name"] as? String {
                                    let organisation = Organisation()
                                    organisation.organisationName = eventOrganiser
                                    event.organisation = organisation
                                }
                                if let eventLocation = eventLocationAbstract["location"] as? [String : Any] {
                                    if let eventStreet = eventLocation["street"] as? String {
                                        event.eventLocationStreet = eventStreet
                                    }
                                    if let eventCity = eventLocation["city"] as? String {
                                        event.eventLocationCity = eventCity
                                    }
                                    // May not need this one:
                                    if let eventCountry = eventLocation["country"] as? String {
                                    }
                                    if let eventZip = eventLocation["zip"] as? String {
                                        event.eventLocationZip = eventZip
                                    }
                                    
                                    //Parse Event Latitude & Longitude (for location services)
                                    if let eventLat = eventLocation["latitude"] as? Double  {
                                        event.eventLatitude = eventLat
                                    }
                                    if let eventLong = eventLocation["longitude"] as? Double {
                                        event.eventLongitude = eventLong
                                    }
                                }
                            }
                        
                            let sharedEventsModel = Events.sharedEventsModel
                            sharedEventsModel.appendEvent(newEvent: event)
                        }
                    }
                }
            })
        }
        
        else {
            print("There was no access token")
        }
    }
}
