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
            Button(action: {}){
                Text(mapText)
            }
        }.offset(x: 0, y: -10)
    }
    
    init(id: String, mapText: String, image: UIImage?) {
        self.id = id
        self.mapText = mapText
        self.omImage = image
    }
}
