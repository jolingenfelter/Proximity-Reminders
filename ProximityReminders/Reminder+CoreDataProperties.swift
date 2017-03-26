//
//  Reminder+CoreDataProperties.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/14/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension Reminder {
    
    static let entityName = "\(Reminder.self)"
    
    @nonobjc static var remindersFetchRequest: NSFetchRequest<NSFetchRequestResult> = {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Reminder.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request;
        
    }()
    
    
    class func reminder(withText text: String) -> Reminder {
        
        let reminder = NSEntityDescription.insertNewObject(forEntityName: Reminder.entityName, into: CoreDataStack.sharedInstance.managedObjectContext) as! Reminder
        
        reminder.date = Date()
        reminder.id = UUID().uuidString
        reminder.text = text
        
        return reminder
    }
    
    class func reminder(withText text: String, type: String?, andLocation location: CLLocation?) -> Reminder {
        
        let reminder = Reminder.reminder(withText: text)
        reminder.type = type
        reminder.addLocation(location: location)
        
        return reminder
        
    }
    
    func addLocation(location: CLLocation?) {
        
        if let location = location {
            
            let reminderLocation = Location.location(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            self.location = reminderLocation
        }
        
    }
    
}


extension Reminder {

    @NSManaged public var text: String?
    @NSManaged public var completed: Bool
    @NSManaged public var id: String?
    @NSManaged public var date: Date?
    @NSManaged public var location: Location?
    @NSManaged public var type: String?

}
