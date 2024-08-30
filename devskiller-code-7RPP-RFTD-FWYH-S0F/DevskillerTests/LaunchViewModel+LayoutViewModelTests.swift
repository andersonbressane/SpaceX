//
//  LaunchViewModel+LayoutViewModelTests.swift
//  DevskillerTests
//
//  Created by Anderson Franco on 30/08/2024.
//  Copyright © 2024 Mindera. All rights reserved.
//

import XCTest
@testable import Devskiller

class LaunchLayoutViewModelTests: XCTestCase {

    func testPathStringWithNonNilValue() {
        let links = Launch.Links(article: nil, wikipedia: nil, webcast: nil, patch:  Launch.Links.Patch(small: "https://example.com/patch.png", large: "https://example.com/patch_large.png"))
        
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: nil, dateUTC: nil, success: nil, rocket: nil, links: links)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.pathString, "https://example.com/patch.png")
    }
    
    func testPathStringWithNilValue() {
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: nil, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertNil(viewModel.pathString)
    }

    func testRocketStringWithNonNilValue() {
        let rocket = Launch.Rocket(name: "Falcon 9", type: "FT")
        
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: nil, dateUTC: nil, success: nil, rocket: rocket, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.rocketString, "Falcon 9 / FT")
    }
    
    func testRocketStringWithNilValue() {
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: nil, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.rocketString, "")
    }

    func testMissionNameWithNonNilValue() {
        let launch = Launch(name: "Starlink-15", details: nil, dateLocal: nil, dateUnix: nil, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.missionName, "Starlink-15")
    }
    
    func testMissionNameWithNilValue() {
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: nil, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.missionName, "")
    }

    func testLaunchDateUnixWithNonNilValue() {
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: 1609459200, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.launchDateUnix, 1609459200)
    }

    func testLaunchDate() {
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: 1609459200, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.launchDate, Date(timeIntervalSince1970: 1609459200))
    }
    
    func testLaunchDateTimeStringWithValidDate() {
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: 1609459200, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.launchDateTimeString, "2021-01-01 at 00:00:00")
    }
    
    func testLaunchDateTimeStringWithNilDate() {
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: nil, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.launchDateTimeString, "")
    }

    func testDetailsWithNonNilValue() {
        let launch = Launch(name: nil, details: "This is a test mission.", dateLocal: nil, dateUnix: nil, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.details, "This is a test mission.")
    }
    
    func testDetailsWithNilValue() {
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: nil, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.details, "")
    }

    func testSucceedWithNonNilValue() {
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: nil, dateUTC: nil, success: true, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertTrue(viewModel.succeed)
    }
    
    func testSucceedWithNilValue() {
      let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: nil, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertFalse(viewModel.succeed)
    }

    func testDaysInStringWithPastDate() {
        let pastDate = Date(timeIntervalSinceNow: -86400 * 5)
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: pastDate.timeIntervalSince1970, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.daysInString, "5 days since now")
    }
    
    func testDaysInStringWithFutureDate() {
        let futureDate = Date(timeIntervalSinceNow: 86400 * 5)
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: futureDate.timeIntervalSince1970, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.daysInString, "5 days from now")
    }
    
    func testDaysInStringWithTodayDate() {
        let launch = Launch(name: nil, details: nil, dateLocal: nil, dateUnix: Date().timeIntervalSince1970, dateUTC: nil, success: nil, rocket: nil, links: nil)
        let viewModel = LaunchLayoutViewModel(launch: launch)
        
        XCTAssertEqual(viewModel.daysInString, "Today")
    }
}
