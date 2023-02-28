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
        VStack {
            Text(event.sm_Name)
                .font(.title)
                .padding()
                .font(.custom("DMSans-Regular", size: 18))
            Button(action: {
                // Add your upvote action here
            }) {
                Image(systemName: "arrow.up.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(red: 60/255, green: 120/255, blue: 216/255))
            }
            .padding()
            Image(uiImage: event.om_Image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100) // Adjust size here
                .padding()
            Text(event.sm_Description)
                .padding()
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
