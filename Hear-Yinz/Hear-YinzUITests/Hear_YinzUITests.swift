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
      Test: loginAutomated

      Target: function that can be called in other test functions to log into app

      Assertions: no assertions, not a test function, but a function to be called in other test functions

      Writer: Sarah Kudrick

    -------------------------------------------------------------------T*/
    func loginAutomated(){
        if(!LoginFunctions().bm_SignedIn){
            LoginFunctions().fnLogin(sEmail: "teststatic_officer@teststatic.edu", sPassword: "test123")
        }
//        let app = XCUIApplication()
//        app.launch()
//        app.textFields["School Email"].tap()
//        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
//        let passwordSecureTextField = app.secureTextFields["Password"]
//        passwordSecureTextField.tap()
//        passwordSecureTextField.typeText("test123")
//        app.buttons["Log in"].tap()
        
    }
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: logoutAutomated

      Target: function that can be called in other test functions to log out of app

      Assertions: no assertions, not a test function, but a function to be called in other test functions

      Writer: Sarah Kudrick

    -------------------------------------------------------------------T*/
    func LogoutAutomated(){
        if(LoginFunctions().bm_SignedIn){
            LoginFunctions().fnLogout()
        }
    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testLoginOne

      Target: Login page (case 1, where login page launches)

      Assertions: entering the correct username and password and clicking login results in launch of map and navbar

      Writer: Sarah Kudrick
    -------------------------------------------------------------------T*/
    func testLoginOne(){
        let app = XCUIApplication()
        app.launch()
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        XCTAssert(app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists)

        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()
        
    }
    
//    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//      Test: testLogin
//
//      Target: Login page (case 2, when map launches)
//
//      Assertions: after logging out, entering the correct username and password and clicking login results in launch of map and navbar
//
//      Writer: Sarah Kudrick
//    -------------------------------------------------------------------T*/
//    func testLoginTwo(){
//
//        let app = XCUIApplication()
//        app.launch()
//
//        let tabBar = app.tabBars["Tab Bar"]
//        tabBar.buttons["gearshape.fill"].tap()
//        app.buttons["Log out"].tap()
//
//        //app.textFields["School Email"].tap()
//        //app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
//        //let passwordSecureTextField = app.secureTextFields["Password"]
//        //passwordSecureTextField.tap()
//        //passwordSecureTextField.typeText("test123")
//        app.buttons["Log in"].tap()
//        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
//        XCTAssert(app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists)
//    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testDisableLoginEmptyEmail

      Target: login page

      Assertions: clicking login button when email textfield is empty has no effect.

      Writer: Sarah Kudrick
    -------------------------------------------------------------------T*/
    func testDisableLoginEmptyEmail(){
        
        let app = XCUIApplication()
        app.launch()
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }
        //app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        //app.buttons["Log out"].tap()


        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        XCTAssert(app.buttons["Log in"].exists)
        XCTAssert(app.staticTexts["Log in below"].exists)
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.buttons["Log in"].tap()
        
  
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        }
        XCTAssert(app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists)

        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()

        

    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testDisableLoginNonEmail

      Target: login page

      Assertions: clicking login button when email textfield doesn't contain "@" has no effect.

      Writer: Sarah Kudrick
    -------------------------------------------------------------------T*/
    func testDisableLoginNonEmail(){

        let app = XCUIApplication()
        app.launch()
        
        let sTestEmail = "noAtSymbol"
        
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText(sTestEmail)
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        XCTAssert(app.buttons["Log in"].exists)
        XCTAssert(app.staticTexts["Log in below"].exists)
        
        var deleteString = String()
                for _ in sTestEmail {
                    deleteString += XCUIKeyboardKey.delete.rawValue
                }
        
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText(deleteString)
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        
        XCTAssert(app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists)
        
        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()
    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testDisableLoginEmptyPassword

      Target: login page

      Assertions: clicking login button when password textfield is empty has no effect.

      Writer: Sarah Kudrick
    -------------------------------------------------------------------T*/
    func testDisableLoginEmptyPassword(){

        let app = XCUIApplication()
        app.launch()
        
        if app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists {
            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
            app.buttons["Log out"].tap()
        }
        
        app.textFields["School Email"].tap()
        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.buttons["Log in"].tap()
        
        XCTAssert(app.buttons["Log in"].exists)
        XCTAssert(app.staticTexts["Log in below"].exists)
        
        //app.textFields["School Email"].tap()
        //app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("test123")
        app.buttons["Log in"].tap()
        
        XCTAssert(app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists)

        app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
        app.buttons["Log out"].tap()
    }
    
    /*T+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Test: testLogin

      Target: Login page (case 2, when map launches)

      Assertions: after logging out, entering the correct username and password and clicking login results in launch of map and navbar

      Writer: Sarah Kudrick
    -------------------------------------------------------------------T*/
//    func testLoginTwo(){
//
//        let app = XCUIApplication()
//        app.launch()
//
//        let tabBar = app.tabBars["Tab Bar"]
//        tabBar.buttons["gearshape.fill"].tap()
//        app.buttons["Log out"].tap()
//
//        app.textFields["School Email"].tap()
//        app.textFields["School Email"].typeText("teststatic_officer@teststatic.edu")
//        let passwordSecureTextField = app.secureTextFields["Password"]
//        passwordSecureTextField.tap()
//        passwordSecureTextField.typeText("test123")
//        app.buttons["Log in"].tap()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
//            app.tabBars["Tab Bar"].buttons["gearshape.fill"].tap()
//            XCTAssert(app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists)
//        }
//        //XCTAssert(app.tabBars["Tab Bar"].buttons["gearshape.fill"].exists)
//    }
    
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
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
