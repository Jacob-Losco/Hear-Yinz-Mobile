/*+===================================================================
File: MapOverview.swift

Summary: Opens a Apple Maps overview of Saint Vincent College.

Exported Data Structures: MapView - The view struct

Exported Functions: none

Contributors:
    Keaton Hollobaugh - 02/02/2022 - SP-216
    Jacob Losco - 2/4/2022 - SP-220
===================================================================+*/


import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.2928, longitude: -79.4021), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
    var body: some View {
        Group{
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)
        }.onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeRight
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
        .onDisappear {
            DispatchQueue.main.async {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
