/*+===================================================================
 File: Hear_YinzUITests.swift
 
 Summary: File containing UI Test Suites for application

===================================================================+*/

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
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testLogin

      Target: Login page

      Assertions:
      the form will be deactivated if the password field is empty
      entering the correct username and password and clicking login results in launch of map and navbar

      Writer: Sarah Kudrick
    -------------------------------------------------------------------T*/
    func testLogin(){
        let app = XCUIApplication()
        app.launch()
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.buttons["Log in"].tap()
        XCTAssert(app.staticTexts["Log in below"].exists)
        //tests form validation
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        XCTAssert(app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists)
        //tests correct login opens up access to map and other views
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()
        
    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testIncorrectLogin

      Target: Login page

      Assertions:
      entering an incorrect password will display a message that the login is incorrect
      changing to a correct password will allow login

      Writer: Sarah Kudrick
    -------------------------------------------------------------------T*/
    func testIncorrectLogin(){

        let app = XCUIApplication()
        app.launch()
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }

        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("wrong")
        app.buttons["Log in"].tap()
        XCTAssert(app.buttons["Log in"].exists)
        app.staticTexts["Incorrect login"].tap()
        XCTAssert(app.staticTexts["Incorrect login"].exists)
        //tests that incorrect login displays message and doesn't allow access to other views
        var deleteString = String()
                for _ in "wrong" {
                    deleteString += XCUIKeyboardKey.delete.rawValue
                }
        app.secureTextFields["Password"].typeText(deleteString)
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()


        
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        XCTAssert(app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists)
        //tests correct login opens up access to map and other views
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()
        
    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testNavToAnnouncements

      Target: Navbar

      Assertions: tapping the announcenments icon nav takes the user to the announcements page

      Writer: Sarah Kudrick
    -------------------------------------------------------------------T*/
    func testNavToAnnouncements(){
        let app = XCUIApplication()
        app.launch()
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        }
        
        app.tabBars["Tab Bar"].buttons["megaphone.fill"].tap()
        
        let announcementsPageStaticText = app.staticTexts["Announcements Page"]
        
        XCTAssert(announcementsPageStaticText.exists)
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()
    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testNavToSettings

      Target: Navbar

      Assertions: tapping the settings icon nav takes the user to the settings page

      Writer: Sarah Kudrick
    -------------------------------------------------------------------T*/
    func testNavToSettings(){

        let app = XCUIApplication()
        app.launch()
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        }
        
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        
        
        let settingsPageStaticText = app.staticTexts["Settings Page"]
        
        XCTAssert(settingsPageStaticText.exists)
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()
    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testNavToMap

      Target: Navbar

      Assertions: tapping the map icon nav takes the user to the map page

      Writer: Sarah Kudrick
    -------------------------------------------------------------------T*/
    func testNavToMap(){
        
        let app = XCUIApplication()
        app.launch()
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        }
        
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["gearshape.fill"].tap()
        tabBar.buttons["Map Pin"].tap()
        
        let vkpointfeatureMap = app/*@START_MENU_TOKEN@*/.maps.containing(.other, identifier:"VKPointFeature").element/*[[".maps.containing(.other, identifier:\"Fred Rogers Center\").element",".maps.containing(.other, identifier:\"Saint Vincent College\").element",".maps.containing(.other, identifier:\"St Vincent\").element",".maps.containing(.other, identifier:\"Saint Vincent Cemetery\").element",".maps.containing(.other, identifier:\"VKPointFeature\").element"],[[[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let map = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .map).element
        
        XCTAssert(map.exists)
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()

    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testLogout

      Target: Logout button on setting page

      Assertions:
      tapping the logout button logs user outdisplays login view
      tapping the logout button displays login view

      Writer: Sarah Kudrick
    -------------------------------------------------------------------T*/
    func testLogout(){

        let app = XCUIApplication()
        app.launch()
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        }
        
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        
        
        //let settingsPageStaticText = app.staticTexts["Settings Page"]
        
        //app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()
        XCTAssertFalse(LoginFunctions().bm_SignedIn)
        //tests if user was logged out in firebase
        XCTAssert(app.textFields["School Email"].exists)
        //tests if app is displaying login view
    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testSlider

      Target: Map Slider

      Assertions:
      Slider is enabled on map view
      setting slider and tapping at half position sets label to equal to half a year from today

      Writer: Jacob Losco
    -------------------------------------------------------------------T*/
    func testSlider() {
        
        let app = XCUIApplication()
        app.launch()
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){}
        
        let mapSlider = app.sliders["map_slider"]
        XCTAssertTrue(mapSlider.isEnabled)
        
        var oDateComponent = DateComponents()
        oDateComponent.day = 4
        let oSelectedDate = Calendar.current.date(byAdding: oDateComponent, to: Date.now) ?? Date.now
        let oSelectedDateLabel = oSelectedDate.formatted(.dateTime.day().month().year())
        
        mapSlider.adjust(toNormalizedSliderPosition: 0.01)
        mapSlider.tap()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        }
        
        
        app.buttons["Log out"].tap()
    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testMapMarker

      Target: Map Markers

      Assertions:
      Map Marker TestStatic_Event6 Exists on screen when the slider is at halfway position
     
      Writer: Jacob Losco
    -------------------------------------------------------------------T*/
    func testMapMarker() {
        let app = XCUIApplication()
        app.launch()
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){}
        
        let mapSlider = app.sliders["map_slider"]
        XCTAssertTrue(mapSlider.isEnabled)
        
        mapSlider.adjust(toNormalizedSliderPosition: 0.6)
        
        XCTAssertTrue(app.otherElements.matching(identifier: "Map pin").otherElements["2MfRhGa0Svu80H8jzC1V"].waitForExistence(timeout: 2))
        
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()
    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testSidePanel

      Target: Side Panel

      Assertions:
      Tapping Map Marker for TestStatic_Event6 opens a side panel with the text "TestStatic_Loc1" on it
     
      Writer: Jacob Losco
    -------------------------------------------------------------------T*/
    func testSidePanel() {
        let app = XCUIApplication()
        app.launch()
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){}
        
        let mapSlider = app.sliders["map_slider"]
        XCTAssertTrue(mapSlider.isEnabled)
        
        mapSlider.adjust(toNormalizedSliderPosition: 0.6)
        
        XCTAssertTrue(app.otherElements.matching(identifier: "Map pin").otherElements["2MfRhGa0Svu80H8jzC1V"].waitForExistence(timeout: 2))
        app.otherElements.matching(identifier: "Map pin").otherElements["2MfRhGa0Svu80H8jzC1V"].tap()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
            XCTAssertTrue(app.staticTexts["TestStatic_Loc1"].exists)
        }
        
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()
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
