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
    
    let instructionsLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
        tableView.dataSource = dataSource
        self.title = "Proximity Reminders"
        
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
        
        let reminder = dataSource.fetchedResultsController.object(at: indexPath) as! Reminder
        
        if reminder.completed == false {
            
            let reminderDetailViewController = ReminderDetailViewController(style: .grouped)
            reminderDetailViewController.reminder = reminder
            let navigationController = UINavigationController(rootViewController: reminderDetailViewController)
            self.present(navigationController, animated: true, completion: nil)
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let reminder = dataSource.fetchedResultsController.object(at: indexPath) as! Reminder
        let cell = cell as! ReminderCell
        cell.selectionStyle = .none
        
        let lineView = UIView(frame: CGRect(x: 15, y: cell.contentView.frame.size.height - 1.0, width: cell.contentView.frame.size.width - 20, height: 0.75))
        
        lineView.backgroundColor = UIColor(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 0.8)
        cell.contentView.addSubview(lineView)
        
        if reminder.completed == true {
            cell.completedButton.setImage(UIImage(named: "check"), for: .normal)
            cell.reminderTextLabel.textColor = .lightGray
            
            if let reminder = reminder.text {
                let attributedText = NSMutableAttributedString(string: reminder)
                attributedText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributedText.length))
                cell.reminderTextLabel.attributedText = attributedText
            }
            
        } else {
            cell.completedButton.setImage(UIImage(named: "uncheck"), for: .normal)
            cell.reminderTextLabel.textColor = .black
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

// MARK: - Navigation

extension RemindersViewController {
    
    func navigationBarSetup() {
        
        let addReminderButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newReminderPressed))
        addReminderButton.tintColor = .white
        navigationItem.rightBarButtonItem = addReminderButton
        
    }
    
    @objc func newReminderPressed() {
        
        let reminderDetailViewController = ReminderDetailViewController(style: .grouped)
        let navigationController = UINavigationController(rootViewController: reminderDetailViewController)
        
        self.present(navigationController, animated: true, completion: nil)
        
    }
}
