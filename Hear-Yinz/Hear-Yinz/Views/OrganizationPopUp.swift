//
//  OrganizationPopUp.swift
//  Hear-Yinz
//
//  Created by Sarah Kudrick on 3/8/23.
//

import SwiftUI

struct OrganizationPopUp: View {
    @Environment(\.presentationMode) var presentationMode
    
    //var org: OrganizationModel
    //@State var oSelectedOrgID: String? = nil
    
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
                
            } label: {
                Image(systemName: "chevron.backward.circle")
            }
            
        }
        .background(Color("highlight"))
        
    }
    
    
    
    struct OrganizationPopUp_Previews: PreviewProvider {
        static var previews: some View {
            OrganizationPopUp()
        }
    }
}
