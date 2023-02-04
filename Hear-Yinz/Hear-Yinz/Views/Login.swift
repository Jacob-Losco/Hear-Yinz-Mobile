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
    @ObservedObject var networkManager = NetworkManager()
    @ObservedObject var oLoginFunctions = LoginFunctions()
    func fnListen() {
        oLoginFunctions.fnListenAuthenticationState()
    }
    
    var body: some View {
        VStack {
            if networkManager.isConnected {
                Group {
                    if oLoginFunctions.vm_SignedIn {
                        Button("Login") {
                            oLoginFunctions.fnLogin(sEmail: "test@stvincent.edu", sPassword: "test123"
                        )}
                    } else {
                        ContentView()
                    }
                }
            } else {
                VStack {
                    Text("No Internet Connection...")
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
