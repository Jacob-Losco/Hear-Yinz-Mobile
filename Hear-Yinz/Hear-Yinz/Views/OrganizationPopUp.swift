/*+===================================================================
File: OrganizationPopUp.swift

Summary: Opens a panel when organization image on EventDetailsView is clicked. displays organization information.

Exported Data Structures:

Exported Functions: none

Contributors:
    Sarah Kudrick - 3/8/2023 - SP-450
===================================================================+*/
import SwiftUI

struct OrganizationPopUp: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var org: OrganizationModel!
    @StateObject var oDBFunctions = DBFunctions()
    @State var sSelectedOrgID: String
    
    var body: some View {
        VStack(spacing: 10){
            //background(Color("highlight"))
            
            Image(systemName: "questionmark.square")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100) // Adjust size here
            Text(org.sm_Name)
                .font(.custom("DMSans-Regular", size: 24))
                .padding([.leading, .trailing, .bottom])
            Text("Organization description that describes the organization, what they do, the events they host, and other pertinent information that will compel students to join their club")
                .font(.custom("DMSans-Regular", size: 18))
                .frame(width: 200, alignment: .leading)
                .padding([.leading, .trailing])
            Button{
                
            } label: {
                Image(systemName: "chevron.backward.circle")
            }
            
        }
        .background(Color("highlight"))
        .task{
            await oDBFunctions.fnInitSessionData()
            await oDBFunctions.fnGetOrganization(sOrganizationName: sSelectedOrgID)
            await oDBFunctions.fnInitSessionData()
            org = oDBFunctions.aoOrganizationList[0]
            
        }
        
        
    }
    
}
