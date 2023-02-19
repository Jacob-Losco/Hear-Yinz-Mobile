//
//  MapMarkerView.swift
//  Hear-Yinz
//
//  Created by Jacob Losco on 2/19/23.
//

import SwiftUI

struct MapMarkerView: View {
    var id: String
    var mapText: String
    var omImage: UIImage?
    
    var body: some View {
        ZStack {
            Circle().fill(Color.red).frame(width: 20, height: 20)
        }.offset(x: 0, y: -10)
    }
    
    init(id: String, mapText: String, image: UIImage?) {
        self.id = id
        self.mapText = mapText
        self.omImage = image
    }
    
    struct MapMarkView_Preview: PreviewProvider {
        static var previews: some View {
            MapMarkerView(id: "test", mapText: "Test", image: nil)
        }
    }
}
