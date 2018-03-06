//
//  User.swift
//  LUA Application
//
//  Created by Dhen Padilla on 01/10/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit

class User: NSObject {
    static let sharedUser = User()
    
    var userID: String?
    var picture: UIImage?
    var universityAttending: String?
    var universityEmail: String?
    var email: String?
    var accessToken: String?
    
    var societies: [String]?
    
    func getUserID() -> String {
        var id = ""
        if let uid = self.userID {
            id = uid
        }
        return id
    }
    
    func setAccessToken(token: String) {
        if let t = token as? String {
            self.accessToken = t
        }
    }
    
    func getAccessToken() -> String {
        var token = ""
        if let t = self.accessToken as? String {
            token = t
        }
        return token
    }
    
    func getProfilePic() -> UIImage {
        var picture = UIImage()
        if let pic = self.picture {
            picture = pic
        }
        return picture
    }
}

