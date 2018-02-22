//
//  LoginController.swift
//  LUA Application
//
//  Created by Dhen Padilla on 30/08/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginController: UIViewController, FBSDKLoginButtonDelegate {
    
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
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error ?? "Unknown Error")
                return
            }
            
            //Successfully logged in
            self.dismiss(animated: true, completion: nil)
            UIApplication.shared.statusBarStyle = .lightContent

        })
    }
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }
        else {
            handleRegister()
        }
    }
    
    func handleRegister() {
        //Use a guard statement: Use where input text is optional (Stops the action)
        
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error ?? "Unkown Error")
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //Successfully authenticated user
            
            let ref = FIRDatabase.database().reference(fromURL: "https://luaapp-477c9.firebaseio.com/")
            
            //Child reference:
            let usersReference = ref.child("users").child(uid)
            let values = ["Name": name, "Email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err ?? "Unkown error")
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
                UIApplication.shared.statusBarStyle = .lightContent
                
                print("Saved user successfully into Firebase DB")
                
            })
        })
    }
    
    let nameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)//(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameTextField: UITextField = {

        let textField = UITextField()
        textField.placeholder = "Name"
        textField.textColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)//(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.textColor = UIColor.white//(r: 61, g: 91, b: 151)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textColor = UIColor.white//(r: 61, g: 91, b: 151)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true //Masked password
        return textField
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Login Logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //Toggle
    let loginRegisterSegmentedControl: UISegmentedControl = { //Bryan uses lazy var again to access self
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor(r: 61, g: 91, b: 151)
        sc.layer.backgroundColor = UIColor.white.cgColor
        sc.layer.cornerRadius = 5
        sc.selectedSegmentIndex = 0 //select index of array which is highlighted
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
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
 
 

    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //Change height of inputContainerView
        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 1 ? 150 : 100
        
        //Change height of name Text field
        nameTextFieldHeightAnchor?.isActive = false
        nameTextField.placeholder = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? nil : "Name"
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 1 ? 1/3 : 0)
        nameTextFieldHeightAnchor?.isActive = true
        
        //Change height of email Text field
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 1 ? 1/3 : 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        //Change height of password Text field
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 1 ? 1/3 : 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        assignBackground()
        
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "Login Background")!)//.white //(r: 61, g: 91, b: 151)
        
        
        if (FBSDKAccessToken.current()) != nil  {
            loginButtonDidLogOut(facebookLoginRegisterButton)
        }
        
        //view.addSubview(inputContainerView)
        //view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        //view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(facebookLoginRegisterButton)
        
        //setupInputContainerView()
        //setupLoginRegisterButton()
        setupLogoImage()
        //setupRegisterSegmentedControl()
        setupFacebookLoginRegisterButton()
    }
    
    
    func setupRegisterSegmentedControl() {
        //Constraints: X, Y, Width & Height - Main
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 130).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func setupLogoImage() {
        //Constraints: X, Y, Width & Height - Logo image
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    //Changing View anchors
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    
    func setupInputContainerView() {
        //Constraints: X, Y, Width & Height - Main
        
        let uiColorBorderColor = UIColor(r: 61, g: 91, b: 151).cgColor//.white.cgColor
        
        inputContainerView.layer.borderColor = uiColorBorderColor
        inputContainerView.layer.borderWidth = 1
        
        // Whole box constraint
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.topAnchor.constraint(equalTo: loginRegisterSegmentedControl.bottomAnchor, constant: 12).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 100)
        inputContainerViewHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeperatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeperatorView)
        inputContainerView.addSubview(passwordTextField)
        
        
        //Constraints: X, Y, Width & Height - Name Text Field
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.placeholder = nil
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0)
        nameTextFieldHeightAnchor?.isActive = true
        
        //Constraints: X, Y, Width & Height - Name Seperator
        nameSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints: X, Y, Width & Height - Email Text Field
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        //Constraints: X, Y, Width & Height - Email Seperator
        emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Constraints: X, Y, Width & Height - Password Text Field
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
        
    }
    
    func setupFacebookLoginRegisterButton() {
        for const in facebookLoginRegisterButton.constraints{
            if const.firstAttribute == NSLayoutAttribute.height && const.constant == 28 {
                facebookLoginRegisterButton.removeConstraint(const)
            }
        }
        
        //Constraints: X, Y, Width & Height - Name Text Field
        facebookLoginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookLoginRegisterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        //facebookLoginRegisterButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        //facebookLoginRegisterButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 15).isActive = true
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
        
        //Construct auth credential:
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with facebook user", error ?? "Unkown error")
                return
            }
            
            print("Logged in successfully with facebook user: ", user ?? "Unknown User")
        })
        
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
        //imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .default }
    
}

