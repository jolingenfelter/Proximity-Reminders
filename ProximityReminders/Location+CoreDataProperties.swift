//
//  Location+CoreDataProperties.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/14/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import CoreData

extension Location {
    
    static let entityName = "\(Location.self)"
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }
    
    class func location(withLatitude latitude: Double, longitude: Double) -> Location {
        
        let location = NSEntityDescription.insertNewObject(forEntityName: Location.entityName, into: CoreDataStack.sharedInstance.managedObjectContext) as! Location
        
        location.latitude = latitude
        location.longitude = longitude
        
        return location
        
    }

    
}


extension Location {
    
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var reminder: Reminder?

}
