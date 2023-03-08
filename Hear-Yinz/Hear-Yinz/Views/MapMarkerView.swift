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
    var omImage: UIImage?
    
    var body: some View {
        ZStack {
            Circle().fill(Color.red).frame(width: 30, height: 30)
        }
        .offset(x: 0, y: -10)
        .accessibilityIdentifier(sid)
    }
    
    init(id: String, mapText: String, image: UIImage?) {
        self.sid = id
        self.smapText = mapText
        self.omImage = image
    }
    
    struct MapMarkView_Preview: PreviewProvider {
        static var previews: some View {
            MapMarkerView(id: "test", mapText: "Test", image: nil)
        }
    }
}
