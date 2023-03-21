/*+===================================================================
File: Login.swift

Summary: View for login access to mobile app.

Exported Data Structures: Login - the view itself

Exported Functions: None

Contributors:
    Sarah Kudrick - 2/25/23 - adding dm sans
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

    //@State var sloginStatus: String = "Log in below"

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
                        .font(.custom("DMSans-Regular", size: 46))
                        .padding()
                    
                    Text(sloginStatus)
                        .font(.custom("DMSans-Regular", size: 18))
                        .padding()
                    
                    TextField("School Email", text: $sEmailEntry)
                        .padding()
                        .background(Color("highlight"))
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                        .accessibilityIdentifier("EmailTextField")
                    SecureField("Password", text: $sPasswordEntry)
                        .padding()
                        .background(Color("highlight"))
                        .accessibilityIdentifier("PasswordSecureField")
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
                                .frame(width: 300, height: 100)
                                .shadow(radius: 10)
                                .padding()
                            Text("Log in")
                                .font(.custom("DMSans-Regular", size: 36))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                        }
                        .padding()
                    }.onAppear{
                        sloginStatus="Log in below"
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
