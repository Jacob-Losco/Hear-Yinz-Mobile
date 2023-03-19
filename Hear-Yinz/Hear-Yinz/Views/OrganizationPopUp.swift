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
    var event: EventModel
    @Binding var bShowPopUp: Bool
    
    var body: some View {
        VStack(spacing: 10){
            
            Image(uiImage: event.om_Image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100) // Adjust size here
            Text(event.sm_HostName) //org.sm_Name
                .font(.custom("DMSans-Regular", size: 24))
                .padding([.leading, .trailing, .bottom])
            Text(event.sm_HostDescription)
                .font(.custom("DMSans-Regular", size: 18))
                .frame(width: 200, alignment: .leading)
                .padding([.leading, .trailing])
            Button{
                bShowPopUp = false
            } label: {
                Image(systemName: "chevron.backward.circle")
            }
            
        }
        .background(Color("highlight"))

        
    }
    
}
