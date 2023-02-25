/*+===================================================================
File: SettingsView

Summary: View for settings screen

Exported Data Structures: SettingsView - the view itself

Exported Functions: None

Contributors:
    Sarah Kudrick - 2/25/23 - adding DM Sans
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
                        .frame(width: 300, height: 100)
                        .shadow(radius: 10)
                        .padding()
                    Text("Log out")
                        .font(.custom("DMSans-Regular", size: 36))
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
