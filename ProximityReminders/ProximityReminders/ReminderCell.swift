//
//  ReminderCell.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/16/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    static let reuseIdentifier = "\(ReminderCell.self)"
    
    let reminderTextLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    let completedButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override func layoutSubviews() {
        
        self.contentView.frame = self.bounds
        
        contentView.addSubview(reminderTextLabel)
        reminderTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reminderTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            reminderTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            reminderTextLabel.widthAnchor.constraint(equalToConstant: 250)
            ])
        
        contentView.addSubview(completedButton)
        completedButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completedButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            completedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            completedButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            completedButton.widthAnchor.constraint(equalToConstant: 30)
            ])
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(forReminder reminder: Reminder) {
        
        reminderTextLabel.text = reminder.text
        
    }

}
