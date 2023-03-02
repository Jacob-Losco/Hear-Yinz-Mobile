/*+===================================================================
File: SettingsView


Summary: View for settings screen


Exported Data Structures: SettingsView - the view itself


Exported Functions: None


Contributors:
    Sarah Kudrick - 3/2/23 - SP-256
    Jacob Losco - 2/4/2023 - SP-220


===================================================================+*/


import SwiftUI


struct SettingsView: View {
    @ObservedObject var oLoginFunctions = LoginFunctions() //contains login functions
    @ObservedObject var oDBFunctions = DBFunctions() //contains login functions
    //oDBFunctions.fnInitSessionData()
    //oDBFunctions.fnGetBlockedOrganizations()
    @State var aoBlockedList: [OrganizationModel] = []
    @State var isClicked: Bool = false


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
                        .frame(width: 350, height: 100)
                        .shadow(radius: 10)
                        .padding()
                    Text("Log out")
                        .font(.custom("DMSans-Regular", size: 36))
                        .fontWeight(.semibold)
                        .foregroundColor(Color("highlight"))
                }
                .padding()
            }
            //Spacer()
            Text("Blocked Organizations")
                .font(.custom("DMSans-Regular", size: 24))
            //UnblockRowView()
            //UnblockRowView()
            //UnblockRowView()
            
            List(aoBlockedList, id: \.sm_Id){ org in
                //if(aoBlockedList.contains(org)){
                UnblockRowView(oOrganization: org, id: org.sm_Id, name: org.sm_Name)
                //}
            }
            
            Spacer()
          
            Rectangle() //Adds custom color background to tab bar.
                .fill(Color.clear)
                .frame(height: 10)
                .background(Color("highlight"))


        }.task{
            await oDBFunctions.fnInitSessionData()
            await oDBFunctions.fnGetBlockedOrganizations()
            aoBlockedList = oDBFunctions.aoOrganizationList
            }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}



