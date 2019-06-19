//
//  ModelController.swift
//  Alarm
//
//  Created by Albert Yu on 6/17/19.
//  Copyright © 2019 AlbertLLC. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotification(for alarm: Alarm)
    func cancelUserNotification(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotification(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Wake up!"
        notificationContent.subtitle = "Your alarm is finished!"
        notificationContent.badge = 1
        notificationContent.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.minute, .second], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancelUserNotification(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
        
    }
    
    
}

class AlarmController: AlarmScheduler {
    static let shared = AlarmController()
    
    var alarms: [Alarm] = []
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let newAlarm =  Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(newAlarm)
        saveToPersistentStore()
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.enabled = enabled
        alarm.name = name
        alarm.fireDate = fireDate
        saveToPersistentStore()
    }
    
    func delete(alarm: Alarm) {
        guard let index = alarms.firstIndex(of: alarm) else {return}
        alarms.remove(at: index)
        saveToPersistentStore()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        if alarm.enabled{
            scheduleUserNotification(for: alarm)
        } else{
            cancelUserNotification(for: alarm)
        }
    }
    
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "alarm.json"
        let url = documentDirectory.appendingPathComponent(fileName)
        return url
    }

    
    func saveToPersistentStore() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(alarms)
            try data.write(to: fileURL())
        } catch let error {
            print("Error saving to persistent store: \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() -> [Alarm] {
        let jsonDecoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try jsonDecoder.decode([Alarm].self, from: data)
            return alarms
        } catch let error {
            print("Error loading from persistent store: \(error.localizedDescription)")
        }
        return []
    }
}
