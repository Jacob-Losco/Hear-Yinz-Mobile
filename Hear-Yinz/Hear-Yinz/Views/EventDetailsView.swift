/*+===================================================================
File: EventDetailsView.swift

Summary: Opens a SidePanel when clicking a map marker to display event information.

Exported Data Structures:

Exported Functions: none

Contributors:
    Keaton Hollobaugh - 02/26/2023 - SP229/230
===================================================================+*/

import SwiftUI

struct EventDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var event: EventModel
    
    var body: some View {
        VStack(spacing: 10) {
            Text(event.sm_Name)
                .font(.title)
                .font(.custom("DMSans-Regular", size: 18))
            Button(action: {
                // Add your upvote action here
            }) {
                Image(systemName: "arrow.up.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(red: 60/255, green: 120/255, blue: 216/255))
            }
            Text(event.sm_LocationName)
                .font(.custom("DMSans-Regular", size: 18))
            Text(DateFormatter.localizedString(from: event.om_DateEvent, dateStyle: .medium, timeStyle: .short))
                .font(.custom("DMSans-Regular", size: 18))
            Text(event.sm_Description)
                .font(.custom("DMSans-Regular", size: 18))
            Image(uiImage: event.om_Image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100) // Adjust size here
            Text(event.sm_HostName)
                .font(.custom("DMSans-Regular", size: 18))
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

