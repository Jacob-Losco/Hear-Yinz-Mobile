/*+===================================================================
File: MapOverview.swift

Summary: Opens a Apple Maps overview of Saint Vincent College.

Exported Data Structures: MapView - the view itself

Exported Functions: none

Contributors:
    Keaton Hollobaugh - 02/02/2023 - SP-216
    Jacob Losco - 2/4/2023 - SP-220
===================================================================+*/


import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @State private var oRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.2928, longitude: -79.4021), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    var body: some View {
        
        Group{
            ZStack {
                Map(coordinateRegion: $oRegion)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Spacer()
                    Rectangle() //Adds custom color background to tab bar.
                        .fill(Color.clear)
                        .frame(height: 10)
                        .background(Color("highlight"))
                }
                
                // Add the annotation to the map
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.2928, longitude: -79.4021))
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
}

// Annotation struct
struct MapAnnotation: View {
    var coordinate: CLLocationCoordinate2D
    
    var body: some View {
        ZStack {
            Circle().fill(Color.red).frame(width: 20, height: 20)
        }.offset(x: 0, y: -10)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
