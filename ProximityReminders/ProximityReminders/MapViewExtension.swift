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

    
}
