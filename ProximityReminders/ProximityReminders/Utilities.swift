//
//  Utilities.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/26/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import MapKit

func parseAddress(location: MKPlacemark) -> String {
    
    let firstSpace = (location.subThoroughfare != nil || location.thoroughfare != nil) ? " ":""
    
    let comma = (location.subThoroughfare != nil || location.thoroughfare != nil) && (location.subAdministrativeArea != nil || location.administrativeArea != nil) ? ", " : ""
    
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
