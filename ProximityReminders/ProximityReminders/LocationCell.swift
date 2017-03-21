//
//  LocationCell.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/21/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    static let reuseIdentifier = "\(LocationCell.self)"
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
        // TitleLabel
        
        contentView.addSubview(titleLabel)
        titleLabel.font = titleLabel.font.withSize(14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10)
            ])
        
        // SubtitleLabel
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.font = subtitleLabel.font.withSize(10)
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1)
            ])
        
    }

}
