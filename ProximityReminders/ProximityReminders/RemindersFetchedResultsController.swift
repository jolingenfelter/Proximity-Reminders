//
//  RemindersFetchedResultsController.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/15/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

class RemindersFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>, NSFetchedResultsControllerDelegate {
    
    private let tableView: UITableView
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managedObjectContext: NSManagedObjectContext, tableView: UITableView) {
        
        self.tableView = tableView
        
        super.init(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.delegate = self
        
        executeFetch()
        
    }
    
    func executeFetch() {
        
        do {
            
            try performFetch()
            
        } catch let error as NSError {
            
            print("Unresolved error: \(error.localizedDescription)")
            
        }
        
    }
    
    
    // MARK: - NSFetchedResultsController Delegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        
        if controller.fetchedObjects?.count == 0 {
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
        }
    }

}
