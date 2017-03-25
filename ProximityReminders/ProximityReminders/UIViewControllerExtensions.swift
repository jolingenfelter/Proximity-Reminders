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
        
        if self.presentedViewController == nil {
            self.present(alert, animated: true, completion: nil)
        } else {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}
