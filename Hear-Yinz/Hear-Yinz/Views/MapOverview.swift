/*+===================================================================
File: MapOverview.swift

Summary: Opens a Apple Maps overview of Saint Vincent College.

Exported Data Structures: MapView - the view itself

Exported Functions: none

Contributors:
    Keaton Hollobaugh - 02/02/2023 - SP-216
    Jacob Losco - 2/4/2023 - SP-220
    Keaton Hollobaugh - 02/08/2023 - SP-227
===================================================================+*/

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @ObservedObject var oDBFunctions = DBFunctions()
    @State private var oRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    @State private var aoEventCache: [EventModel] = []
    
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
                ForEach(aoEventCache, id: \.id) { event in
                    let coordinate = CLLocationCoordinate2D(latitude: event.om_LocationCoordinate.latitude, longitude: event.om_LocationCoordinate.longitude)
                    MapAnnotation(coordinate: coordinate, mapText: event.sm_HostName, omImage: event.om_Image)
                    }
                }
            }.onAppear {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeRight
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
                self.aoEventCache = self.oDBFunctions.aoEventCache // update the state with the initial value
                
            }
            .onDisappear {
                DispatchQueue.main.async {
                    AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                    UINavigationController.attemptRotationToDeviceOrientation()
                }
            }
            .task {
                await oDBFunctions.fnInitSessionData()
                await oDBFunctions.fnGetInstitutionEvents()
                self.aoEventCache = self.oDBFunctions.aoEventCache // update the state with the latest value
            }
        }
    }

// Annotation struct
struct MapAnnotation: View {
    var coordinate: CLLocationCoordinate2D
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
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
