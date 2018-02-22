//
//  FacebookApi.swift
//  LUA Application
//
//  Created by Dhen Padilla on 17/11/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FacebookApi: NSObject {
    static let sharedApiInstance = FacebookApi()
    
    var event: Event?
    
    var events: [Int]?
    
    let accessToken = FBSDKAccessToken.current()
    
    var currentID: Int?
    
    
    
    func getUserInfo() {
        if accessToken != nil {
            let graphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id"]).start(completionHandler: { (connection, result, error) in
                if error != nil {
                    print("Failed to start graph request to userID in FacebookApi")
                    return
                }
                
                else {
                    //Transform to dicstionary first
                    if let result = result as? [String: Any] {
                        guard let uid = result["id"] as? Int else {
                            return
                        }
                        
                        self.currentID = uid
                        
                        print("---------------------- THIS IS THE CURRENT USER: \(uid)---------------------")
                    }
                }
            })
        }
    }
}
