/*+===================================================================
File: OrganizationPopUp.swift

Summary: Opens a panel when organization image on EventDetailsView is clicked. displays organization information.

Exported Data Structures:

Exported Functions: none

Contributors:
    Sarah Kudrick - 3/21/2023 - SP 235, 238, 241
===================================================================+*/
import SwiftUI

struct OrganizationPopUp: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var org: OrganizationModel!
    @StateObject var oDBFunctions = DBFunctions()
    @State var aoBlockedList: [OrganizationModel] = []
    var event: EventModel
    @Binding var bShowPopUp: Bool
    @Binding var bIsFollowing: Bool
    @State var bWasReported: Bool = false
    @State var bWasBlocked: Bool = false


    
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
            HStack{

                Button{ //follow/unfollow button
                    if bIsFollowing{
                        oDBFunctions.fnDeleteRelationshipOrganization(sOrganizationId: event.sm_HostId, iRelationshipType: 1) { success in
                            if success {
                                bIsFollowing = false

                            } else {
                                print("Error at fnDeleteRelationshipOrganization in OrganizationPopUp; unfollow org")
                            }
                        }
                    } else {
                        oDBFunctions.fnCreateRelationshipOrganization(sOrganizationId: event.sm_HostId, iRelationshipType: 1) { success in
                            if success {
                                bIsFollowing = true

                            } else {
                                print("Error at fnCreateRelationshipOrganization in OrganizationPopUp; follow org")
                            }
                        }
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color("button1"))
                            .frame(width: 60, height: 20)
                        Text((bIsFollowing ? "Unfollow" : "Follow"))
                            .font(.custom("DMSans-Regular", size: 12))
                            .foregroundColor(Color.white)
                    }
                }
                Button{ //report button
                    oDBFunctions.fnUpdateEventReports(sEvent: event) { success in
                        if success {
                            bWasReported = true

                        } else {
                            print("Error at fnUpdateEventReports in OrganizationPopUp")
                        }
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color("button2"))
                            .frame(width: 60, height: 20)
                        Text(bWasReported ? "Reported" : "Report")
                            .font(.custom("DMSans-Regular", size: 12))
                            .foregroundColor(Color.white)
                    }
                }.disabled(bWasReported)
                
                Button{ //block button
                    //unfollow org
                    if (bIsFollowing){
                        oDBFunctions.fnDeleteRelationshipOrganization(sOrganizationId: event.sm_HostId, iRelationshipType: 1) { success in
                            if success {
                                bIsFollowing = false

                            } else {
                                print("Error at fnDeleteRelationshipOrganization in OrganizationPopUp; unfollow before blocking org")
                            }
                        }
                    }
                    //block org
                    oDBFunctions.fnCreateRelationshipOrganization(sOrganizationId: event.sm_HostId, iRelationshipType: 2) { success in
                        if success {
                            bWasBlocked = true

                        } else {
                            print("Error at fnCreateRelationshipOrganization in OrganizationPopUp; block org")
                        }
                    }
                    
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color("button3"))
                            .frame(width: 60, height: 20)

                        Text(aoBlockedList.contains(where: { $0.sm_Id == event.sm_HostId })||bWasBlocked ? "Blocked" : "Block")
                            .font(.custom("DMSans-Regular", size: 12))
                            .foregroundColor(Color.white)
                    }
                }.disabled(bWasBlocked)
            }
            Button{
                bShowPopUp = false
            } label: {
                Image(systemName: "chevron.backward.circle")
            }
            
        }.task{
            await oDBFunctions.fnInitSessionData()
            await oDBFunctions.fnGetBlockedOrganizations()
            aoBlockedList = oDBFunctions.aoOrganizationList
            bWasBlocked = aoBlockedList.contains(where: { $0.sm_Id == event.sm_HostId })
            }
        .background(Color("highlight"))

        
    }
    
}
