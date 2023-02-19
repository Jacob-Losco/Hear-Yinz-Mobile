
import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: ObservableObject {
    @ObservedObject var oDBFunctions = DBFunctions()
    @Published var aoEventList: [EventModel] = []
    @Published var oLocationRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    init() {
        Task {
            await oDBFunctions.fnInitSessionData()
            let oLocation = await oDBFunctions.fnGetInstitutionCoordinate()
            oLocationRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: oLocation.latitude, longitude: oLocation.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            print(oLocationRegion)
            await oDBFunctions.fnGetInstitutionEvents()
            aoEventList = oDBFunctions.aoEventCache
        }
    }
}
