//  MapView.swift
//  LUA Application
//
//  Created by Dhen Padilla on 25/10/2017.
//  Copyright © 2017 dhenpadilla. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //var locations: [String]
    var events = Events.sharedEventsModel.getEvents()
    
    var locationManager = CLLocationManager()
    
    let mainMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainMapView.delegate = self
        
        view.addSubview(mainMapView)
        
        setupMapview()
        
        getEventLocations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func setupMapview() {
        //Set constraints on the map view:
        mainMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainMapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainMapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //Other map view stuff
        mainMapView.showsUserLocation = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingLocation()
            let userLocation = mainMapView.userLocation.coordinate
            let viewRegion = MKCoordinateRegionMakeWithDistance(
                userLocation, 2000, 2000)
            mainMapView.setRegion(viewRegion, animated: false)
            //mainMapView.centerCoordinate = userLocation
        }
 
        //Zoom to user location
        let userLocation = mainMapView.userLocation.coordinate
        let viewRegion = MKCoordinateRegionMakeWithDistance(
            userLocation, 2000, 2000)
        mainMapView.setRegion(viewRegion, animated: false)
        //mainMapView.centerCoordinate = userLocation
        
        
        DispatchQueue.main.async {
            //self.locationManager.startUpdatingLocation()
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragMap))
    
    func didDragMap(_ gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.began) {
            print("Map drag began")
            self.locationManager.stopUpdatingLocation()
        }
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            print("Map drag ended")
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        //let userLocation = mainMapView.userLocation.coordinate
        //self.mainMapView.centerCoordinate = userLocation
    }
    
    /*func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.mainMapView.centerCoordinate = userLocation.coordinate
        locationManager.stopUpdatingLocation()
    }*/
    
    func getEventLocations() {
        for i in 0...10 {
            if let lat = events[i].eventLatitude, let long = events[i].eventLongitude {
                let latCLLoc = CLLocationDegrees(lat)
                let longCLLoc = CLLocationDegrees(long)
                let coordinate = CLLocationCoordinate2D(latitude: latCLLoc, longitude: longCLLoc)
                
                if let title = events[i].eventTitle, let locationTitle = events[i].eventLocationStreet {
                    let location = Location(title: title, locationName: locationTitle, coordinate: coordinate)
                    mainMapView.addAnnotation(location)
                }
            }
        }
    }
}
