/*+===================================================================
File: EventDetailsView.swift

Summary: Opens a SidePanel when clicking a map marker to display event information.

Exported Data Structures:

Exported Functions: none

Contributors:
    Keaton Hollobaugh - 02/26/2023 - SP229/230
    Sarah Kudrick - 03/08/2023 - SP450
===================================================================+*/

import SwiftUI

struct EventDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var oDBFunctions = DBFunctions()
    @State private var isButtonDisabled = false // Reactive state variable for button disabled state
    var event: EventModel
    @Binding var bShowPopUp: Bool

    @State var oSelectedOrg: OrganizationModel? = nil

    var body: some View {
        VStack(spacing: 10) {
            Text(event.sm_Name)
                .font(.title)
                .font(.custom("DMSans-Regular", size: 18))
            HStack {
                Button(action: {
                    if !isButtonDisabled {
                        event.im_Likes += 1 // Increment the number of likes
                        isButtonDisabled = true // Disable the button after it's been clicked
                        oDBFunctions.fnUpdateEventLikes(sEvent: event) { success in
                            if !success {
                                event.im_Likes -= 1 // Decrement the number of likes if update fails
                                isButtonDisabled = false // Re-enable the button if update fails
                            }
                        }
                    }
                }) {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(red: 60/255, green: 120/255, blue: 216/255))
                }
                .disabled(isButtonDisabled) // Disable the button if isButtonDisabled is true
                .accessibilityIdentifier("like_button")
                Text("\(event.im_Likes)") // Display the number of likes
                    .font(.custom("DMSans-Regular", size: 18))
                    .accessibilityIdentifier("likes_Label")
            }
            Text(event.sm_LocationName)
                .font(.custom("DMSans-Regular", size: 18))
            Text(DateFormatter.localizedString(from: event.om_DateEvent, dateStyle: .medium, timeStyle: .short))
                .font(.custom("DMSans-Regular", size: 18))
            Text(event.sm_Description)
                .font(.custom("DMSans-Regular", size: 18))

            ZStack{
                Button{
                    bShowPopUp = true
                    //oSelectedOrgID = event.sm_HostId
                    //OrganizationPopUp()
                        //.offset(x: UIScreen.main.bounds.width / 2 - 450)
                        //.transition(.move(edge: .trailing))
                        //.animation(.easeInOut)
                } label: {
                    VStack{
                        Image(uiImage: event.om_Image!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100) // Adjust size here
                        Text(event.sm_HostName)
                            .font(.custom("DMSans-Regular", size: 18))
                    }
                    //if let org... goes here (I will delete this comment before I merge the finished control into main)

                }
                //if (bShowPopUp){
                    //OrganizationPopUp()
                //}
            }
            
        }
        .task {
            await oDBFunctions.fnInitSessionData()
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        )
    }
}
