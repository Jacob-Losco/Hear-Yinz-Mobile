//
//  MapMarkerView.swift
//  Hear-Yinz
//
//  Created by Jacob Losco on 2/19/23.
//

import SwiftUI

struct MapMarkerView: View {
    var sid: String
    var smapText: String
    var eventModel: EventModel?
    
    var body: some View {
        ZStack {
            Circle().fill(eventModel?.bm_Followed ?? false ? Color.blue : Color.red)
                .frame(width: 30, height: 30)
                .overlay(
                    Image(uiImage: eventModel?.om_Image ?? UIImage(systemName: "questionmark.circle")!)
                        .resizable()
                        .scaledToFit()
                )
                .overlay(
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(eventModel?.bm_Followed ?? false ? Color.blue : Color.red)
                )
        }
        .offset(x: 0, y: -10)
        .accessibilityIdentifier(sid)
    }
    
    init(id: String, mapText: String, eventModel: EventModel? = nil) {
        self.sid = id
        self.smapText = mapText
        self.eventModel = eventModel
    }
    
    struct MapMarkView_Preview: PreviewProvider {
        static var previews: some View {
            MapMarkerView(id: "test", mapText: "Test")
        }
    }
}
