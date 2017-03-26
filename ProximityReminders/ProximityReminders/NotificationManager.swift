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
    
    func addLocationEvent(forReminder reminder: Reminder) -> UNLocationNotificationTrigger? {
        
        if let location = reminder.location, let reminderID = reminder.id, let reminderTypeString = reminder.type {
            
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = CLCircularRegion(center: center, radius: 50, identifier: reminderID)
            
            let reminderType = ReminderType(rawValue: reminderTypeString)
            
            if reminderType == .Arrival {
                
                region.notifyOnEntry = true
                region.notifyOnExit = false
                
            } else if reminderType == .Departure {
                
                region.notifyOnEntry = false
                region.notifyOnExit = true
                
            }
            
            return UNLocationNotificationTrigger(region: region, repeats: true)
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
    
    func addNotification(toReminder reminder: Reminder) {
        
        let eventWithLocation = self.addLocationEvent(forReminder: reminder)
        self.scheduleNewNotification(withReminder: reminder, locationTrigger: eventWithLocation)
        
    }
    
    func removeNotification(fromRemonder reminder: Reminder) {
        
        guard let reminderID = reminder.id else {
            return
        }
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [reminderID])
    }
    
}


















