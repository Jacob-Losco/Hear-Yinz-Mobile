/*+===================================================================
File: SettingsView

Summary: View for settings screen

Exported Data Structures: SettingsView - the view itself

Exported Functions: None

Contributors:
    Jacob Losco - 2/4/2023 - SP-220

===================================================================+*/

import SwiftUI

struct SettingsView: View {
    @ObservedObject var oLoginFunctions = LoginFunctions() //contains login functions

    var body: some View {
        VStack{
            Text("Settings Page")
            Spacer()
            Button {
                oLoginFunctions.fnLogout()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("selected"))
                        .frame(width: .infinity, height: 100)
                        .shadow(radius: 10)
                        .padding()
                    Text("Log out")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("highlight"))
                    
                    
                }
                .padding()
            }
            Spacer()
            Rectangle() //Adds custom color background to tab bar.
                .fill(Color.clear)
                .frame(height: 10)
                .background(Color("highlight"))

        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
