//
//  ReminderDetailViewController.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/18/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreLocation

class ReminderDetailViewController: UITableViewController {
    
    var reminder: Reminder?
    
    lazy var reminderTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Pickup dry cleaning"
        textField.backgroundColor = .white
        textField.delegate = self
        
        return textField
    }()
    
    lazy var reminderAtLocationLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Reminder at Location"
        
        return label
    }()
    
    
    lazy var locationReminderSwitch: UISwitch = {
        
        let locationSwitch = UISwitch()
        locationSwitch.addTarget(self, action: #selector(toggleLocationSwitch(sender:)), for: .valueChanged)
        
        return locationSwitch
    }()
    
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
    
    let locationDetailCell = UITableViewCell()
    var reminderLocation: CLLocation?
    let locationManager = LocationManager()
    let addLocationViewController = AddLocationViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationBarSetup()
        
        setupView(forReminder: reminder)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
        self.tableView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(addLocation), name: Notification.Name(rawValue: "CheckLocationAdded"), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(forReminder reminder: Reminder?) {
        
        if let reminder = reminder {
            
            self.title = "Details"
            
            if let text = reminder.text {
                
                reminderTextField.text = text
                
            }
            
            if let location = reminder.location {
                
                locationManager.reverseLocation(location: location, completion: { (city, street) in
                    
                    self.locationDetailLabel.text = "\(city), \(street)"
                    
                })
                
                locationReminderSwitch.isOn = true
                locationDetailCell.isHidden = false
                
            } else {
                
                locationReminderSwitch.isOn = false
                locationDetailCell.isHidden = true
                
            }
            
        } else {
            
            self.title = "New Reminder"
            locationReminderSwitch.isOn = false
            locationDetailCell.isHidden = true
            
        }
        
    }

}

// MARK: - Navigation

extension ReminderDetailViewController {
    
    func navigationBarSetup() {
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePressed))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        self.navigationItem.leftBarButtonItem = cancelButton
        
    }
    
    func savePressed() {
        
        if let reminderText = reminderTextField.text {
            
            if let reminder = self.reminder {
                
                reminder.text = reminderText
                
                if let location = reminderLocation {
                    let locationToSave = Location.location(withLatitude: location.coordinate.longitude, longitude: location.coordinate.latitude)
                    reminder.location = locationToSave
                }
                
            } else {
                
                reminder = Reminder.reminder(withText: reminderText, andLocation: reminderLocation)
            }
            
            CoreDataStack.sharedInstance.saveContext()
            
        } else {
            
            self.presentAlert(withTitle: "Oops!", andMessage: "Reminders require some text")
            
        }
        
        self.dismiss(animated: true) { 
            self.reminderLocation = nil
        }
        
    }
    
    func cancelPressed() {
        self.dismiss(animated: true) { 
            self.reminderLocation = nil
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
            
            return cell
            
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
            
            return cell
            
            
        case (1, 1):
            
            locationDetailCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            locationDetailCell.contentView.addSubview(locationLabel)
            locationLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                locationLabel.centerYAnchor.constraint(equalTo: locationDetailCell.contentView.centerYAnchor, constant: -5),
                locationLabel.leadingAnchor.constraint(equalTo: locationDetailCell.contentView.leadingAnchor, constant: 15)])
            
            locationDetailCell.contentView.addSubview(locationDetailLabel)
            locationDetailLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                locationDetailLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 1),
                locationDetailLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
                locationDetailLabel.trailingAnchor.constraint(equalTo: locationDetailCell.contentView.trailingAnchor, constant: -15)])
            
            return locationDetailCell
            
            
        default:
            return cell
        }
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
            
        case (1,1):
            
            navigationController?.pushViewController(addLocationViewController, animated: true)
            
        default: break
            
        }
        
    }
    
}

// MARK: - Location

extension ReminderDetailViewController {
    
    func toggleLocationSwitch(sender: UISwitch) {
        
        if sender.isOn {
            sender.setOn(false, animated: true)
            locationDetailCell.isHidden = true
            
            reminderLocation = nil
            locationDetailLabel.text = nil
            
        } else {
            
            sender.setOn(true, animated: true)
            locationDetailCell.isHidden = false
        }
        
    }
    
    func addLocation() {
        
        reminderLocation = addLocationViewController.savedLocation
        
        if let reminderLocation = reminderLocation {
            
            locationManager.geoCoder.reverseGeocodeLocation(reminderLocation, completionHandler: { (placemarks, error) in
                
                if let placemark = placemarks?.first {
                    
                    if let city = placemark.locality, let street = placemark.thoroughfare {
                        let locationString = "\(city), \(street)"
                        self.locationDetailLabel.text = locationString
                    }
                }
                
            })
            
        } else {
            
            locationReminderSwitch.isOn = false
            locationDetailCell.isHidden = true
            
        }
        
    }
}

// MARK: - UITextFieldDelegate

extension ReminderDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        reminderTextField.resignFirstResponder()
        return true
    }
    
}

// MARK: - Gestures & UIGestureRecognizerDelegate

extension ReminderDetailViewController: UIGestureRecognizerDelegate {
    
    func tap(gesture: UITapGestureRecognizer) {
        reminderTextField.resignFirstResponder()
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let tapPoint = gestureRecognizer.location(in: self.tableView)
        
        if locationDetailCell.frame.contains(tapPoint) {
            return false
        }
        
        return true
    }
    
}

















