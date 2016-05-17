//
//  mapViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 3/18/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController,CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var storeMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var searchText = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        storeMapView.showsUserLocation = true
   
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.last != nil) {
            currentLocation = locations.last
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = searchText
            
            let myspan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            let myregion = MKCoordinateRegion(center: self.currentLocation!.coordinate, span:  myspan)
            request.region = myregion
            
            let search = MKLocalSearch(request: request)
            search.startWithCompletionHandler { response, error in
                guard let response = response else {
                    print("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
                    return
                }
                
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    self.storeMapView.addAnnotation(annotation)
                    
                }
            }
            
            
        //show a region around current user location
            
        let region = MKCoordinateRegionMakeWithDistance(
                    self.currentLocation!.coordinate, 10000, 10000)
            
        storeMapView.setRegion(region, animated: true)
            
            
            
        } else {
            print("failed to fetch current user location")
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
