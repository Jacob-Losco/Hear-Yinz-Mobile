/*+===================================================================
File: LoginFunctions

Summary: Contains functions and vars for user authenitcation in mobile app

Exported Data Structures: bm_SignedIn - returns true if there is a user signed in, false otherwise

Exported Functions: fnLogin - attempts to authenticate user with parameterized email and password
    fnLogout - attempts to logout current user

Contributors:
    Jacob Losco - 1/26/2022 - SP-365

===================================================================+*/

import Foundation
import FirebaseAuth
class LoginFunctions: ObservableObject {
    
    var handle: AuthStateDidChangeListenerHandle?
    @Published var bm_SignedIn = false
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnListenAuthenticationState

      Summary: Sets vm_SignedIn variable to be equal to the current login state

      Args: None

      Returns: None
    -------------------------------------------------------------------F*/
    func fnListenAuthenticationState() {
        handle = Auth.auth().addStateDidChangeListener({ [weak self]  (auth, user) in
            if user != nil {
                self!.bm_SignedIn = true
            } else {
                self!.bm_SignedIn = false
            }
        })
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnLogin

      Summary: Attempts to authenticate a user through firebase

      Args: String sEmail
                - the email of the proposed auth attempt
            String sPassword
                - the password of the proposed auth attempt

      Returns: None
    -------------------------------------------------------------------F*/
    func fnLogin(sEmail: String, sPassword: String) {
        Auth.auth().signIn(withEmail: sEmail, password: sPassword) { result, error in
            guard result != nil, error == nil else {
                return
            }
        }
    }
    
    /*F+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Function: fnLogout

      Summary: Attempts to sign out an authenticated user

      Args: None

      Returns: None
    -------------------------------------------------------------------F*/
    func fnLogout() {
        try? Auth.auth().signOut()
    }
}
