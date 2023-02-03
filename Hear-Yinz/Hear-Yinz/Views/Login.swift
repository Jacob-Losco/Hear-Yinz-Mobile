/*+===================================================================
File: Login

Summary: View for login access to mobile app. Currently uses button to login, form will be implemented next sprint

Exported Data Structures: Login - the view struct

Exported Functions: None

Contributors:
    Jacob Losco - 1/31/2022 - SP-365

===================================================================+*/

import SwiftUI
import FirebaseAuth

struct Login: View {
    @ObservedObject var oLoginFunctions = LoginFunctions()
    func fnListen() {
        oLoginFunctions.fnListenAuthenticationState()
    }
    
    var body: some View {
        VStack {
            Group {
                if oLoginFunctions.vm_SignedIn {
                    Button("Login") {
                        oLoginFunctions.fnLogin(sEmail: "test@stvincent.edu", sPassword: "test123"
                    )}
                } else {
                    ContentView()
                    //Changed this from MapView to ContentView because
                    //ContentView now calls MapView
                }
            }
        }.onAppear(perform: fnListen)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
