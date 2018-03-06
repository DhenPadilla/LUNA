//
//  AppDelegate.swift
//  LUA Application
//
//  Created by Dhen Padilla on 30/08/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let defaults = UserDefaults.standard
        
        defaults.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        //Collection View Layout for Home Screen
        let layout = UICollectionViewFlowLayout()
        
        //Facebook SDK Configure
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Firebase SDK Configure
        FIRApp.configure()
        
        let fbsdk = FacebookSDKCall.sharedApiInstance
        fbsdk.getUserEvents()
        
        
        /*if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set("No", forKey:"isFirstTime")
            defaults.synchronize()
 */
            //Setup programmatic constrainted views.
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            
            window?.rootViewController = UINavigationController(rootViewController: HomeViewController(collectionViewLayout: layout))
            
            
            UINavigationBar.appearance().barTintColor = UIColor(red: 24/255, green: 32/255, blue: 49/255, alpha: 1)
            
            
            //Get rid of black shadow underneath nav bar
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        /*
        }
        
        else {
            
        }*/
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

