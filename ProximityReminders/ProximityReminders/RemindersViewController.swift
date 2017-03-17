//
//  ViewController.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/13/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class RemindersViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.register(ReminderCell.self, forCellReuseIdentifier: ReminderCell.reuseIdentifier)
        
        return tableView
    }()
    
    lazy var dataSource: RemindersDataSource = {
        
        let reminderDataSource = RemindersDataSource(fetchRequest: Reminder.remindersFetchRequest, tableView: self.tableView)
        
        return reminderDataSource
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
        tableView.dataSource = dataSource
        self.title = "Proximity Reminders"
        
        let reminder = Reminder.reminder(withText: "hello world")
        CoreDataStack.sharedInstance.saveContext()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        // Layout tableView
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK : - UITableViewControllerDelegate

extension RemindersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

// MARK: - Navigation

extension RemindersViewController {
    
    func navigationBarSetup() {
        
        let addReminderButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newReminderPressed))
        addReminderButton.tintColor = .white
        navigationItem.rightBarButtonItem = addReminderButton
        
    }
    
    func newReminderPressed() {
        
    }
}




















