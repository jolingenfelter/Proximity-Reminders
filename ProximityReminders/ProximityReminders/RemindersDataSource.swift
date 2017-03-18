//
//  RemindersDataSource.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/15/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RemindersDataSource: NSObject {
    
    let tableView: UITableView
    private let managedObjectContext = CoreDataStack.sharedInstance.managedObjectContext
    let fetchedResultsController: RemindersFetchedResultsController
    
    init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, tableView: UITableView) {
        
        self.tableView = tableView
        
        let fetchedResultsController = RemindersFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, tableView: tableView)
        
        self.fetchedResultsController = fetchedResultsController
        
        super.init()
        
    }
    
}

// MARK: - UITableViewDataSource

extension RemindersDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderCell.reuseIdentifier) as! ReminderCell
        
        let reminder = fetchedResultsController.object(at: indexPath) as! Reminder
        
        cell.configureCell(forReminder: reminder)
        
        cell.completedButton.addTarget(self, action: #selector(toggleCompletedButton(sender:)), for: .touchUpInside)
        cell.completedButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
}

// MARK: - Mark Reminder Completed

extension RemindersDataSource {
    
    func toggleCompletedButton(sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        
        guard let indexPath = self.tableView.indexPathForRow(at: buttonPosition) else {
            return
        }
        
        
        let reminder = fetchedResultsController.object(at: indexPath) as! Reminder
        let cell = tableView.cellForRow(at: indexPath) as! ReminderCell
        
        if reminder.completed == false {
            reminder.completed = true
            cell.completedButton.setImage(UIImage(named: "check"), for: .normal)
        } else {
            reminder.completed = false
            cell.completedButton.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        
        CoreDataStack.sharedInstance.saveContext()
        
    }
}


