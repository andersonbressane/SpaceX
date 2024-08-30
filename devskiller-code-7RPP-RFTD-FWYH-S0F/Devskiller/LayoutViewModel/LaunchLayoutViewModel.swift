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
    
    var pathString: String? {
        self.launch.links?.patch?.small
    }
    
    var rocket: Launch.Rocket? {
        self.launch.rocket
    }
    
    var rocketString: String {
        self.launch.rocket != nil ? "\(self.rocket?.name ?? "") / \(self.rocket?.type ?? "")" : ""
    }
    
    var missionName: String {
        self.launch.name ?? ""
    }
    
    var launchDateUnix: TimeInterval? {
        self.launch.dateUnix
    }
    
    var launchDate: Date? {
        guard let dateUnix = self.launchDateUnix else { return nil }
        return Date(timeIntervalSince1970: dateUnix)
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
        if days < 0 {
            return "\(days * -1) days since now"
        } else if days > 0 {
            return "\(days) days from now"
        } else {
            return "Today"
        }
    }
    
    var articleURL: URL? {
        guard let article = self.launch.links?.article, let url = URL(string: article) else {
            return nil
        }
        
        return url
    }
    
    var wikiPediaURL: URL? {
        guard let wikipedia = self.launch.links?.wikipedia, let url = URL(string: wikipedia) else {
            return nil
        }
        
        return url
    }
    
    var webCastURL: URL? {
        guard let webcast = self.launch.links?.webcast, let url = URL(string: webcast) else {
            return nil
        }
        
        return url
    }
    
    var hasLink: Bool {
        return (articleURL != nil || wikiPediaURL != nil  || webCastURL != nil )
    }
}
