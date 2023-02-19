/*+===================================================================
File: Login.swift

Summary: View for login access to mobile app.

Exported Data Structures: Login - the view itself

Exported Functions: None

Contributors:
    Sarah Kudrick - 2/12/2023 - SP-455
    Jacob Losco - 1/31/2023 - SP-365

===================================================================+*/

import SwiftUI
import FirebaseAuth

struct Login: View {
    @ObservedObject var oNetworkManager = NetworkManager() //watches internet connection
    @ObservedObject var oLoginFunctions = LoginFunctions() //contains login functions
    
    
    func fnListen() {
        oLoginFunctions.fnListenAuthenticationState()
    }
    @State var sEmailEntry = ""
    @State var sPasswordEntry = ""
    @State var sloginStatus: String = ""
    var bDisableLoginButton: Bool {
        sEmailEntry.isEmpty || sPasswordEntry.isEmpty || !sEmailEntry.contains("@")
        //used to validate form entries before enabling login button
    }

    
    var body: some View {
        Group{
            if oLoginFunctions.bm_SignedIn {
                ContentView()
                
            } else {
                VStack{
                    Text("Hear Yinz!")
                        .font(.largeTitle)
                        .padding()
                    
                    Text(sloginStatus)
                        .padding()
                    
                    TextField("School Email", text: $sEmailEntry)
                        .padding()
                        .background(Color("highlight"))
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                    SecureField("Password", text: $sPasswordEntry)
                        .padding()
                        .background(Color("highlight"))
                    Button{
                        if oNetworkManager.isConnected {
                            oLoginFunctions.fnLogin(sEmail: sEmailEntry, sPassword: sPasswordEntry)
                            if oLoginFunctions.bm_SignedIn {
                                ContentView()
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                                    sloginStatus="Incorrect login"
                                    //this delay prevents the incorrect login message from displaying to user while contentview loads upon correct login
                                }
                            }
                            
                        } else {

                            sloginStatus = "No Internet connection..."

                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color("selected"))
                                .frame(width: 200, height: 100)
                            Text("Log in")
                                .foregroundColor(Color("highlight"))
                        }
                        .padding()
                    }.onAppear{
                        sloginStatus=""
                    }.disabled(bDisableLoginButton)
                    //disabled modifier disables login button until form validation is achieved
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
