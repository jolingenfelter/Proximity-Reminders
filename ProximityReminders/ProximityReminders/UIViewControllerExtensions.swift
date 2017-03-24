//
//  UIViewControllerExtensions.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/24/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(withTitle title: String, andMessage message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
