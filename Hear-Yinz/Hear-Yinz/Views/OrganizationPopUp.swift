/*+===================================================================
File: OrganizationPopUp.swift

Summary: Opens a new view when clicking an organization image to display organization information.

Exported Data Structures:

Exported Functions: none

Contributors:
    Sarah Kudrick - 03/10/2023 - SP-449
===================================================================+*/

import SwiftUI

struct OrganizationPopUp: View {
    @Environment(\.presentationMode) var presentationMode
    
    //var org: OrganizationModel
    //@State var oSelectedOrgID: String? = nil
    @Binding var bShowPopUp: Bool
    
    var body: some View {
        VStack(spacing: 10){
            //background(Color("highlight"))
            
            Image(systemName: "questionmark.square")
                .font(.system(size: 60))
            Text("Organization name")
                .font(.custom("DMSans-Regular", size: 24))
                .padding([.leading, .trailing, .bottom])
            Text("Organization description that describes the organization, what they do, the events they host, and other pertinent information that will compel students to join their club")
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
