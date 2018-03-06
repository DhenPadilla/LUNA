//
//  LoginController.swift
//  LUA Application
//
//  Created by Dhen Padilla on 30/08/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

// All variables are declared/initialised
// before viewDidLoad()
//
// All Methods are implemented after viewDidLoad()
//
//

import UIKit
import FBSDKLoginKit

class LoginController: UIViewController, FBSDKLoginButtonDelegate, UIWebViewDelegate {
    
    var currentUser = User.sharedUser
    
    private var topConstraint = NSLayoutConstraint()
    
    private var webViewIsOpen: Bool = false
    
    let inputContainerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.tintColor = .white
        view.layer.masksToBounds = true //If we don't do this, corner radius won't take into effect
        return view
    }()
    
    let loginRegisterButton:UIButton = { //Bryan uses 'lazy var' to give the button access to 'self'
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.layer.cornerRadius = 5
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false //Always set this property or else anchors won't work
        
        //button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    let lunaFacebookLoginButton: UIButton = {
        let fbButton = UIButton()
        fbButton.backgroundColor = UIColor(r: 89, g: 99, b: 121)
        fbButton.layer.cornerRadius = 5
        fbButton.setTitle("Login With Facebook", for: .normal)
        fbButton.setTitleColor(.white, for: .normal)
        fbButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        fbButton.translatesAutoresizingMaskIntoConstraints = false
        
        fbButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        return fbButton
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Login Logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var facebookLoginRegisterButton:FBSDKLoginButton = {
        let facebookLoginRegisterButton = FBSDKLoginButton()
        
        facebookLoginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        facebookLoginRegisterButton.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        facebookLoginRegisterButton.layer.cornerRadius = 5
        facebookLoginRegisterButton.delegate = self
        facebookLoginRegisterButton.readPermissions = ["email", "public_profile", "user_events"]//, "rsvp_event", "friends"]
        
        return facebookLoginRegisterButton
    }()
 
    let facebookLunaAuthenticationView:UIWebView = {
        let webV:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 60))
        webV.loadRequest(URLRequest(url: URL(string: "https://london-university-analytics.herokuapp.com/auth/facebook")!))
        return webV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        
        facebookLunaAuthenticationView.delegate = self
        
        isUserLoggedIn()
        
        if (FBSDKAccessToken.current()) != nil  {
            loginButtonDidLogOut(facebookLoginRegisterButton)
        }
        
        view.addSubview(facebookLoginRegisterButton)
        view.addSubview(lunaFacebookLoginButton)
        view.addSubview(facebookLunaAuthenticationView)
        
        layout()
        
        assignBackground()

        setupFacebookLoginRegisterButton()
    }
    
    private func isUserLoggedIn() {
        if let accessToken = currentUser.getUserID() as? String {
            print("ACCESS TOKEN FROM LUNA: " + accessToken)
        }
        FBSDKGraphRequest(graphPath: "/me", parameters: ["Fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request", err ?? "Unknown error")
                return
            }
            
            print(result ?? "I don't know what happened")
            self.dismiss(animated: true, completion: nil)
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    private func layout() {
        facebookLunaAuthenticationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(facebookLunaAuthenticationView)
        facebookLunaAuthenticationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        facebookLunaAuthenticationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        facebookLunaAuthenticationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc private func loginButtonTapped() {
        print("Button Tapped")
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            self.facebookLunaAuthenticationView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
            self.facebookLunaAuthenticationView.layer.cornerRadius = 20
            if #available(iOS 11.0, *) {
                self.facebookLunaAuthenticationView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
            self.view.layoutIfNeeded()
        })
        transitionAnimator.startAnimation()
        webViewIsOpen = true
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("REQUEST URL: " + String(describing: request.url))
        if String(describing: request.url).range(of:"https://london-university-analytics.herokuapp.com/auth/facebook_callback") != nil {
            print("SHOULD CLOSE WINDOW")
            
            print("URL: \(request.url!)")
            
            tryAccessingLUNAUser(url: request.url!)
        }
        
        return true
    }
    
    func tryAccessingLUNAUser(url: URL) {
        guard let url = url as? URL else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                print("DATA: " + String(describing: data))
                
                var accessToken = ""
                
                //Decode retrived data with JSONDecoder and assing type of Article object
                if let info = data as? [String: Any] {
                    print("DATA: \(info)")
                    accessToken = info["access_token"] as! String
                    print("GOT ACCESS TOKEN: \(accessToken)")
                }
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    //print(articlesData)
                    self.currentUser.setAccessToken(token: accessToken)
                }
            }
            
        }.resume()
    }
    
    func checkForFBAccessTokenAndDismiss() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            self.topConstraint = self.facebookLunaAuthenticationView.topAnchor.constraint(equalTo: self.view.bottomAnchor)
            self.view.layoutIfNeeded()
        })
        transitionAnimator.startAnimation()
        webViewIsOpen = false
    }
    
    
    func setupFacebookLoginRegisterButton() {
        for const in facebookLoginRegisterButton.constraints{
            if const.firstAttribute == NSLayoutAttribute.height && const.constant == 28 {
                facebookLoginRegisterButton.removeConstraint(const)
            }
        }
        
        lunaFacebookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lunaFacebookLoginButton.bottomAnchor.constraint(equalTo: facebookLoginRegisterButton.topAnchor, constant: -100).isActive = true
        lunaFacebookLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9 / 10).isActive = true
        lunaFacebookLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //Constraints: X, Y, Width & Height - Name Text Field
        facebookLoginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookLoginRegisterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        facebookLoginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9 / 10).isActive = true
        facebookLoginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        //Using the bottom of inputContainerView as the anchor of this button - Positioned relative to the bottom of the view.
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook\n")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (error != nil) {
            print(error)
            return
        }
        
        showFacebookEmailAddress()
    }
    
    func showFacebookEmailAddress() {
        
        //Create Facebook Access Token
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["Fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request", err ?? "Unknown error")
                return
            }
            
            print(result ?? "I don't know what happened")
            self.dismiss(animated: true, completion: nil)
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    
    func assignBackground(){
        let background = UIImage(named: "Login Background")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        let clouds = ["Login Cloud 1", "Login Cloud 2", "Login Cloud 3"]
        let cloudsImages = clouds.map { UIImage(named: $0) }
        for i in 0...(cloudsImages.count - 1) {
            let cloudView = UIImageView(image: cloudsImages[i])
            view.addSubview(cloudView)
            let (x, y) = randomisePosition()
            cloudView.frame.origin.x = x
            cloudView.frame.origin.y = y
            UIView.animate(withDuration: 30, animations: {cloudView.transform.translatedBy(x: 100, y: 0)})
        }
    }
    
    func randomisePosition() -> (x: CGFloat, y: CGFloat) {
        var xPos = CGFloat()
        var yPos = CGFloat()
        
        xPos = (CGFloat(arc4random_uniform(UInt32((self.view?.frame.size.width)!))))
        yPos = (CGFloat(arc4random_uniform(UInt32((self.view?.frame.size.height)!))))
        
        if (xPos > ((self.view?.bounds.width)! - (self.view?.bounds.width)! * 0.20)) {
            xPos = xPos.truncatingRemainder(dividingBy: ((self.view?.bounds.width)! - (self.view?.bounds.width)! * 0.20))
        }
        if (yPos > ((self.view?.bounds.height)! - (self.view?.bounds.width)! * 0.20)) {
            yPos = yPos.truncatingRemainder(dividingBy: ((self.view?.bounds.height)! - (self.view?.bounds.width)! * 0.20))
        }
        
        return (xPos, yPos)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

