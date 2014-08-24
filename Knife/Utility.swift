//
//  Utility.swift
//  Knife
//
//  Created by HuangPeng on 8/23/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationUtilityDelegate {
    func locationUpdated()
    func geometricLocationUpdated()
}

class LocationUtility: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    var delegate: LocationUtilityDelegate?
    
    var location: CLLocation?
    
    var province: String?
    var city: String?
    var zone: String?
    
     init()  {
        super.init()
        
        locationManager.delegate = self
    }
    
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func currentLocation() -> CLLocation! {
        return nil
    }
    
    func updateGeometricLocation() {
        let geocoder = CLGeocoder()
        geocoder .reverseGeocodeLocation(self.location, completionHandler: {
            (placemarks:AnyObject[]!, error:NSError!) in
            if placemarks.count > 0 {
                let placemark:CLPlacemark = placemarks[0] as CLPlacemark
                if placemark.name != nil {
                    println("name: \(placemark.name)")
                }
                if (placemark.subAdministrativeArea != nil) {
                    println("sub admin: \(placemark.subAdministrativeArea)")
                }
                if (placemark.administrativeArea != nil) {
                    println("admin: \(placemark.administrativeArea)")
                }
                if (placemark.region != nil) {
                    println("region: \(placemark.region)")
                }
                if (placemark.postalCode != nil) {
                    println("post code: \(placemark.postalCode)")
                }
                if (placemark.subLocality != nil) {
                    println("sub locality: \(placemark.subLocality)")
                }
                
                self.delegate?.geometricLocationUpdated()
            }
            })
    }
    
    //CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: AnyObject[]!) {
        println("hello")
        var location:CLLocation = locations[locations.count-1] as CLLocation
        
        if (location.horizontalAccuracy > 0) {
            println(location.coordinate)
            
            self.locationManager.stopUpdatingLocation()
            
            self.location = location
            
            self.delegate?.locationUpdated()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }

}
