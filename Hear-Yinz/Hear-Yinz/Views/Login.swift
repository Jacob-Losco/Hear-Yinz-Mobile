/*+===================================================================
File: Login.swift

Summary: View for login access to mobile app. Currently uses button to login, form will be implemented next sprint

Exported Data Structures: Login - the view itself

Exported Functions: None

Contributors:
    Sarah Kudrick - 2/9/2023 - SP-454
    Jacob Losco - 1/31/2023 - SP-365

===================================================================+*/

import SwiftUI
import FirebaseAuth

struct Login: View {
    @ObservedObject var networkManager = NetworkManager() //watches internet connection
    @ObservedObject var oLoginFunctions = LoginFunctions() //contains login functions
    func fnListen() {
        oLoginFunctions.fnListenAuthenticationState()
    }
    @State var sEmailEntry = ""
    @State var sPasswordEntry = ""

    
    var body: some View {
        VStack{
            Text("Hear Yinz!")
                .font(.largeTitle)
                .padding()
            
            TextField("School Email", text: $sEmailEntry)
                .padding()
                .background(Color("highlight"))
                .autocorrectionDisabled(true)
            SecureField("Password", text: $sPasswordEntry)
                .padding()
                .background(Color("highlight"))
            Button{
                
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("selected"))
                        .frame(width: 200, height: 100)
                    Text("Log in")
                        .foregroundColor(Color("highlight"))
                }
                .padding()
            }
            
        }
        VStack {
            if networkManager.isConnected {
                Group {
                    if oLoginFunctions.bm_SignedIn {
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
