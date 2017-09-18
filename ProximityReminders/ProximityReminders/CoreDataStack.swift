//
//  CoreDataStack.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/14/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let sharedInstance = CoreDataStack()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
        
    }()
    
    lazy var manangedObjectModel: NSManagedObjectModel = {
        
        let modelURL = Bundle.main.url(forResource: "ProximityReminders", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
        
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.manangedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("ProximityReminders.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            
        } catch {
        
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.jolingenfelter.proximityreminders.error", code: 9999, userInfo: dict)
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
        
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
        
    }()
    
    // MARK: - CoreData saving support
    
    func saveContext() {
        
        if managedObjectContext.hasChanges {
            
            do {
                
                try managedObjectContext.save()
                
            } catch {
                
                let error = error as NSError
                NSLog("Unresolved error \(error), \(error.userInfo)")
                abort()
                
            }
            
        }
        
    }
    
}
