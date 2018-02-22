//
//  HomeViewController.swift
//  LUA Application
//
//  Created by Dhen Padilla on 30/08/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    
    var currentUserID: Int?
        
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //FacebookAPI Model
    let fbsdk = FacebookSDKCall.sharedApiInstance
    func getFacebookEvents() {
        fbsdk.getUserEvents()
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call Facebook API
        getFacebookEvents()
        
        //Change the Status Bar Style
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Feed view
        setupCollectionView()
        
        //Navigation Bar Attributes
        // ------- SYSTEM TYPE NAV LOGOUT -------- //
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(handleLogout))
        
        navigationController?.navigationBar.isTranslucent = false
        
        //Firebase Authentication - Handles logout (Might be able to delete this)
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 1)
        }
        
        setupMenuBar()
        setupNavBarButtons()
    }
    
    
    /***** OPENING EVENT VIEW CONTROLLER *****/
    
    func openNewEvent(event: Event) {
        let eventVC = EventViewController()
        eventVC.event = event
        self.navigationController?.pushViewController(eventVC, animated: true)
    }
    
    
    /***** SETTING UP THE MAIN COLLECTION VIEW *****/
    
    func setupCollectionView() {
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 70, 0)
        collectionView?.isPagingEnabled = true
    }
    
    /*********** Menu Bar *************/
    
    
    lazy var menuBar: MenuBar = {
        
        let mb = MenuBar()
        mb.homeController = self
        return mb
        
    }()
    
    private func setupMenuBar() {
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        
        menuBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
    }
    
    private func setupNavBarButtons() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort By", style: .plain, target: self, action: #selector(handleFilter)) //Change logout button to something else
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        /*
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout)) //Change logout button to something else
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
 */
            
        //navigationItem.title = "Home"
        let logo = UIImage(named: "Navigation Logo")
        navigationItem.titleView = UIImageView(image: logo)
        navigationItem.titleView?.contentMode = .scaleAspectFill
    }
    
    
    //Swipe to move to different UIView.
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = (targetContentOffset.pointee.x / view.frame.width)
        
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        if indexPath.item == 0 {
            let homeFeedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
            print("HOME PAGE: \(indexPath.item)")
            homeFeedCell.getFacebookEvents()
            return homeFeedCell
        }
        
        else if indexPath.item == 1 {
            let mapView = MapView()
            print("MAP PAGE: \(indexPath.item)")
            display(contentController: mapView, on: cell)
        }
        
        else if indexPath.item == 2 {
            let homeFeedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
            print("2nd PAGE: \(indexPath.item)")
            homeFeedCell.getFacebookEvents()
            return homeFeedCell
        }
        
        /*else if indexPath.item == 3 {
            let userProfileView = ProfilePageView()
            print("PROFILE PAGE: \(indexPath.item)")
            display(contentController: userProfileView, on: cell)
        }*/
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func display(contentController content: UIViewController, on view: UIView) {
        self.addChildViewController(content)
        content.view.frame = view.bounds
        view.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    
    
    /**** FILTER ****/
    let filtersLauncher = FilterLauncher()
    
    //Handle filter method
    func handleFilter() {
        filtersLauncher.parentViewController = self
        filtersLauncher.showFilters()
    }
    
    func orderEventsBy(filterTitle: String) {
        //print("ORDER EVENTS BY: \(filterTitle)")
        if let cvCells = collectionView?.visibleCells as? [FeedCell] {
            cvCells[0].reorderEvents(filter: filterTitle)
        }
    }
    
    /**** Change feed and menu bar when swiping ****/
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath:IndexPath = NSIndexPath(item: menuIndex, section: 0) as IndexPath
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
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
