//
//  MapViewExtension.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 9/18/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    
    func dropPinAndZoom(placemark: MKPlacemark) {
        
        self.removeAnnotations(self.annotations)
        self.removeOverlays(self.overlays)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        self.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        self.setRegion(region, animated: true)
        
        let location = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        self.add(MKCircle(center: location.coordinate, radius: 50))
        
    }
    
    func searchAndZoomInOn(searchCompletion: MKLocalSearchCompletion, completion: @escaping (CLLocation) -> Void) {
        
        let searchRequest = MKLocalSearchRequest(completion: searchCompletion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, error) in
            
            guard let response = response, let mapItem = response.mapItems.first else {
                return
            }
            
            let placemark = mapItem.placemark
            
            guard let location = placemark.location else {
                return
            }
            
            completion(location)
            
            DispatchQueue.main.async {
                self.dropPinAndZoom(placemark: placemark)
            }
            
        }
        
    }

}
