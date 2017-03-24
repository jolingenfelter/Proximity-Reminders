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
    
    // Get CLLocation from Location
    
    func reverseLocation(location: Location, completion: @escaping(_ city: String, _ street: String) -> Void) {
        
        let locationToReverse = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        self.geoCoder.reverseGeocodeLocation(locationToReverse) { (placemarks, error) in
            
            if let placemark = placemarks?.first {
                
                guard let city = placemark.locality, let street = placemark.thoroughfare else {
                    return
                }
                
                completion(city, street)
            }
            
        }
    }
    
    func parseAddress(location: MKPlacemark) -> String {
        
        let firstSpace = (location.subThoroughfare != nil || location.thoroughfare != nil) ? " ":""
        
        let comma = (location.subThoroughfare != nil || location.thoroughfare != nil) && (location.subAdministrativeArea != nil || location.administrativeArea != nil) ? "," : ""
        
        let secondSpace = (location.subAdministrativeArea != nil && location.administrativeArea != nil) ? " " : ""
        
        let addressString = String(
            format: "%@%@%@%@%@%@%@",
            // Address Number
            location.subThoroughfare ?? "",
            firstSpace,
            // Street Name
            location.thoroughfare ?? "",
            comma,
            // City
            location.locality ?? "",
            secondSpace,
            // State,
            location.administrativeArea ?? "")
        
        return addressString
    }
    
    func dropPinAndZoom(mapView: MKMapView, placemark: MKPlacemark) {
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        let location = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        mapView.add(MKCircle(center: location.coordinate, radius: 40))
        
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

        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Unresolved error: \(error)")
    }
    
}















