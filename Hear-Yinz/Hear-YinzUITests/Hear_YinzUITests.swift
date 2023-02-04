//
//  Hear_YinzUITests.swift
//  Hear-YinzUITests
//
//  Created by Jacob Losco on 1/16/23.
//

import XCTest

final class Hear_YinzUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testNavToAnnouncements(){
        
        let app = XCUIApplication()
        app.launch()
        app.tabBars["Tab Bar"].buttons["megaphone.fill"].tap()
        
        let announcementsPageStaticText = app.staticTexts["Announcements Page"]
        
        XCTAssert(announcementsPageStaticText.exists)
    }
    func testNavToSettings(){
        
        let app = XCUIApplication()
        app.launch()

        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        
        
        let settingsPageStaticText = app.staticTexts["Settings Page"]
        
        XCTAssert(settingsPageStaticText.exists)
    }
    func testNavToMap(){
        
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["gearshape.fill"].tap()
        tabBar.buttons["Map Pin"].tap()
        
        let vkpointfeatureMap = app/*@START_MENU_TOKEN@*/.maps.containing(.other, identifier:"VKPointFeature").element/*[[".maps.containing(.other, identifier:\"Fred Rogers Center\").element",".maps.containing(.other, identifier:\"Saint Vincent College\").element",".maps.containing(.other, identifier:\"St Vincent\").element",".maps.containing(.other, identifier:\"Saint Vincent Cemetery\").element",".maps.containing(.other, identifier:\"VKPointFeature\").element"],[[[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let map = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .map).element
        
        XCTAssert(map.exists)

    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
