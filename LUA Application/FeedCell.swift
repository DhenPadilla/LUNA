//
//  FeedCell.swift
//  LUA Application
//
//  Created by Dhen Padilla on 14/09/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit
import InMobiSDK.IMNative
import InMobiSDK.IMNativeDelegate
import MapKit

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, IMNativeDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    /*** InMobi Native Delegate Protocol required functions ***/
    var InMobiNativeAd: IMNative?
    let IM_AD_INSERTION_POSITION = 4
    
    func nativeDidFinishLoading(_ native: IMNative!) {
        self.collectionView.insertSubview(native.primaryView(ofWidth: self.collectionView.frame.size.width), at: IM_AD_INSERTION_POSITION)
        self.collectionView.reloadData()
        NSLog("InMobi Native Did finished loading");
    }
    
    func native(_ native: IMNative!, didInteractWithParams params: [AnyHashable : Any]!) {
        print("didInteractWithParams")
    }
    
    func nativeDidFinishPlayingMedia(_ native: IMNative!) {
        print("nativeDidFinishPlayingMedia")
    }
    
    func native(_ native: IMNative!, didFailToLoadWithError error: IMRequestStatus!) {
        print("didFailToLoadWithError")
    }
    
    func nativeWillPresentScreen(_ native: IMNative!) {
        print("nativeWillPresentScreen")
    }
    
    func nativeDidPresentScreen(_ native: IMNative!) {
        print("nativeDidPresentScreen")
    }
    
    func nativeWillDismissScreen(_ native: IMNative!) {
        print("nativeWillDismissScreen")
    }
    
    func nativeDidDismissScreen(_ native: IMNative!) {
        print("nativeDidDismissScreen")
    }
    
    func userWillLeaveApplication(from native: IMNative!) {
        print("userWillLeaveApplication")
    }
    
    func nativeAdImpressed(_ native: IMNative!) {
        print("nativeAdImpressed")
    }
    
    func isAdAtIndexPath(indexPath: Int) -> Bool {
        if indexPath == IM_AD_INSERTION_POSITION { return true }
        else { return false }
    }
    
    var events = Events.sharedEventsModel.getEvents()
    
    func reloadEvents() {
        self.events = Events.sharedEventsModel.getEvents()
    }
    
    let cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 0.99)//.white
        return cv
    }()
    
    
    //FacebookAPI Model
    let fbsdk = FacebookSDKCall.sharedApiInstance
    func getFacebookEvents() {
        fbsdk.getUserEvents()
        self.collectionView.reloadData()
        self.reloadEvents()
    }

    //InMobi Delegation:
    func loadUpInMobi() {
        //InMobi Ads initialisation
        InMobiNativeAd = IMNative(placementId: 1517004873829)
        InMobiNativeAd?.delegate = self
        InMobiNativeAd?.load()
    }
    
    override func setupViews() {
        super.setupViews()
        
        loadUpInMobi()
        
        getFacebookEvents()
        
        backgroundColor = .black
        
        addSubview(collectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    /******** EVENT COLLECTION VIEW STYLING **********/
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCell
        
        cell.event = events[indexPath.item]
        
        return cell
    }
    
    // On select: Present new 'EventViewController'
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eventView = EventViewController()
        eventView.event = events[indexPath.item]
        
        self.window?.rootViewController?.present(eventView, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func display(contentController content: UIViewController, on view: UIView) {
        self.window?.rootViewController?.addChildViewController(content)
        content.view.frame = view.bounds
        view.addSubview(content.view)
        content.didMove(toParentViewController: self.window?.rootViewController)
    }
    
    let mapView = MKMapView()
    
    func reorderEvents(filter: String) {
        if filter == "Date" {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.events = self.events.sorted(by: { $0.eventDate! > $1.eventDate! })
                self.collectionView.performBatchUpdates({
                    self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
                }, completion: { (finished:Bool) -> Void in })
            })
        }
        /*else if filter == "Location" {
            if let currentLocation = mapView.userLocation.location {
                print("\(currentLocation)")
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.events = self.events.sorted(by: { (CLLocation(latitude: $0.eventLatitude!, longitude:  $0.eventLongitude!).distance(from: currentLocation)) < (CLLocation(latitude:           $1.eventLatitude!, longitude: $1.eventLongitude!).distance(from: currentLocation)) })
                    self.collectionView.performBatchUpdates({
                        self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
                    }, completion: { (finished:Bool) -> Void in })
                })
            }
        }*/
        else if filter == "Alphabet" {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.events = self.events.sorted(by: { $0.eventTitle! < $1.eventTitle! })
                self.collectionView.performBatchUpdates({
                    self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
                }, completion: { (finished:Bool) -> Void in })
            })
        }
        else {
            return
        }
    }
}
