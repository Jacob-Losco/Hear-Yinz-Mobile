/*+===================================================================
File: SettingsView

Summary: View for settings screen

Exported Data Structures: SettingsView - the view itself

Exported Functions: None

Contributors:
    Sarah Kudrick - 2/25/23 - SP-255
    Jacob Losco - 2/4/2023 - SP-220

===================================================================+*/

import SwiftUI

struct SettingsView: View {
    @ObservedObject var oLoginFunctions = LoginFunctions() //contains login functions

    var body: some View {
        VStack{
            //Text("Settings Page")
            //Spacer()
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
            Text("Blocked Organizations")
                .font(.custom("DMSans-Regular", size: 24))
            UnblockRowView()
            UnblockRowView()
            UnblockRowView()
            
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

struct UnblockRowView: View {
    var body: some View {
        HStack{
            Text("Organization name")
                .font(.custom("DMSans-Regular", size: 18))
                .padding()
            Button{
                
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("selected"))
                        .frame(height: 40)
                    Text("Unblock")
                        .font(.custom("DMSans-Regular", size: 18))
                }
            }
        }
    }
}
