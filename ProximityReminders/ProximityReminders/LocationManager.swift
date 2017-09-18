//
//  LocationManager.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/19/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject {
    
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var onLocationFix: ((CLPlacemark?, Error?) -> Void)?
    
    override init () {
        
        super.init()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        manager.delegate = self
        getPermission()
        
    }
    
    fileprivate func getPermission() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestAlwaysAuthorization()
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways {
            manager.requestLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            
            if let onLocationFix = self.onLocationFix {
                onLocationFix(placemarks?.first, error)
            }
        }

        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Unresolved error: \(error)")
    }
    
}
