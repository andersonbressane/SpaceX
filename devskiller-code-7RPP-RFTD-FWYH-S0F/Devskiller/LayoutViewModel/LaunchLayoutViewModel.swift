//
//  LaunchLayoutViewModel.swift
//  Devskiller
//
//  Created by Anderson Franco on 25/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import Foundation

class LaunchLayoutViewModel {
    private let launch: Launch
    
    init(launch: Launch) {
        self.launch = launch
    }
    
    var rocket: Rocket?
    
    var missionName: String {
        self.launch.name
    }
    
    var launchDateUnix: TimeInterval {
        self.launch.dateUnix ?? 0
    }
    
    var launchDate: Date? {
        Date(timeIntervalSince1970: self.launchDateUnix)
    }
    
    var launchDateTimeString: String {
        guard let launchDate = launchDate else { return "" }
        
        return launchDate.getFormattedDateString(format: "yyyy-MM-dd 'at' HH:mm:ss")
    }
    
    var details: String {
        self.launch.details ?? ""
    }
    
    var daysInString: String {
        let days = Date.numberOfDaysBetween(Date(), and: self.launchDate!)
        if days <= 0 {
            return "\(days * -1) days since now"
        } else if days > 0 {
            return "\(days) days from now"
        } else {
            return "Today"
        }
    }
    
    func fetchRocket() {
        if self.rocket == nil {
            
        }
    }
    
    func getString() -> String {
        return "\n\nMission: \(missionName)\nDate/Time: \(self.launchDateTimeString) \n\(self.daysInString)\nDetails: \(self.details)"
    }
}
