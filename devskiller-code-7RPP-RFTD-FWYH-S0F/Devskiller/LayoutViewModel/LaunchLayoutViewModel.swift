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
    
    var rocket: Launch.Rocket? {
        self.launch.rocket
    }
    
    var rocketString: String {
        "\(self.rocket?.name ?? "") / \(self.rocket?.type ?? "")"
    }
    
    var missionName: String {
        self.launch.name ?? ""
    }
    
    var launchDateUnix: TimeInterval {
        self.launch.dateUnix ?? 0
    }
    
    var launchDate: Date? {
        Date(timeIntervalSince1970: self.launchDateUnix)
    }
    
    var loadState: LoadState = .none
    
    var launchDateTimeString: String {
        guard let launchDate = launchDate else { return "" }
        
        return launchDate.getFormattedDateString(format: "yyyy-MM-dd 'at' HH:mm:ss")
    }
    
    var details: String {
        self.launch.details ?? ""
    }
    
    var succeed: Bool {
        self.launch.success ?? false
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
    
    func getString() -> String {
        return "\n\nMission: \(missionName)\nDate/Time: \(self.launchDateTimeString) \(self.rocket != nil ? "\nRocket: \(rocket?.name ?? "") / \(rocket?.type ?? "")" : "")\n\(self.daysInString)\nSuccess: \(self.succeed)\nDetails: \(self.details)"
    }
}
