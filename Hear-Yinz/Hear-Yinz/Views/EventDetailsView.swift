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
    var event: EventModel
    
    var body: some View {
        VStack {
            Text(event.sm_Name)
                .font(.title)
                .padding()
                .font(.custom("DMSans-Regular", size: 18))
            Image(uiImage: event.om_Image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            Text(event.sm_Description)
                .padding()
                .font(.custom("DMSans-Regular", size: 18))
        }
    }
}
