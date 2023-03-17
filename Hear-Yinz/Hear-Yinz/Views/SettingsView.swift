/*+===================================================================
File: SettingsView


Summary: View for settings screen


Exported Data Structures: SettingsView - the view itself


Exported Functions: None


Contributors:
    Sarah Kudrick - 3/9/23 - SP-256
    Jacob Losco - 2/4/2023 - SP-220


===================================================================+*/


import SwiftUI


struct SettingsView: View {
    @ObservedObject var oLoginFunctions = LoginFunctions() //contains login functions
    @ObservedObject var oDBFunctions = DBFunctions() //contains login functions
    @State var aoBlockedList: [OrganizationModel] = []
    @State var bIsClicked: Bool = false
    


    var body: some View {
        VStack{

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
                        .foregroundColor(Color.white)
                }
                .padding()
            }

            Text("Blocked Organizations")
                .font(.custom("DMSans-Regular", size: 24))

            
            List(aoBlockedList, id: \.sm_Id){ org in

                HStack {
                    Text(org.sm_Name)
                        .font(.custom("DMSans-Regular", size: 18))
                        .multilineTextAlignment(.center)
                        .padding()
                    Button {
                        bIsClicked = true
                        oDBFunctions.fnDeleteRelationshipOrganization(sOrganizationId: org.sm_Id, iRelationshipType: 2) { success in
                            if success {
                                // Remove the organization from the blocked list
                                aoBlockedList.removeAll(where: { $0.sm_Id == org.sm_Id })
                            } else {
                                print("Error at fnDeleteRelationshipOrganization in UnblockRowView")
                            }
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("button"))
                                .frame(height: 40)
                                .padding(.trailing)
                            Text("Unblock")
                                .font(.custom("DMSans-Regular", size: 18))
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .frame(height: 40, alignment: .center)
                        }
                    }.disabled(bIsClicked)

                }

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



