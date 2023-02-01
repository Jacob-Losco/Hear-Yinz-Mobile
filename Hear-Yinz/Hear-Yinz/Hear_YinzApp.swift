/*+===================================================================
File: Hear_YinzApp

Summary: main function for Hear-Yinz mobile application, including firestore initialization

Exported Data Structures: None

Exported Functions: None

Contributors:
    Jacob Losco - 1/20/2022 - SP-316

===================================================================+*/


import SwiftUI
import FirebaseCore

@main
struct Hear_YinzApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Login()
        }
    }
}
