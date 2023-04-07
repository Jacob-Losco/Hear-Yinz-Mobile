/*+===================================================================
File: AppDelegate.swift

Summary: An app delegate that is used to manage the locking and orientation of screens in the application

Exported Data Structures: None

Exported Functions: None

Contributors:
    Jacob Losco - 2/4/2022 - SP-220

===================================================================+*/

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: application (NEEDS TO BE NAMED THIS WAY)

      Summary: sets the orientation lock

      Args: UIApplication - reference for application
        window - the window for the application

      Returns: the orientation
    -------------------------------------------------------------------F*/
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
//    func applicationWillResignActive(_ application: UIApplication) {
//        LoginFunctions().fnLogout()
//    }
}
