//
//  Reminder+CoreDataProperties.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/14/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder");
    }

    @NSManaged public var text: String?
    @NSManaged public var completed: Bool
    @NSManaged public var id: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var location: Location?

}
