/*+===================================================================
File: Hear_YinzApp

Summary: main function for Hear-Yinz mobile application, including firestore initialization

Exported Data Structures: None

Exported Functions: None

Contributors:
    Jacob Losco - 2/4/2022 - SP-220

===================================================================+*/


import SwiftUI
import FirebaseCore

@main
struct Hear_YinzApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Login()
        }
    }
}
