//
//  ReminderDetailViewController.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/18/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class ReminderDetailViewController: UITableViewController {
    
    var reminder: Reminder?
    
    lazy var reminderTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Pickup dry cleaning"
        textField.backgroundColor = .white
        
        return textField
    }()
    
    lazy var reminderAtLocationLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Reminder at Location"
        
        return label
    }()
    
    
    var locationReminderSwitch = UISwitch()
    
    lazy var locationLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Location"
        
        return label
    }()
    
    lazy var locationDetailLabel: UILabel = {
    
        let label = UILabel()
        label.font = label.font.withSize(10)
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView(forReminder: reminder)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(forReminder reminder: Reminder?) {
        
        if reminder == nil {
            self.title = "New Reminder"
        } else {
            self.title = "Details"
        }
        
    }

}

// MARK: - UITableViewDataSource Methods

extension ReminderDetailViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return 1
            
        case 1:
            return 2
            
        default: return 0
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            
            cell.contentView.addSubview(reminderTextField)
            reminderTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                reminderTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                reminderTextField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                reminderTextField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15),
                reminderTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15)
                ])
            
            
        case (1, 0):
            
            cell.contentView.addSubview(reminderAtLocationLabel)
            reminderAtLocationLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                reminderAtLocationLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                reminderAtLocationLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15)])
            
            cell.contentView.addSubview(locationReminderSwitch)
            locationReminderSwitch.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                locationReminderSwitch.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                locationReminderSwitch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10)])
            
            
        case (1, 1):
            
            cell.contentView.addSubview(locationLabel)
            locationLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                locationLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: -5),
                locationLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 15)])
            
            cell.contentView.addSubview(locationDetailLabel)
            locationDetailLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                locationDetailLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 1),
                locationDetailLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
                locationDetailLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15)])
            
            
        default:
            break
        }
        
        return cell
        
    }
    
}

// MARK: - UITableViewDelegate Methods

extension ReminderDetailViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.section, indexPath.row) {
            
        case (0,0), (1,0):
            
            return tableView.rowHeight
            
            
        case (1,1):
            
            return 60
        
        default:
            
            return tableView.rowHeight
            
        }
        
    }
    
}
