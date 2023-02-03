/*+===================================================================
File: MapOverview.swift

Summary: Opens a Apple Maps overview of Saint Vincent College.

Exported Data Structures: MapView - The view struct

Exported Functions: none

Contributors:
    Keaton Hollobaugh - 02/02/2022 - SP-216
===================================================================+*/


import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.2928, longitude: -79.4021), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
    var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.all)
    }
    
    init() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
           windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
