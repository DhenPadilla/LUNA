//
//  ProfilePageViewController.swift
//  LUA Application
//
//  Created by Dhen Padilla on 15/01/2018.
//  Copyright © 2018 dhenpadilla. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfilePageView: UIViewController {
    // Initialise FBSDKClass:
    let fbsdk = FacebookSDKCall.sharedApiInstance
    
//    ONLY HAS THE 3 FOLLOWING BUTTONS:
//      - SOCIETY LIST BUTTON
//      - LOGOUT BUTTON
//      - OTHER SETTINGS BUTTON
//      - NOTE: MAY ADD `CHANGE UNI` BUTTON
    
    let cellId = "cellId"
    
    
    // PROFILE PICTURE VIEW
    let profileImage: UIImageView = {
        let view = UIImageView()
        //view.image = UIImage()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 62
        return view
    }()
    
    
    // BUTTON IMPLEMENTATION:
    // 1: SOCIETY LIST BUTTON
    let societyList: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "Society List"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 2: OTHER SETTINGS BUTTON
    let settingsButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "Settings Button"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 3: LOGOUT BUTTON
    let logoutButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "Logout Button"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // BACKGROUND GRADIENT ANIMATION
    let gradient: CAGradientLayer = {
        let MAIN_COLOUR = UIColor(r: 24, g: 32, b: 49)
        let SECONDARY_COLOUR = UIColor(r: 115, g: 125, b: 150)
        let TERTIARY_COLOUR = UIColor(r: 200, g: 200, b: 215)
        
        let g = CAGradientLayer()
        g.colors = [MAIN_COLOUR.cgColor, SECONDARY_COLOUR.cgColor, TERTIARY_COLOUR.cgColor]
        g.locations = [0.0, 0.75, 1.0]
        g.startPoint = CGPoint(x: 0.0, y: 0.0)
        g.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        return g
    }()
    
    // GRABBING FACEBOOK PROFILE PICTURE
    func getProfilePic() {
        let pic = fbsdk.getUserProfilePicture()
        profileImage.image = pic
        profileImage.contentMode = .scaleAspectFill
    }
    
    
    // MAIN VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        gradient.frame = self.view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
        
        getProfilePic()
        self.view.addSubview(profileImage)
        self.view.addSubview(societyList)
        self.view.addSubview(settingsButton)
        self.view.addSubview(logoutButton)
        
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
     
        setupViews()
        animateGradient()
    }
    
    func setupViews() {
        //Profile Image
        profileImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 125).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 125).isActive = true
        
        // Society List Button
        societyList.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        societyList.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 40).isActive = true
        societyList.widthAnchor.constraint(equalToConstant: 65).isActive = true
        societyList.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        // Settings Button
        settingsButton.rightAnchor.constraint(equalTo: societyList.leftAnchor, constant: -40).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -115).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Logout Button
        logoutButton.leftAnchor.constraint(equalTo: societyList.rightAnchor, constant: 40).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -115).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func animateGradient() {
        let gradientAnimation = CABasicAnimation(keyPath: "endPoint")
        gradientAnimation.fromValue = CGPoint(x: 3.0, y: 3.0)
        gradientAnimation.toValue = CGPoint(x: 1.0, y: 1.0)
        gradientAnimation.duration = 3
        gradientAnimation.autoreverses = true
        gradientAnimation.repeatCount = .infinity
        gradient.add(gradientAnimation, forKey: nil)
    }
    
    /**** LOGOUT ****/
    
    //Handle logout methods
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
            
        } catch let logoutError {
            print(logoutError)
        }
        
        handleFacebookLogout()
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        UIApplication.shared.statusBarStyle = .default
    }
    
    //Facebook Logout Handle
    func handleFacebookLogout() {
        let loginManager = FBSDKLoginManager()
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        
        let userRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"email, name"], tokenString: accessTokenString, version: nil, httpMethod: "GET")
        
        let user = userRequest?.start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request", err ?? "Unknown error")
                return
            }
            
            print(result ?? "I don't know what happened")
        }
        
        loginManager.logOut()
        print("Successfully logged out user:", user ?? "Unknown user")
    }
}
