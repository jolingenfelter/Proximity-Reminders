//
//  NotificationManager.swift
//  ProximityReminders
//
//  Created by Joanna Lingenfelter on 3/25/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications

struct NotificationManager {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func addLocationEvent(forReminder reminder: Reminder, andReminderType reminderType: ReminderType) -> UNLocationNotificationTrigger? {
        
        if let location = reminder.location, let reminderID = reminder.id {
            
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = CLCircularRegion(center: center, radius: 50, identifier: reminderID)
            
            
            switch reminderType {
            case .Arrival:
                
                region.notifyOnEntry = true
                region.notifyOnExit = false
                
            case .Departure:
                
                region.notifyOnEntry = false
                region.notifyOnExit = true
                
            }
            
            return UNLocationNotificationTrigger(region: region, repeats: false)
        }
        
        return nil
        
    }
    
    func scheduleNewNotification(withReminder reminder: Reminder, locationTrigger trigger: UNLocationNotificationTrigger?) {
        
        if let reminderText = reminder.text, let reminderID = reminder.id, let notificationTrigger = trigger {
            
            let content = UNMutableNotificationContent()
            content.body = reminderText
            content.sound = UNNotificationSound.default()
            
            let request = UNNotificationRequest(identifier: reminderID, content: content, trigger: notificationTrigger)
            
            notificationCenter.add(request)
            
        }
        
    }
    
}


















